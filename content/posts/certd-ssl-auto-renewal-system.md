---
title: Certd全自动证书管理系统
toc: true
date: 2026-07-04
categories:
  - 运维实践
draft: false
---
## 背景
<p class="wp-block-paragraph">
  公司网站ssl证书每次需要人工更新ssl证书，网站域名一多就容易出问题，要么操作麻烦，要么就是忘记了。
</p>
## 解决方案 {.wp-block-heading}
<p class="wp-block-paragraph">
  部署Certd平台，实现
</p>
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
## 部署方式 {.wp-block-heading}
<p class="wp-block-paragraph">
  Docker部署Certd
</p>
## 实现效果 {.wp-block-heading}
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
## 运行截图  {.wp-block-heading}
<p class="wp-block-paragraph">
  首页
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="1899" height="627" src="/wp-content/uploads/2026/06/01-01-2.webp" alt="" class="wp-image-318" /> </figure> 
<p class="wp-block-paragraph">
  证书自动化流水线
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="1702" height="651" src="/wp-content/uploads/2026/06/02.webp" alt="" class="wp-image-319" /> </figure> 
<p class="wp-block-paragraph">
  执行历史记录
</p><figure class="wp-block-image size-full">
<img loading="lazy" decoding="async" width="1667" height="638" src="/wp-content/uploads/2026/06/03.webp" alt="" class="wp-image-320" /> </figure>