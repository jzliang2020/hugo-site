---
title: 'Nginx  htpasswd防护'
toc: true
date: 2026-07-04
categories:
  - 运维实践
  - 技术笔记
draft: false
---
<p class="wp-block-paragraph">
  今天收到腾讯云的告警信息，原来是昨天部署的grafana被漏洞扫描识别到。
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="355" height="343" src="http://jinzhiliang.top/wp-content/uploads/2026/06/image-41.png" alt="" class="wp-image-181" srcset="/wp-content/uploads/2026/06/image-41.png 355w, /wp-content/uploads/2026/06/image-41-300x290.png 300w" sizes="auto, (max-width: 355px) 100vw, 355px" /> </figure> 
<p class="wp-block-paragraph">
</p>
## 1.安装必要的工具 {.wp-block-heading}
<p class="wp-block-paragraph">
  如果系统提示找不到 <code>htpasswd</code> 命令，请执行以下命令安装工具包：
</p>
<pre class="wp-block-code"><code>sudo apt update && sudo apt install -y apache2-utils</code></pre>
## 2. 生成密码文件 {.wp-block-heading}
<p class="wp-block-paragraph">
  在终端执行以下命令（将 <code>your_username</code> 替换为你想要设置的登录账号名）：
</p>
<pre class="wp-block-code"><code>sudo htpasswd -c /etc/nginx/.htpasswd your_username</code></pre>
<p class="wp-block-paragraph">
  执行后，系统会提示你输入两次密码。
</p>
<p class="wp-block-paragraph">
  <strong>注意</strong>：在输入密码时，终端不会显示任何字符（包括星号），这是正常的 Linux 安全机制。输完按回车即可。
</p>
## 3. 验证文件是否生成 {.wp-block-heading}
<p class="wp-block-paragraph">
  你可以查看一下文件内容，确保它已经生成：
</p>
<pre class="wp-block-code"><code>cat /etc/nginx/.htpasswd</code></pre>
## 4.在 Nginx 中启用 {.wp-block-heading}
<p class="wp-block-paragraph">
  在nginx 在 <code>location /</code> 段落内添加如下内容添加如下：
</p>
<pre class="wp-block-code"><code>auth_basic "Restricted Access";
auth_basic_user_file /etc/nginx/.htpasswd;</code></pre>
## 5.重启 Nginx 使配置生效 {.wp-block-heading}
<pre class="wp-block-code"><code>sudo nginx -t      # 检查配置语法是否正确
sudo systemctl reload nginx</code></pre>
## 6.验证 {.wp-block-heading}<figure class="wp-block-image size-large">
<img loading="lazy" decoding="async" width="1024" height="177" src="http://jinzhiliang.top/wp-content/uploads/2026/06/image-42-1024x177.png" alt="" class="wp-image-182" srcset="/wp-content/uploads/2026/06/image-42-1024x177.png 1024w, /wp-content/uploads/2026/06/image-42-300x52.png 300w, /wp-content/uploads/2026/06/image-42-768x133.png 768w, /wp-content/uploads/2026/06/image-42.png 1259w" sizes="auto, (max-width: 1024px) 100vw, 1024px" /> </figure> 
### 命令解析： {.wp-block-heading}
<ul class="wp-block-list">
  <li>
    <code>-I</code>：只获取 HTTP 头信息（快速查看，不下载网页内容）。
  </li>
  <li>
    <code>-L</code>：跟随重定向（如果服务器返回 301/302，它会自动追踪最终到达的页面）。
  </li>
  <li>
    <code>-w</code>：输出更详细的状态码和内容类型。
  </li>
</ul>
<p class="wp-block-paragraph">
  当浏览器收到 <code>401 Unauthorized</code> 和 <code>WWW-Authenticate</code> 头部时，意味着 Nginx 已经成功接管了该服务的入口。任何自动化扫描器或攻击者在访问该域名时，只会收到这个“未授权”的信号，根本无法触发后面的 Grafana 业务逻辑，也无法探测到具体的服务指纹。
</p>
<p class="wp-block-paragraph">
</p>