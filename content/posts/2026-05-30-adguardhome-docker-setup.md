---
title: AdguardHome容器化部署
author: jinzhiliang
type: post
date: 2026-05-30T06:23:38+00:00
url: /adguardhome-docker-setup/
views:
  - 11
rank_math_og_content_image:
  - 'a:2:{s:5:"check";s:32:"16edec320a670cc09f7b9893f0aa9fee";s:6:"images";a:1:{i:0;i:40;}}'
rank_math_internal_links_processed:
  - 1
wp_statistics_words_count:
  - 90
categories:
  - 运维实践
tags:
  - AdguardHome
  - docker
  - linux

---

  家里有linux主机，于是就想到了现在上网的时候经常有太多的网站会有广告，看看能不能通过自建规则减少广告。听说有AdguardHome可以实现这个功能。那么我们来看看如何部署和使用起来。


## 概述 


  ADGUARDHOME是一款网络级广告和跟踪器拦截DNS服务器，作为一款开源的隐私保护工具，它能够在网络层面为所有设备提供广告过滤和隐私保护功能，无需在每个设备上单独安装客户端软件。通过Docker容器化部署ADGUARDHOME，可以实现快速部署、环境隔离和版本管理，适用于家庭网络、小型企业网络等多种场景。


## PART1 服务端环境准备 

<code>Debian,docker,AdguardHome镜像源
主机IP:192.168.5.200

镜像源可以自行查找</code></pre>


  编写Docker-compose.yml


<code>services:
  adguardhome:
    image: docker.1ms.run/adguard/adguardhome:v0.107.76
    container_name: adguardhome
    restart: unless-stopped
    # 宿主机目录挂载，确保升级或重启时数据不丢失
    volumes:
      - ./ag_work:/opt/adguardhome/work
      - ./ag_conf:/opt/adguardhome/conf
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "8081:8081/tcp"
      - "443:443/tcp"
      - "443:443/udp"
      - "3000:3000/tcp"

</code></pre>


  这里因为我本地环境80端口已经启用了，所以把adguardHome的默认80端口修改成8081了。请自行注意



  启用命令


<code>sudo docker compose up -d</code></pre>


  启动后


<code>dog@debian:~/adguard$ docker ps  |grep adguard
98dd7f0db486   docker.1ms.run/adguard/adguardhome:v0.107.76                                         "/opt/adguardhome/Ad…"   24 hours ago   Up 16 hours             0.0.0.0:53-&gt;53/tcp, 0.0.0.0:53-&gt;53/udp, &#91;::]:53-&gt;53/tcp, &#91;::]:53-&gt;53/udp, 80/tcp, 67-68/udp, 0.0.0.0:443-&gt;443/tcp, &#91;::]:443-&gt;443/tcp, 853/udp, 853/tcp, 3000/udp, 5443/tcp, 0.0.0.0:3000-&gt;3000/tcp, &#91;::]:3000-&gt;3000/tcp, 0.0.0.0:8081-&gt;8081/tcp, 0.0.0.0:443-&gt;443/udp, &#91;::]:8081-&gt;8081/tcp, &#91;::]:443-&gt;443/udp, 5443/udp, 6060/tcp   adguardhome</code></pre>


  访问首页，并设置密码
<figure class="wp-block-image size-large">

<img loading="lazy" decoding="async" width="1024" height="629" src="https://liangjinzhi.com/wp-content/uploads/2026/05/image-1024x629.png" alt="" class="wp-image-40" srcset="https://liangjinzhi.com/wp-content/uploads/2026/05/image-1024x629.png 1024w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-300x184.png 300w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-768x472.png 768w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-1536x943.png 1536w, https://liangjinzhi.com/wp-content/uploads/2026/05/image.png 1601w" sizes="auto, (max-width: 1024px) 100vw, 1024px" /> </figure> 

## 回到首页-设置-DNS设置 


  设置上游DNS服务器，直接粘贴


<code>https:&#47;&#47;dns.alidns.com/dns-query
https://doh.pub/dns-query
https://doh.360.cn/dns-query
114.114.114.114
223.5.5.5</code></pre>

### Bootstrap DNS 服务器 

<code>223.5.5.5
119.29.29.29</code></pre>


  点击保存


### 回到过滤器，自定义过滤规则  


  通过指定域名进行拦截，demo如下


<code>||dns.weixin.qq.com.cn^

应用即可</code></pre>




## PART2 路由器 


  以中兴路由器为例，网络-配置DNS服务器为服务器端的IP。（我这里是192.168.5.200）
<figure class="wp-block-image size-large">

<img loading="lazy" decoding="async" width="1024" height="511" src="https://liangjinzhi.com/wp-content/uploads/2026/05/image-2-1024x511.png" alt="" class="wp-image-47" srcset="https://liangjinzhi.com/wp-content/uploads/2026/05/image-2-1024x511.png 1024w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-2-300x150.png 300w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-2-768x383.png 768w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-2-1536x767.png 1536w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-2.png 1623w" sizes="auto, (max-width: 1024px) 100vw, 1024px" /> </figure> 

## PART3 终端电脑 


  以win10/win11为例



  1.按下 Win + R 键，输入 cmd 并按 Enter 打开命令提示符。<br />2.输入ipconfig /flushdns 刷新DNS缓存
<figure class="wp-block-image size-full is-resized">

<img loading="lazy" decoding="async" width="494" height="311" src="https://liangjinzhi.com/wp-content/uploads/2026/05/image-3.png" alt="" class="wp-image-48" style="width:532px;height:auto" srcset="https://liangjinzhi.com/wp-content/uploads/2026/05/image-3.png 494w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-3-300x189.png 300w" sizes="auto, (max-width: 494px) 100vw, 494px" /> </figure> 


  刷新后，你可以通过以下命令查看当前电脑实际使用的 DNS 服务器地址，确保它确实是你设置的 AdGuardHome 主机 IP
<figure class="wp-block-image size-full">

<img loading="lazy" decoding="async" width="355" height="241" src="https://liangjinzhi.com/wp-content/uploads/2026/05/image-4.png" alt="" class="wp-image-49" srcset="https://liangjinzhi.com/wp-content/uploads/2026/05/image-4.png 355w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-4-300x204.png 300w" sizes="auto, (max-width: 355px) 100vw, 355px" /> </figure> 


  <br />


## 查看效果 


  通过电脑任意访问一个网站如<a href="https://news.qq.com/">https://news.qq.com/</a> 回到查询日志-选择已过滤
<figure class="wp-block-image size-large">

<img loading="lazy" decoding="async" width="1024" height="492" src="https://liangjinzhi.com/wp-content/uploads/2026/05/image-1-1024x492.png" alt="" class="wp-image-42" srcset="https://liangjinzhi.com/wp-content/uploads/2026/05/image-1-1024x492.png 1024w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-1-300x144.png 300w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-1-768x369.png 768w, https://liangjinzhi.com/wp-content/uploads/2026/05/image-1.png 1534w" sizes="auto, (max-width: 1024px) 100vw, 1024px" /> </figure> 







## 参考资料 


  <a href="https://github.com/SeanChang/xuanyuan_docker_proxy/blob/main/blog/adguardhome-docker.md#adguardhome-docker-%E5%AE%B9%E5%99%A8%E5%8C%96%E9%83%A8%E7%BD%B2%E6%8C%87%E5%8D%97">AdguardHome Docker 容器化部署指南</a>



