+++
title = 'windows安装wsl失败'
date = 2026-08-05T22:18:29+08:00
draft = false
categories = ['运维实践']
tags = ['Windows', 'WSL']
+++
C:\Users\yy>wsl --install -d Ubuntu
安装过程中出现错误。分发名称: 'Ubuntu' 错误代码: 0x8000ffff

C:\Users\yy>wsl --update
正在安装: 适用于 Linux 的 Windows 子系统
灾难性故障
设备名	DESKTOP-CH432AQ
处理器	12th Gen Intel(R) Core(TM) i5-12400F   2.50 GHz
机带 RAM	32.0 GB (31.8 GB 可用)
存储	466 GB HDD WDC WD5000AAKX-08ERMA0, 8 GB SSD Msft Virtual Disk, 477 GB SSD BR 512GB
显卡	NVIDIA GeForce RTX 3060 Laptop GPU (12 GB)
设备 ID	65F4DCDC-5059-4AE7-AB42-3D376CCF00CA
产品 ID	00330-80000-00000-AA243
系统类型	64 位操作系统, 基于 x64 的处理器
笔和触控	没有可用于此显示器的笔或触控输入

不复杂，按这个顺序来，重点是**用管理员 PowerShell**，这里搞错了，不是普通 CMD。

先右键开始菜单 → **Windows PowerShell / Terminal 管理员**，执行：

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
bcdedit /set hypervisorlaunchtype auto
```

然后重启电脑。

重启后继续管理员 PowerShell：

```
wsl --update --web-download
wsl --install --web-download -d Ubuntu
```

你这个 `wsl --update` 走 Store 时失败，所以关键是加 `--web-download`，绕过 Microsoft Store 下载。

如果还失败，就手动下载安装：

1. 打开官方 WSL GitHub 最新版：
   https://github.com/microsoft/WSL/releases/latest
2. 下载：`Microsoft.WSL.x64.msixbundle`
3. 双击安装，或管理员 PowerShell 执行：

```
Add-AppxPackage .\Microsoft.WSL.x64.msixbundle
```

1. 再执行：

```
wsl --install --web-download -d Ubuntu
```

微软官方也推荐 `--web-download` 用来绕过 Store 下载 WSL/发行版：
[Microsoft WSL install docs](https://learn.microsoft.com/en-us/windows/wsl/install)