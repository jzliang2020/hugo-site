+++
title = '一次 PHP 后台页面访问慢的排查记录'
date = 2026-08-25T22:03:05+08:00
draft = false
+++

最近处理了一次 PHP 后台页面访问慢的问题。现象是浏览器打开某个后台列表页明显卡顿，页面主请求耗时十几秒，但直接用普通 `curl` 测试接口又很快。这里把排查过程做一个匿名化记录，方便以后遇到类似问题时参考。

## 问题现象

浏览器 DevTools 的 Network 面板里，主文档请求返回 `200`，总耗时约 12 秒，其中几乎全部时间都花在：

```text
Waiting for server response
```

也就是 TTFB 很高。资源下载本身只有毫秒级，所以可以先排除 JS、CSS、图片下载慢这类前端静态资源问题。

一开始在服务器上直接执行：

```bash
curl https://example.com/path/to/page.html
```

返回很快，只有几百毫秒。但后来发现这个测试不准确，因为未携带登录态时返回的是 `302` 跳转，并没有真正进入后台页面。

## 真实请求复现

为了复现浏览器里的慢请求，需要从 Chrome DevTools 中复制真实请求：

```text
Network -> 选中慢的 document 请求 -> Copy -> Copy as cURL
```

复制出来的请求里要重点保留 Cookie，例如：

```bash
curl -L -o /dev/null -s -w \
"code=%{http_code}\nTTFB=%{time_starttransfer}\nTotal=%{time_total}\n" \
"https://example.com/path/to/page.html" \
-b "PHPSESSID=xxx; other_cookie=xxx" \
-H "user-agent: Mozilla/5.0 ..."
```

复测后结果类似：

```text
code=200
TTFB=12.2s
Total=12.2s
```

这说明慢点确实在服务端处理阶段，而不是网络传输阶段。

## 服务器资源情况

查看服务器资源后，情况大致如下：

```text
CPU：负载偏高，2 核机器平均负载接近 2
内存：可用内存还有数 GB，Swap 未使用
磁盘：空间正常
inode：正常
磁盘 IO：iowait 很低，没有明显 IO 阻塞
```

从资源角度看，问题更像是 CPU 或数据库查询压力，而不是内存不足或磁盘打满。

进程层面可以看到 MySQL 占用较高，因此继续往数据库方向排查。

## 慢请求期间抓 SQL

在执行真实 `curl` 请求卡住时，同时执行：

```sql
SHOW FULL PROCESSLIST;
```

观察到后台页面请求期间，数据库正在执行类似 SQL：

```sql
SELECT *
FROM goods_table
WHERE check_status = 0
  AND status = 0
LIMIT 15;
```

以及状态统计 SQL：

```sql
SELECT status, COUNT(*) AS count
FROM demo_table
WHERE status NOT IN (1,2,9,27)
GROUP BY status
ORDER BY count DESC;
```

一个是列表数据查询，一个是页面顶部状态数量统计。两者都指向同一张商品类大表。

## 执行计划确认

继续对这两条 SQL 执行：

```sql
EXPLAIN SELECT *
FROM demo_table
WHERE check_status = 0
  AND status = 0
LIMIT 15;
```

```sql
EXPLAIN SELECT status, COUNT(*) AS count
FROM goods_table
WHERE status NOT IN (1,2,9,27)
GROUP BY status
ORDER BY count DESC;
```

结果显示：

```text
type = ALL
key = NULL
rows ≈ 100 万
Extra = Using where
```

第二条统计 SQL 还出现：

```text
Using temporary; Using filesort
```

这基本确认了问题：相关查询没有命中索引，正在扫描百万级数据。

## 环境索引差异

对比生产环境和测试环境的索引后发现，生产环境存在 `status` 相关索引，而测试环境缺少 `status` / `check_status` 相关索引，只有其他业务字段索引。

也就是说，测试环境的数据量已经达到百万级，但索引配置没有跟上生产环境，导致后台列表页每次打开都要扫大表。

## 初步结论

这次问题的核心不是 PHP 进程本身，也不是服务器内存或磁盘问题，而是：

```text
1. 浏览器真实登录请求 TTFB 约 12 秒，慢在服务端响应。
2. 慢请求期间 MySQL 正在执行商品表列表查询和状态统计查询。
3. 商品表约百万级数据，相关 SQL 执行计划为全表扫描。
4. 测试环境索引与生产环境不一致，缺少 status/check_status 相关索引。
```

## 处理思路

把证据整理给开发或 DBA 确认：

```text
页面 TTFB 证据
慢请求期间的 processlist
慢 SQL
EXPLAIN 执行计划
生产/测试索引差异
服务器 CPU、内存、磁盘、IO 情况
```

建议开发或 DBA 评估是否补充类似索引：

```sql
ALTER TABLE goods_table
ADD INDEX idx_status_checkstatus (status, check_status);
```

如果只需要先补齐生产已有索引，则优先补充 `status` 单列索引。最终方案仍应由开发或 DBA 根据业务查询模式确认。

## 修改后验证方式

索引调整后，需要做三类验证：

第一，重新看执行计划：

```sql
EXPLAIN SELECT *
FROM goods_table
WHERE check_status = 0
  AND status = 0
LIMIT 15;
```

重点观察：

```text
key 是否使用新索引
type 是否从 ALL 变为 ref/range
rows 是否明显下降
```

第二，复测真实页面请求：

```bash
curl -L -o /dev/null -s -w \
"code=%{http_code} TTFB=%{time_starttransfer} Total=%{time_total}\n" \
"https://example.com/path/to/page.html" \
-b "PHPSESSID=xxx"
```

对比优化前后 TTFB 是否从十几秒下降。

第三，观察数据库压力：

```sql
SHOW FULL PROCESSLIST;
```

同时关注服务器 CPU 和 MySQL 占用是否下降。

## 经验总结

这次排查里最容易误判的点是普通 `curl` 很快，但它返回的是 `302`，并没有进入真实后台页面。排查登录态页面慢时，一定要复制浏览器里的真实请求，尤其要带上 Cookie。

另一个关键点是不要一上来就猜 PHP 慢、网络慢或者服务器配置低，而是先用 TTFB 判断慢在哪一段，再用 `processlist` 和 `EXPLAIN` 把问题收敛到具体 SQL 和索引。

百万级表本身不算特别大，但在 2 核测试环境里，如果后台页面每次打开都全表扫描，再叠加统计查询，就很容易出现十几秒的响应延迟。索引、缓存和统计逻辑要随着数据量增长一起补上。