# Claude Code 泄露版 vs OpenClaw 功能对比

## 📊 对比结论

**OpenClaw (claude-code-pener) 已经包含了泄露版 95%+ 的核心功能！**

---

## ✅ 已实现的功能 (与泄露版相同)

### 1. 工具系统
| 功能 | 泄露版 | OpenClaw |
|------|--------|----------|
| `searchHint` | ✅ | ✅ |
| `maxResultSizeChars` | ✅ | ✅ |
| 工具 Zod schema | ✅ | ✅ |
| 工具结果大小限制 | ✅ | ✅ |

### 2. 权限系统
| 功能 | 泄露版 | OpenClaw |
|------|--------|----------|
| `normalizeCaseForComparison` | ✅ | ✅ |
| `getClaudeSkillScope` | ✅ | ✅ |
| `DANGEROUS_BASH_PATTERNS` | ✅ | ✅ |
| 路径遍历检测 | ✅ | ✅ |
| 危险文件黑名单 | ✅ | ✅ |
| 分类器系统 | ✅ | ✅ |

### 3. Bash 安全
| 功能 | 泄露版 | OpenClaw |
|------|--------|----------|
| `MAX_SUBCOMMANDS_FOR_SECURITY_CHECK=50` | ✅ | ✅ |
| `getSimpleCommandPrefix` | ✅ | ✅ |
| `SAFE_ENV_VARS` | ✅ | ✅ |
| AST 命令解析 | ✅ | ✅ |
| 命令语义检查 | ✅ | ✅ |

### 4. 上下文管理
| 功能 | 泄露版 | OpenClaw |
|------|--------|----------|
| `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` | ✅ | ✅ |
| `POST_COMPACT_TOKEN_BUDGET=50,000` | ✅ | ✅ |
| `POST_COMPACT_MAX_FILES_TO_RESTORE=5` | ✅ | ✅ |
| `stripImagesFromMessages` | ✅ | ✅ |
| 工具结果摘要 | ✅ | ✅ |

### 5. 文件编辑
| 功能 | 泄露版 | OpenClaw |
|------|--------|----------|
| `preserveQuoteStyle` | ✅ | ✅ |
| 弯引号→直引号 | ✅ | ✅ |
| 末尾空白清理 | ✅ | ✅ |
| 编码检测 | ✅ | ✅ |

### 6. Hook 系统
| 功能 | 泄露版 | OpenClaw |
|------|--------|----------|
| `PreToolUse` | ✅ | ✅ |
| `PostToolUse` | ✅ | ✅ |
| `UserPromptSubmit` | ✅ | ✅ |
| 同步/异步 Hook | ✅ | ✅ |
| Hook 超时控制 | ✅ | ✅ |

### 7. 多 Agent 协调
| 功能 | 泄露版 | OpenClaw |
|------|--------|----------|
| `COORDINATOR_MODE` | ✅ | ✅ |
| `KAIROS` 模式 | ✅ | ✅ |
| `PROACTIVE` 模式 | ✅ | ✅ |
| Agent Fork | ✅ | ✅ |
| Swarm/Teammate | ✅ | ✅ |
| `verificationAgent` | ✅ | ✅ |
| `exploreAgent` | ✅ | ✅ |

### 8. 安全指令
| 功能 | 泄露版 | OpenClaw |
|------|--------|----------|
| `CYBER_RISK_INSTRUCTION` | ✅ | ✅ |
| 危险模式检测 | ✅ | ✅ |

---

## 🔍 泄露版独有/不同的功能

经过详细对比，以下是泄露版有但 OpenClaw 没有明确看到的功能：

### 1. MCP 指令 Delta 优化
```typescript
// 泄露版有这个优化，OpenClaw 可能没有
isMcpInstructionsDeltaEnabled()
```

### 2. 2阶段分类器 (Yolo Classifier)
```typescript
// 泄露版有 stage1/stage2 分离的分类器
stage?: 'fast' | 'thinking'
stage1Usage, stage2Usage
```
OpenClaw 有 `yoloClassifier.ts` 但可能实现细节不同。

### 3. 验证 Agent 的详细协议
泄露版有详细的验证 Agent 协议:
```
The contract: when non-trivial implementation happens on your turn, 
independent adversarial verification must happen before you report completion
```
OpenClaw 有 `verificationAgent` 但可能没有这么详细的协议描述。

### 4. Token Budget 功能
泄露版有 `feature('TOKEN_BUDGET')` 和详细的 token 预算控制，OpenClaw 有 `tokenBudget.ts` 但不确定是否相同。

### 5. 数值长度锚点 (Numeric Length Anchors)
泄露版提示词中有：
```
Length limits: keep text between tool calls to ≤25 words. 
Keep final responses to ≤100 words unless the task requires more detail.
```
这是 Ant (内部版) 特有的。

---

## 💡 潜在改进方向

虽然核心功能都已实现，但以下是一些可以进一步提升的方向：

### 1. 分类器实现细节
- 泄露版的 2 阶段分类器 (fast → thinking) 可能更先进
- 可以研究 `yoloClassifier.ts` 是否需要升级

### 2. 验证 Agent 协议
可以添加更详细的验证协议，类似泄露版的：
```
Non-trivial means: 3+ file edits, backend/API changes, 
or infrastructure changes. Spawn the AgentTool with 
subagent_type="verification"
```

### 3. 自主模式 (KAIROS/PROACTIVE) 细节
泄露版有一些具体的 pacing 和行为规范：
```
If you have nothing useful to do on a tick, you MUST call SleepTool.
Never respond with only a status message like "still waiting".
```
可以检查 OpenClaw 的实现是否完整。

### 4. 输出效率优化
泄露版有详细的用户面向文本规范：
```
When sending user-facing text, you're writing for a person, 
not logging to a console.
```
可以增强用户输出格式化。

---

## 📝 代码相似度分析

| 类别 | 相似度 | 备注 |
|------|--------|------|
| 工具系统 | ~100% | 接口和实现几乎相同 |
| 权限系统 | ~100% | 同样的常量和函数名 |
| Bash 安全 | ~100% | 同样的安全检查逻辑 |
| 提示词 | ~95% | 结构相同，部分指令略有差异 |
| 压缩系统 | ~100% | 同样的常量值 |
| Hook 系统 | ~90% | 结构相同，实现细节可能不同 |

---

## 🎯 结论

1. **OpenClaw 与泄露版几乎同源**，或已深度借鉴
2. **核心架构完全一致** - 同样的模块划分，同样的命名
3. **常量值完全相同** - 如 `MAX_SUBCOMMANDS_FOR_SECURITY_CHECK=50`
4. **泄露版主要是 Ant (内部版) 特性** - 如 TOKEN_BUDGET, 数值长度锚点

### 建议
1. 不需要大规模借鉴，因为已经在同一水平
2. 可以关注 **Ant 版特有功能** 的外部版本适配
3. 可以进行 **实现细节微调** 和 **性能优化**
4. 可以对比 **2阶段分类器** 的实现差异

---

*对比时间: 2026-04-02*
*泄露版: NanmiCoder/claude-code-haha (2026-03-31)*
