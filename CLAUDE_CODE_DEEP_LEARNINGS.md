# Claude Code 深度学习总结

## 核心架构洞察

### 1. 工具系统 - 最值得借鉴
Claude Code 的工具系统设计非常优雅：

**核心接口设计:**
```typescript
// 工具是自治的，有自己的描述、schema、执行逻辑
type Tool = {
  name: string
  description(): Promise<string>  // 动态描述
  prompt(context: ToolUseContext): Promise<string>  // 工具使用指引
  inputSchema: z.ZodType  // 输入验证
  maxResultSizeChars?: number  // 结果大小限制
}
```

**我的改进:**
- 添加工具的 `searchHint` 而非仅靠 name
- 添加工具结果大小限制防止 token 浪费
- 实现统一的工具发现机制

---

### 2. 权限系统 - 安全典范

**分层权限架构:**
1. **规则层** - 用户配置的 allow/deny 规则
2. **模式层** - default/auto/bypass/dontAsk
3. **分类器层** - AI 辅助决策
4. **用户层** - 最终确认

**关键创新:**
- `alwaysAllowRules`, `alwaysDenyRules`, `alwaysAskRules` 分离
- 权限决策理由追踪 (PermissionDecisionReason)
- 路径规范化防绕过 (normalizeCaseForComparison)
- 危险模式预检测

**我的改进:**
- 添加危险命令/路径黑名单
- 实现路径遍历检测
- 添加命令语义分析

---

### 3. Bash 安全 - AST 分析

**命令解析层次:**
```typescript
// 1. 词法分析 - splitCommand_DEPRECATED
// 2. AST 解析 - parseForSecurity (tree-sitter)
// 3. 语义检查 - checkSemantics
// 4. 权限匹配 - matchWildcardPattern
```

**命令分类:**
- 搜索类 (grep, find) - 可折叠
- 列表类 (ls, tree) - 可折叠
- 静默类 (mv, cp, rm) - 成功无输出

**我的改进:**
- 实现命令前缀提取
- 环境变量白名单过滤
- 子命令数量上限保护

---

### 4. 上下文压缩 - 节省 token

**压缩策略:**
```
POST_COMPACT_TOKEN_BUDGET = 50,000 tokens
POST_COMPACT_MAX_FILES_TO_RESTORE = 5 files
POST_COMPACT_MAX_TOKENS_PER_FILE = 5,000 tokens
```

**关键设计:**
- 图片剥离 (stripImagesFromMessages)
- 系统提示词动静分离 (SYSTEM_PROMPT_DYNAMIC_BOUNDARY)
- 工具结果摘要生成

**我的改进:**
- 实现长对话压缩
- 添加媒体文件 token 估算
- 系统提示词分块缓存

---

### 5. Hook 系统 - 扩展性设计

**事件驱动:**
```typescript
HookEvent = 
  | 'PreToolUse'      // 工具执行前
  | 'PostToolUse'     // 工具执行后
  | 'UserPromptSubmit' // 用户提交前
  | 'PermissionDenied' // 权限拒绝
  | 'SessionStart'    // 会话开始
  | 'FileChanged'     // 文件变化
```

**响应协议:**
```typescript
HookResponse = {
  continue?: boolean      // 是否继续
  suppressOutput?: boolean // 隐藏输出
  decision?: 'approve' | 'block'  // 决策
  reason?: string         // 理由
}
```

**我的改进:**
- 实现 pre/post tool hook
- 添加文件变化监听 hook
- 会话生命周期 hook

---

### 6. 多 Agent 协调 - 主从架构

**Agent 类型:**
- `generalPurposeAgent` - 通用任务
- `verificationAgent` - 独立验证
- `exploreAgent` - 深度探索
- `planAgent` - 任务规划

**协调机制:**
```typescript
// 协调者模式 - 主 agent
COORDINATOR_MODE_ALLOWED_TOOLS

// Worker 模式 - 从 agent
ASYNC_AGENT_ALLOWED_TOOLS
```

**我的改进:**
- 实现 Agent 任务分解
- 添加任务验证机制
- 主从 agent 通信协议

---

### 7. 文件编辑 - 专业实现

**编辑算法:**
1. 使用 unified diff (structuredPatch)
2. 弯引号→直引号规范化
3. 末尾空白自动清理
4. 文件编码自动检测

**引号风格保留:**
```typescript
// 检测文件中的引号风格
// 保留到新的编辑中
function preserveQuoteStyle(oldString, actualOldString, newString)
```

**我的改进:**
- 实现智能引号转换
- 添加多文件编辑事务
- 文件编码检测

---

## 十大可落地改进

| # | 改进项 | 来源 | 优先级 |
|---|--------|------|--------|
| 1 | 工具 searchHint + 结果大小限制 | tools.ts | P0 |
| 2 | 危险命令/路径黑名单 | filesystem.ts | P0 |
| 3 | 路径遍历检测 | pathValidation.ts | P0 |
| 4 | Bash 命令语义分析 | bashSecurity.ts | P1 |
| 5 | 环境变量白名单 | bashPermissions.ts | P1 |
| 6 | 系统提示词动静分离 | prompts.ts | P1 |
| 7 | 消息/媒体压缩 | compact.ts | P2 |
| 8 | Hook 事件系统 | hooks.ts | P2 |
| 9 | 多 Agent 协调 | coordinatorMode.ts | P2 |
| 10 | 智能引号转换 | FileEditTool/utils.ts | P3 |

---

## 代码风格亮点

1. **类型安全** - 大量使用 Zod schema 验证
2. **不可变性** - DeepImmutable 类型
3. **错误追踪** - 详细的决策理由
4. **日志规范** - logForDebugging / logEvent 分离
5. **Dead Code Elimination** - 条件编译优化

