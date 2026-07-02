---
title: Certd全自动证书管理系统
author: jinzhiliang
type: post
date: 2026-06-30T03:28:12+00:00
url: /certd-ssl-auto-renewal-system/
categories:
  - 生产案例

---
## 背景 


  公司网站ssl证书每次需要人工更新ssl证书，网站域名一多就容易出问题，要么操作麻烦，要么就是忘记了。


## 解决方案 


  部署Certd平台，实现


<ul class="wp-block-list">
  <li>
    自动申请证书
  </li>
</ul>

<ul class="wp-block-list">
  <li>
    自动续签
  </li>
</ul>

<ul class="wp-block-list">
  <li>
    统一证书管理
  </li>
</ul>

## 部署方式 


  Docker部署Certd


## 实现效果 

<ul class="wp-block-list">
  <li>
    证书更新从“人工操作” → “自动续期”
  </li>
</ul>

<ul class="wp-block-list">
  <li>
    避免证书过期导致服务中断
  </li>
</ul>

<ul class="wp-block-list">
  <li>
    降低运维维护成本
  </li>
</ul>

## 运行截图  


  首页
<figure class="wp-block-image size-full">

<img loading="lazy" decoding="async" width="1899" height="627" src="https://liangjinzhi.com/wp-content/uploads/2026/06/01-01-2.webp" alt="" class="wp-image-318" /> </figure> 


  证书自动化流水线
<figure class="wp-block-image size-full">

<img loading="lazy" decoding="async" width="1702" height="651" src="https://liangjinzhi.com/wp-content/uploads/2026/06/02.webp" alt="" class="wp-image-319" /> </figure> 


  执行历史记录
<figure class="wp-block-image size-full">

<img loading="lazy" decoding="async" width="1667" height="638" src="https://liangjinzhi.com/wp-content/uploads/2026/06/03.webp" alt="" class="wp-image-320" /> </figure>