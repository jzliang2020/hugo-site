---
title: 一套键鼠操作多终端
toc: true
date: 2026-07-04
categories:
  - 运维实践
draft: false
---
<p class="wp-block-paragraph">
  有时候只有一套键盘鼠标，但是有两个终端需要操作，频繁操作插拨移动键鼠不是很方便操作。这个时候如果可以通过应用程序解决这个问题，何乐而不为呢？
</p>
<p class="wp-block-paragraph">
  这里就引出了input leap
</p>
<p class="wp-block-paragraph">
  <a href="https://github.com/input-leap/input-leap">github</a>上有介绍：Input Leap 是一款模拟 KVM 切换器功能的软件。传统的 KVM 切换器允许用户使用一套键盘和鼠标，通过旋转 KVM 切换器上的旋钮来控制多台计算机。Input Leap 则通过软件实现这一功能，用户只需将鼠标移动到屏幕边缘，或者按下某个按键即可切换到不同的系统。
</p>
<p class="wp-block-paragraph">
</p>
## 准备环境 {.wp-block-heading}
<p class="wp-block-paragraph">
  server:win11，inputleap,有鼠标键盘
</p>
<p class="wp-block-paragraph">
  client:debian13 ，,inputleap,无鼠标键盘
</p>
<p class="wp-block-paragraph">
</p>
## 下载链接 {.wp-block-heading}
<p class="wp-block-paragraph">
  <a href="https://github.com/input-leap/input-leap/releases/download/v3.0.2/InputLeap_3.0.2_windows_qt6.exe">windows-server</a>
</p>
<p class="wp-block-paragraph">
  <a href="https://github.com/input-leap/input-leap/releases/download/v3.0.2/InputLeap_3.0.2_debian12_amd64.deb">debian-client</a>
</p>
## 安装配置过程 {.wp-block-heading}
### windows安装 {.wp-block-heading}
<p class="wp-block-paragraph">
  没有什么特别就一路默认安装就好了。
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="499" height="392" src="/wp-content/uploads/2026/06/image-18.png" alt="" class="wp-image-97" srcset="/wp-content/uploads/2026/06/image-18.png 499w, /wp-content/uploads/2026/06/image-18-300x236.png 300w" sizes="auto, (max-width: 499px) 100vw, 499px" /> </figure> 
<p class="wp-block-paragraph">
  安装好，桌面生成快捷方式
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="75" height="74" src="/wp-content/uploads/2026/06/image-19.png" alt="" class="wp-image-98" /> </figure> 
<p class="wp-block-paragraph">
  启动并配置Configure Server&#8230;
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="512" height="394" src="/wp-content/uploads/2026/06/image-20.png" alt="" class="wp-image-99" srcset="/wp-content/uploads/2026/06/image-20.png 512w, /wp-content/uploads/2026/06/image-20-300x231.png 300w" sizes="auto, (max-width: 512px) 100vw, 512px" /> </figure> 
<p class="wp-block-paragraph">
  点进去
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="819" height="582" src="/wp-content/uploads/2026/06/image-21.png" alt="" class="wp-image-100" srcset="/wp-content/uploads/2026/06/image-21.png 819w, /wp-content/uploads/2026/06/image-21-300x213.png 300w, /wp-content/uploads/2026/06/image-21-768x546.png 768w" sizes="auto, (max-width: 819px) 100vw, 819px" /> </figure> 
<p class="wp-block-paragraph">
  把图标分别进行拖动，确认两个主机之间的位置，最好可以跟实际的屏幕的位置关系一致方便操作，我这里one是windows主机名，debian 是debian的主机名。双击可以修改主机名配置。
</p>
<p class="wp-block-paragraph">
</p>
### debian安装过程 {.wp-block-heading}
<pre class="wp-block-code"><code>sudo apt install ./InputLeap_3.0.2_debian12_amd64.deb -y</code></pre>
<p class="wp-block-paragraph">
  #完成后直接启动
</p>
<pre class="wp-block-code"><code>&lt;strong>input-leap&lt;/strong></code></pre>
<p class="wp-block-paragraph">
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="795" height="510" src="/wp-content/uploads/2026/06/image-22.png" alt="" class="wp-image-101" srcset="/wp-content/uploads/2026/06/image-22.png 795w, /wp-content/uploads/2026/06/image-22-300x192.png 300w, /wp-content/uploads/2026/06/image-22-768x493.png 768w" sizes="auto, (max-width: 795px) 100vw, 795px" /> </figure> 
<p class="wp-block-paragraph">
  这样就完成了。
</p>
<p class="wp-block-paragraph">
</p>
## 排查思路 {.wp-block-heading}
<p class="wp-block-paragraph">
  通过服务管理器查看日志
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="193" height="176" src="/wp-content/uploads/2026/06/image-27.png" alt="" class="wp-image-111" /> </figure> <figure class="wp-block-image size-full"><img loading="lazy" decoding="async" width="802" height="403" src="/wp-content/uploads/2026/06/image-26.png" alt="" class="wp-image-109" srcset="/wp-content/uploads/2026/06/image-26.png 802w, /wp-content/uploads/2026/06/image-26-300x151.png 300w, /wp-content/uploads/2026/06/image-26-768x386.png 768w" sizes="auto, (max-width: 802px) 100vw, 802px" /></figure> 
<p class="wp-block-paragraph">
  如果中途有问题需要停止server并重新配置，排查思路，查看是否监听24800端口
</p>
<pre class="wp-block-code"><code>netstat -ano |findstr :24800</code></pre>
<p class="wp-block-paragraph">
  或者通过任务管理器重启服务进程
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="952" height="445" src="/wp-content/uploads/2026/06/image-25.png" alt="" class="wp-image-104" srcset="/wp-content/uploads/2026/06/image-25.png 952w, /wp-content/uploads/2026/06/image-25-300x140.png 300w, /wp-content/uploads/2026/06/image-25-768x359.png 768w" sizes="auto, (max-width: 952px) 100vw, 952px" /> </figure> 
<p class="wp-block-paragraph">
</p>