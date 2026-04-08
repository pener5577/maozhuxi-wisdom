# 📚 Kali Linux 每日学习笔记
> 学习日期：2026-04-03（周五）
> 学习时长：约 30 分钟

---

## 一、Kali Linux 是什么？

**Kali Linux** 是全球最知名的渗透测试（Penetration Testing）和道德黑客专用 Linux 发行版，由 **Offensive Security** 团队维护。

它的前身是 **BackTrack**，2013 年正式更名为 Kali Linux。

### 🎯 定位
> Kali Linux 不只是一个操作系统，**它是一个完整的安全评估平台**。

### 💡 核心理念
- 开箱即用：预装 600+ 安全工具
- 优化配置：减少设置时间，安全专家坐下来就能干活
- 到处可用：支持 bare metal、虚拟机、WSL、容器、移动端（NetHunter）、云端
- 高度可定制：可以用 live-build 定制自己的 ISO

---

## 二、安装方式（Kali Everywhere）

| 安装方式 | 适用场景 |
|---------|---------|
| **Bare Metal（实体机）** | 需要完整硬件控制、性能最强、适合内置 WiFi 和 GPU |
| **虚拟机（VirtualBox/VMware）** | 最常用，学习实验首选 |
| **WSL（Win-KeX）** | Windows 用户，想在 Windows 里跑 Kali 桌面 |
| **Docker / LXD 容器** | 快速启动，不想要完整 VM 开销 |
| **Kali NetHunter（手机）** | 移动端渗透测试平台 |
| **云端（云服务商）** | 远程渗透测试 |

---

## 三、常用工具速查

### 🔍 1. Nmap（网络扫描之王）

**用途：** 探测主机存活、端口开放、服务识别、漏洞扫描

**常用命令：**
```bash
# 基本扫描（verbose 模式）
nmap -v 192.168.1.1

# 操作系统检测 + 版本检测 + 脚本扫描 + 路由追踪（全开）
nmap -A -sV 192.168.1.1

# 扫描多个 IP
nmap 192.168.1.1-254

# 指定端口扫描
nmap -p 22,80,443 192.168.1.1

# UDP 扫描
nmap -sU 192.168.1.1
```

**相关工具套件：**
- `nping` — 网络 Ping 工具，支持 TCP/UDP 模式
- `ncat` — 网络瑞士军刀（nc 增强版），可做后门、端口转发
- `ndiff` — 扫描结果对比工具（用于监控变化）

---

### 💉 2. Metasploit Framework（漏洞利用框架）

**用途：** 漏洞开发、exploit 执行、 payload 生成、后期渗透

**特点：**
- 世界上使用最广泛的渗透测试框架
- 包含数千个已知漏洞的 exploit
- 支持 Ruby 语言扩展
- 官方免费课程：[Metasploit Unleashed](https://www.offsec.com/metasploit-unleashed/)

**相关工具：**
- `msf-egghunter` — 生成 egghunter shellcode
- `msf-exe2vba` / `msf-exe2vbs` — EXE 转 VBA/VBS 脚本
- `msf-find_badchars` — 查找坏字符（exploit 开发用）
- `msfrpcd` — 远程 RPC 守护进程

---

### 📡 3. Aircrack-ng（无线网络安全工具）

**用途：** WiFi 密码破解、无线流量捕获、握手包分析

**工作流程（WPA/WPA2 破解）：**
```
1. airmon-ng          → 开启网卡监听模式
2. airodump-ng        → 捕获无线流量，收集握手包
3. aireplay-ng        → 发起去认证攻击，加速握手包获取
4. aircrack-ng        → 用字典暴力破解密码
```

**常用命令：**
```bash
# WEP 破解（直接跑）
aircrack-ng all-ivs.ivs

# WPA 破解（需要握手包 + 字典）
aircrack-ng -w password.lst wpa.cap

# 清理捕获文件，提取握手包
wpaclean /root/handshakes.cap wpa-psk-linksys.cap wpa.cap

# 自动破解（wesside-ng）
wesside-ng -i wlan0mon -v de:ad:be:ef:ca:fe
```

**注意：** 所有无线攻击仅限**授权环境**（自己的路由器/靶机环境）中使用！未经授权攻击他人网络是**违法行为**。

---

## 四、Kali Linux 特色功能

- **Kali Undercover Mode** — 把界面伪装成普通 Windows/Mac 的样子，不引人注目
- **Kali NetHunter** — Android 手机渗透测试平台
- **Win-KeX** — Windows Subsystem for Linux 上的 Kali 桌面
- **Metapackages** — 按需安装工具集（如 `kalarm` 物联网测试、`sdr` 无线电测试）
- **官方文档** — docs.kali.org 有完整的工具使用指南

---

## 五、工具分类速览（Kali 600+ 工具）

| 类别 | 代表工具 |
|------|---------|
| 信息收集 | nmap, recon-ng, maltego, theHarvester |
| 漏洞分析 | nikto, openvas, sqlmap |
| Web 攻击 | burpsuite, dirb, hydra |
| 密码攻击 | john, hashcat, medusa, hydra |
| 无线攻击 | aircrack-ng, wifite, reaver |
| 逆向工程 | ghidra, radare2, apktool |
| 漏洞利用 | metasploit, searchsploit |
| 嗅探欺骗 | ettercap, wireshark,Responder |
| 取证 | autopsy, volatility, binwalk |
| 报告生成 | dradis, pipal |

---

## 六、学习建议

1. **先搭实验环境**：用虚拟机装 Kali + 靶机（如 Metasploitable2、DVWA）
2. **从 Nmap 开始**：网络扫描是渗透测试第一步，必须熟练
3. **了解 OWASP Top 10**：Web 安全基础
4. **学习 Linux 基础**：Kali 基于 Debian，命令行是基本功
5. **CTF 平台实战**：TryHackMe、HackTheBox、CTFHub

---

## 七、下一步学习计划

- [ ] 学习 Burp Suite 的基本用法（Web 渗透测试神器）
- [ ] 了解 Wireshark 的抓包和分析
- [ ] 掌握 SQLMap 的基本注入
- [ ] 学习 Hydra 暴力破解工具
- [ ] 搭建自己的渗透测试实验环境

---

> ⚠️ **免责声明：** Kali Linux 是专业安全工具，**仅限授权环境使用**。未经许可扫描、渗透他人系统属于**违法犯罪行为**。学习者请在合乎法规的实验环境中进行练习，如自己的虚拟机、CTF 平台或经授权的靶机环境。
