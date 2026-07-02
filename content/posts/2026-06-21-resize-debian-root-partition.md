---
title: 调整debian根分区为最大空间
author: jinzhiliang
type: post
date: 2026-06-21T04:18:05+00:00
url: /resize-debian-root-partition/
rank_math_internal_links_processed:
  - 1
rank_math_seo_score:
  - 9
rank_math_og_content_image:
  - 'a:2:{s:5:"check";s:32:"e54065f736e7e492bc94a3a5df46daf3";s:6:"images";a:1:{i:0;i:115;}}'
views:
  - 7
wp_statistics_words_count:
  - 53
categories:
  - 技术笔记

---

  安装操作系统的时候配置错了，/home空间分配的空间占了大部分，需要调整为根分区使用最大空间。
<figure class="wp-block-image size-large">

<img loading="lazy" decoding="async" width="1024" height="233" src="https://liangjinzhi.com/wp-content/uploads/2026/06/image-28-1024x233.png" alt="" class="wp-image-115" srcset="https://liangjinzhi.com/wp-content/uploads/2026/06/image-28-1024x233.png 1024w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-28-300x68.png 300w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-28-768x175.png 768w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-28.png 1312w" sizes="auto, (max-width: 1024px) 100vw, 1024px" /> </figure> 


  备份/home目录


<code># 1. 临时备份 home 目录的数据到 /tmp
sudo cp -a /home/* /tmp/ 2>/dev/null

# 2. 卸载 /home 挂载点
sudo umount /home</code></pre>


  切换到其他目录，并停止相关进程，否则不能卸载/home


<code># 杀掉所有占用 /home 的进程
sudo fuser -vkm /home</code></pre>


  调整好后卸载/home


<code># 1. 重新卸载
sudo umount /home

# 2. 删除 home 逻辑卷
sudo lvremove -y /dev/mapper/vm--debian--13--vg-home

# 3. 100% 扩容给根分区
sudo lvextend -l +100%FREE /dev/mapper/vm--debian--13--vg-root

# 4. 刷新文件系统
sudo resize2fs /dev/mapper/vm--debian--13--vg-root

# 5. 清理 fstab 挂载配置
sudo sed -i '/vm--debian--13--vg-home/d' /etc/fstab</code></pre>


  这样就好了
<figure class="wp-block-image size-large">

<img loading="lazy" decoding="async" width="1024" height="237" src="https://liangjinzhi.com/wp-content/uploads/2026/06/image-29-1024x237.png" alt="" class="wp-image-116" srcset="https://liangjinzhi.com/wp-content/uploads/2026/06/image-29-1024x237.png 1024w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-29-300x70.png 300w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-29-768x178.png 768w, https://liangjinzhi.com/wp-content/uploads/2026/06/image-29.png 1182w" sizes="auto, (max-width: 1024px) 100vw, 1024px" /> </figure> 


