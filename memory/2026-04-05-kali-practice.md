# Kali 每日学习 - 2026-04-05

## 今日主题：Wireshark/Tshark 网络流量分析

### 1. 工具理解
- **用途**：网络协议分析器，抓取并解析网络流量
- **渗透测试阶段**：信息收集（了解目标网络活动）+ 漏洞分析（识别敏感数据传输）

### 2. 实战操作
- 验证工具安装：`which wireshark tshark` ✅
- 抓取本地 eth0 网卡流量
- 过滤 HTTP/HTTPS/DNS 流量：`tcp port 80 or tcp port 443 or udp port 53`
- 捕获到 DNS 查询（微信相关域名 ilinkai.weixin.qq.com）

### 3. 关键命令

```bash
# 基础抓包（指定接口）
tshark -i eth0

# 抓取特定端口
tshark -i eth0 -f "tcp port 80"

# 显示过滤器（显示特定协议）
tshark -i eth0 -Y "http.request"
tshark -i eth0 -Y "dns"

# 限制抓包数量
tshark -i eth0 -c 10

# 安静模式（不显示实时详情）
tshark -i eth0 -q

# 导出特定字段
tshark -i eth0 -Y "http.request" -T fields -e http.host
```

### 4. 适用场景
- 分析目标网站的请求/响应
- 识别明文传输的敏感数据（HTTP、FTP、Telnet）
- 提取文件传输内容
- DNS 枚举辅助

### 5. 局限
- HTTPS 加密流量无法直接解密（需 MITM 或私钥）
- 需要 root 权限
- 大流量环境可能产生大量数据

### 6. 问题/发现
- tshark 默认以 root 运行会有安全警告（正常）
- 抓包时需要指定正确的网络接口（eth0）