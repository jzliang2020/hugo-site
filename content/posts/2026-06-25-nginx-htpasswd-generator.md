---
title: 'Nginx  htpasswd防护'
author: jinzhiliang
type: post
date: 2026-06-25T03:01:36+00:00
url: /nginx-htpasswd-generator/
rank_math_internal_links_processed:
  - 1
rank_math_seo_score:
  - 9
rank_math_primary_category:
  - 21
wp_statistics_words_count:
  - 52
rank_math_og_content_image:
  - 'a:2:{s:5:"check";s:32:"058e7f6649f8831359d891eac64e59fd";s:6:"images";a:1:{i:0;i:181;}}'
views:
  - 2
categories:
  - 技术笔记
tags:
  - htpasswd
  - nginx
  - 漏洞

---

  今天收到腾讯云的告警信息，原来是昨天部署的grafana被漏洞扫描识别到。
<figure class="wp-block-image size-full">

<img loading="lazy" decoding="async" width="355" height="343" src="http://jinzhiliang.top/wp-content/uploads/2026/06/image-41.png" alt="" class="wp-image-181" srcset="https://liangjinzhi.com/wp-content/uploads/2026/06/image-41.png 355w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-41-300x290.png 300w" sizes="auto, (max-width: 355px) 100vw, 355px" /> </figure> 




## 1.安装必要的工具 


  如果系统提示找不到 <code>htpasswd</code> 命令，请执行以下命令安装工具包：


<code>sudo apt update && sudo apt install -y apache2-utils</code></pre>

## 2. 生成密码文件 


  在终端执行以下命令（将 <code>your_username</code> 替换为你想要设置的登录账号名）：


<code>sudo htpasswd -c /etc/nginx/.htpasswd your_username</code></pre>


  执行后，系统会提示你输入两次密码。



  <strong>注意</strong>：在输入密码时，终端不会显示任何字符（包括星号），这是正常的 Linux 安全机制。输完按回车即可。


## 3. 验证文件是否生成 


  你可以查看一下文件内容，确保它已经生成：


<code>cat /etc/nginx/.htpasswd</code></pre>

## 4.在 Nginx 中启用 


  在nginx 在 <code>location /</code> 段落内添加如下内容添加如下：


<code>auth_basic "Restricted Access";
auth_basic_user_file /etc/nginx/.htpasswd;</code></pre>

## 5.重启 Nginx 使配置生效 

<code>sudo nginx -t      # 检查配置语法是否正确
sudo systemctl reload nginx</code></pre>

## 6.验证 <figure class="wp-block-image size-large">

<img loading="lazy" decoding="async" width="1024" height="177" src="http://jinzhiliang.top/wp-content/uploads/2026/06/image-42-1024x177.png" alt="" class="wp-image-182" srcset="https://liangjinzhi.com/wp-content/uploads/2026/06/image-42-1024x177.png 1024w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-42-300x52.png 300w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-42-768x133.png 768w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-42.png 1259w" sizes="auto, (max-width: 1024px) 100vw, 1024px" /> </figure> 

### 命令解析： 

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


  当浏览器收到 <code>401 Unauthorized</code> 和 <code>WWW-Authenticate</code> 头部时，意味着 Nginx 已经成功接管了该服务的入口。任何自动化扫描器或攻击者在访问该域名时，只会收到这个“未授权”的信号，根本无法触发后面的 Grafana 业务逻辑，也无法探测到具体的服务指纹。



