# Kali Linux 每日学习笔记 - 2026-04-08

## 主题：John the Ripper 密码破解工具

### 1. 工具理解

**用途：** 密码哈希破解工具，支持多种哈希格式
**渗透测试阶段：** 密码攻击阶段（Password Attacks）
**应用场景：** 离线密码破解、弱口令检测、渗透测试中的横向移动

### 2. 实战操作

#### 2.1 基本用法 - Wordlist模式
```bash
# 生成测试哈希 (密码: password123)
openssl passwd -6 password123

# 创建测试字典
echo -e "password\npassword123\nadmin\n123456\ntest\nabc123\nletmein" > /tmp/test_wordlist.txt

# 使用wordlist模式破解
john --wordlist=/tmp/test_wordlist.txt /tmp/test_hash.txt

# 查看破解结果
john --show /tmp/test_hash.txt
```
**结果：** 成功破解，密码 `password123`

#### 2.2 Single模式（默认规则）
```bash
john --single /tmp/test_hash.txt
```

#### 2.3 Incremental模式（暴力破解）
```bash
# 数字模式
john --incremental=digits /tmp/test_hash.txt
# 成功破解数字密码 "12345"

# 其他可用模式: alpha, lower, upper, mix, all
```

#### 2.4 常用参数
- `--wordlist=FILE` 指定字典文件
- `--format=FORMAT` 指定哈希格式 (如 md5crypt, sha512crypt, NTLM)
- `--show` 显示已破解密码
- `--list=formats` 列出所有支持的格式
- `--incremental=MODE` 暴力破解模式

#### 2.5 常用格式识别
- Linux Shadow: `sha512crypt` ($6$)
- Linux Shadow旧: `md5crypt` ($1$)
- Windows: `NTLM`
- MySQL: `mysql`

### 3. 关键命令总结

```bash
# 生成测试哈希
openssl passwd -6 <password>

# 破解
john --wordlist=wordlist.txt hash.txt
john --format=sha512crypt hash.txt
john --incremental=digits hash.txt

# 查看结果
john --show hash.txt

# 导出已破解密码
john --show --format=raw-md5 hash.txt > cracked.txt
```

### 4. ClawhHub发现

搜索 "security" 关键词发现以下相关技能：
- `security-scanner` (评分 3.559): 自动安全扫描，整合nmap、nuclei
- `security-auditor` (评分 3.630): 安全审计工具
- `network-scanner` (评分 3.462): 网络扫描

**评估：** security-scanner 整合了常用渗透工具，适合日常使用，但需要时才考虑安装。

### 5. 问题与解决

- **问题:** 初次使用 `--single` 模式未破解成功
- **解决:** 使用 `--wordlist` 模式配合字典成功破解
- **注意:** John需要合适的字典文件，incremental模式适合未知字符类型的短密码