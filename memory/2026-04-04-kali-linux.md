# Kali Linux 学习笔记

> 日期：2026-04-04

## 什么是 Kali Linux？

Kali Linux 是一个基于 Debian 的渗透测试和安全审计 Linux 发行版。由 Offensive Security 公司维护，是安全行业的事实标准！

### 主要用途
- 渗透测试（Penetration Testing）
- 安全审计与漏洞评估
- 逆向工程
- 取证分析（Forensics）

## 安装方式

Kali 支持多种部署方式：
- 🖥️ **虚拟机** - VMware、VirtualBox、QEMU
- ☁️ **云端** - AWS、Azure、Linode
- 📱 **移动端** - Kali NetHunter（Android）
- 💻 **WSL** - Windows 子系统
- 🐳 **容器** - Docker、LXD
- 🔧 **裸机** - USB Live Boot

## 常用工具分类

### 信息收集
- Nmap（网络扫描）
- Maltego（信息关联）

### 漏洞分析
- OpenVAS
- Nikto

### 密码攻击
- John the Ripper
- Hashcat
- hydra

### 无线攻击
- Aircrack-ng（WiFi 审计）
- Wifite
- Reaver

### Web 攻击
- Burp Suite
- SQLmap
- OWASP ZAP

### 漏洞利用
- **Metasploit** - 最流行的渗透框架

## 重点工具速学

### 🕵️ Nmap（网络扫描器）
```bash
# 基本扫描
nmap 192.168.1.1

# 端口扫描
nmap -p 1-1000 目标IP

# 服务版本检测
nmap -sV 目标IP

# 操作系统检测
nmap -O 目标IP
```

### 💥 Metasploit（渗透框架）
```bash
# 启动
msfconsole

# 搜索漏洞
search exploit/windows/smb

# 使用模块
use exploit/windows/smb/eternalblue

# 设置目标
set RHOST 目标IP

# 攻击
exploit
```

### 📶 Aircrack-ng（WiFi 审计）
```bash
# 查看无线网卡
airmon-ng

# 启用监听模式
airmon-ng start wlan0

# 扫描 WiFi
airodump-ng wlan0mon

# 捕获握手包
airodump-ng -c [channel] --bssid [MAC] -w cap wlan0mon

# 破解密码
aircrack-ng -w wordlist.txt cap-01.cap
```

## 今日学习总结

✅ 了解了 Kali Linux 的定位和用途
✅ 掌握了多种安装方式（虚拟机、云、容器、WSL）
✅ 学习了三剑客：Nmap、Metasploit、Aircrack-ng 的基础用法

> 记住：这些工具仅用于授权的安全测试！未经许可的攻击是违法的 🚫