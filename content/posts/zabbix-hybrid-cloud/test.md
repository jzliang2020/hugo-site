---
title: 一套键鼠操作多终端1111
toc: true
date: 2026-07-04
categories:
  - 运维实践
tags:
  - Input Leap
  - Windows
  - Debian
  - KVM
draft: false
---

有时候只有一套键盘鼠标，但是有两个终端需要操作，频繁操作插拔、移动键鼠不是很方便操作。这个时候如果可以通过应用程序解决这个问题，何乐而不为呢？

这里就引出了 **Input Leap**。

[GitHub](https://github.com/input-leap/input-leap) 上有介绍：Input Leap 是一款模拟 KVM 切换器功能的软件。传统的 KVM 切换器允许用户使用一套键盘和鼠标，通过旋转 KVM 切换器上的旋钮来控制多台计算机。Input Leap 则通过软件实现这一功能，用户只需将鼠标移动到屏幕边缘，或者按下某个按键即可切换到不同的系统。

## 准备环境

* **Server：** Windows 11，Input Leap，有鼠标键盘
* **Client：** Debian 13，Input Leap，无鼠标键盘

## 下载链接

* [Windows Server](https://github.com/input-leap/input-leap/releases/download/v3.0.2/InputLeap_3.0.2_windows_qt6.exe)
* [Debian Client](https://github.com/input-leap/input-leap/releases/download/v3.0.2/InputLeap_3.0.2_debian12_amd64.deb)

## 安装配置过程

### Windows 安装

没有什么特别的，一路默认安装就好了。

![Windows 安装](/wp-content/uploads/2026/06/image-18.png)

安装好后，桌面生成快捷方式。

![Input Leap 快捷方式](/wp-content/uploads/2026/06/image-19.png)

启动并配置 `Configure Server...`

![配置 Server](/wp-content/uploads/2026/06/image-20.png)

点进去。

![Server 配置界面](/wp-content/uploads/2026/06/image-21.png)

把图标分别进行拖动，确认两个主机之间的位置，最好可以跟实际的屏幕位置关系一致，方便操作。

我这里 `one` 是 Windows 主机名，`debian` 是 Debian 的主机名。双击可以修改主机名配置。

### Debian 安装过程

```bash
sudo apt install ./InputLeap_3.0.2_debian12_amd64.deb -y
```

完成后直接启动：

```bash
input-leap
```

![Debian Input Leap](/wp-content/uploads/2026/06/image-22.png)

这样就完成了。

## 排查思路

通过服务管理器查看日志。

![服务管理器](/wp-content/uploads/2026/06/image-27.png)

![服务日志](/wp-content/uploads/2026/06/image-26.png)

如果中途有问题，需要停止 Server 并重新配置。排查思路：查看是否监听 `24800` 端口。

```powershell
netstat -ano | findstr :24800
```

或者通过任务管理器重启服务进程。

![任务管理器](/wp-content/uploads/2026/06/image-25.png)
