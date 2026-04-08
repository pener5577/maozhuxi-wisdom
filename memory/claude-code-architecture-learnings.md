# Claude Code 架构学习笔记
# 来源: NanmiCoder/claude-code-haha (泄露源码, 2026-03-31)

## 一、工具系统设计 (Tool System)

### 1.1 工具接口抽象
```typescript
// 工具定义核心接口
type Tool = {
  name: string
  searchHint?: string
  maxResultSizeChars?: number
  strict?: boolean
  description: () => Promise<string>
  prompt: (context: ToolUseContext) => Promise<string>
  userFacingName: string
  getToolUseSummary: (input: any) => string
  getActivityDescription?: (input: any) => string
  inputSchema: z.ZodType
  isEnabled?: () => boolean
}
```

### 1.2 工具注册模式
- 使用 `getAllBaseTools()` 集中注册所有工具
- 支持 `feature()` 特性开关条件注册
- 工具预设 (`TOOL_PRESETS`) 支持 `--tools default` 等

### 1.3 工具分类
- Shell类: BashTool, PowerShellTool, REPLTool
- 文件类: FileEditTool, FileReadTool, FileWriteTool, GlobTool, GrepTool
- Agent类: AgentTool, TaskCreateTool, TaskStopTool, TeamCreateTool
- Web类: WebSearchTool, WebFetchTool
- MCP类: MCPAuthTool, ReadMcpResourceTool

### 1.4 可借鉴的实现
- 工具描述使用 searchHint 而非仅靠 name
- 工具结果大小限制 (maxResultSizeChars)
- 输入输出的 Zod schema 验证

---

## 二、权限系统 (Permission System)

### 2.1 权限模式
```typescript
type PermissionMode = 
  | 'default'    // 标准权限
  | 'acceptEdits' // 自动接受编辑
  | 'bypassPermissions' // 绕过权限
  | 'dontAsk'    // 不询问
  | 'plan'       // 计划模式
  | 'auto'       // 自动模式 (AI分类器决定)
  | 'bubble'     // 冒泡模式
```

### 2.2 权限规则结构
```typescript
type PermissionRule = {
  source: PermissionRuleSource  // 'userSettings' | 'projectSettings' | 'cliArg' | 'session'
  ruleBehavior: PermissionBehavior  // 'allow' | 'deny' | 'ask'
  ruleValue: PermissionRuleValue  // { toolName, ruleContent? }
}
```

### 2.3 权限检查流程
1. 规则匹配 (Rule matching)
2. 模式检查 (Mode check)
3. 分类器评估 (Classifier evaluation)
4. 用户提示 (User prompt)

### 2.4 危险模式检测
- `DANGEROUS_FILES`: .gitconfig, .bashrc, .zshrc, .mcp.json, .claude.json
- `DANGEROUS_DIRECTORIES`: .git, .vscode, .idea, .claude
- 命令安全性 AST 解析

### 2.5 可借鉴实现
- 路径规范化 (normalizeCaseForComparison) 防止大小写绕过
- 危险目录/文件黑名单
- 基于上下文的权限规则
- 权限决策理由追踪

---

## 三、命令解析与安全 (Bash Security)

### 3.1 AST 解析
- 使用 tree-sitter 解析 bash 命令
- 检查命令语义 (checkSemantics)
- 识别重定向、管道、变量赋值

### 3.2 路径验证
- 路径遍历检测 (containsPathTraversal)
- 沙箱路径检查
- 跨平台路径规范化 (Windows/Unix)

### 3.3 命令分类
```typescript
// 搜索/读取类命令 (可折叠显示)
const BASH_SEARCH_COMMANDS = new Set(['find', 'grep', 'rg', 'ag', 'ack'])

// 列表类命令
const BASH_LIST_COMMANDS = new Set(['ls', 'tree', 'du'])

// 静默类命令 (成功无输出)
const BASH_SILENT_COMMANDS = new Set(['mv', 'cp', 'rm', 'mkdir', 'chmod'])
```

### 3.4 可借鉴实现
- 命令前缀提取 (getSimpleCommandPrefix)
- 环境变量过滤 (SAFE_ENV_VARS)
- 子命令数量限制 (MAX_SUBCOMMANDS_FOR_SECURITY_CHECK = 50)

---

## 四、上下文管理 (Context Management)

### 4.1 压缩系统 (Compact)
```typescript
// 压缩相关常量
POST_COMPACT_MAX_FILES_TO_RESTORE = 5
POST_COMPACT_TOKEN_BUDGET = 50_000
POST_COMPACT_MAX_TOKENS_PER_FILE = 5,000
POST_COMPACT_MAX_TOKENS_PER_SKILL = 5,000
```

### 4.2 系统提示词结构
```typescript
// 静态部分 (可缓存)
- getSimpleIntroSection()
- getSimpleSystemSection()
- getSimpleDoingTasksSection()
- getActionsSection()
- getUsingYourToolsSection()
- getSimpleToneAndStyleSection()
- getOutputEfficiencySection()

// 动态部分 (不可缓存)
- session_guidance
- memory
- mcp_instructions
- scratchpad
- output_style
```

### 4.3 消息规范化
```typescript
// 消息类型
type Message = 
  | AssistantMessage
  | UserMessage
  | SystemMessage
  | AttachmentMessage
  | ProgressMessage
  | ToolUseSummaryMessage
```

### 4.4 可借鉴实现
- SYSTEM_PROMPT_DYNAMIC_BOUNDARY 标记静态/动态分界
- 图片剥离 (stripImagesFromMessages) 节省 token
- 工具结果自动摘要

---

## 五、Hook 系统

### 5.1 Hook 事件类型
```typescript
type HookEvent = 
  | 'PreToolUse'
  | 'PostToolUse'
  | 'PostToolUseFailure'
  | 'UserPromptSubmit'
  | 'PermissionDenied'
  | 'PermissionRequest'
  | 'SessionStart'
  | 'Setup'
  | 'SubagentStart'
  | 'Notification'
  | 'Elicitation'
  | 'CwdChanged'
  | 'FileChanged'
  | 'WorktreeCreate'
```

### 5.2 Hook 响应类型
```typescript
type HookResponse = {
  continue?: boolean
  suppressOutput?: boolean
  decision?: 'approve' | 'block'
  reason?: string
  systemMessage?: string
  hookSpecificOutput?: {...}
}
```

### 5.3 可借鉴实现
- 同步/异步 Hook 支持
- Hook 超时控制
- Hook 优先级和匹配器

---

## 六、多 Agent 协调

### 6.1 Agent 类型
- `generalPurposeAgent` - 通用目的
- `verificationAgent` - 验证/测试
- `exploreAgent` - 代码探索
- `planAgent` - 计划制定
- `claudeCodeGuideAgent` - 使用指南

### 6.2 协调者模式
```typescript
// 协调者可用工具
const COORDINATOR_MODE_ALLOWED_TOOLS = [...]

// Worker 限制
const ASYNC_AGENT_ALLOWED_TOOLS = [...]
```

### 6.3 可借鉴实现
- 主从 Agent 架构
- 子任务 Fork 机制
- 团队协作模式 (Swarm)

---

## 七、文件编辑 (FileEdit)

### 7.1 编辑算法
```typescript
// 使用 unified diff 进行编辑
import { structuredPatch } from 'diff'

// 处理弯引号规范化
const LEFT_SINGLE_CURLY_QUOTE = '''
const RIGHT_SINGLE_CURLY_QUOTE = '''

// 引号风格保留
function preserveQuoteStyle(oldString, actualOldString, newString)
```

### 7.2 文件大小限制
```typescript
const MAX_EDIT_FILE_SIZE = 1024 * 1024 * 1024  // 1GB
```

### 7.3 可借鉴实现
- 弯引号→直引号规范化
- 末尾空白清理
- 编辑前文件编码检测

---

## 八、MCP (Model Context Protocol)

### 8.1 MCP 客户端
```typescript
type McpSdkServerConfig = {
  name: string
  command: string
  args?: string[]
  env?: Record<string, string>
}

type McpServerConfig = {
  type: 'cli' | 'stdio' | 'http'
  command?: string
  url?: string
}
```

### 8.2 MCP 指令管理
- 动态加载服务器指令
- 指令版本管理
- 资源订阅

---

## 九、特性开关 (Feature Flags)

### 9.1 特性列表
```typescript
COORDINATOR_MODE  // 协调者模式
KAIROS           // 助手模式
VOICE_MODE       // 语音模式
WORKFLOW_SCRIPTS // 工作流脚本
PROACTIVE        // 主动模式
BRIDGE_MODE      // 桥接模式
DAEMON           // 守护进程
REACTIVE_COMPACT // 响应式压缩
CONTEXT_COLLAPSE // 上下文折叠
EXPERIMENTAL_SKILL_SEARCH // 技能搜索
UDS_INBOX        // Unix Domain Socket
FORK_SUBAGENT    // 子代理 Fork
BUDDY            // 伙伴模式
```

### 9.2 可借鉴实现
- 使用 `feature()` 函数检查特性
- DCE (Dead Code Elimination) 条件导入
- 环境变量 + GrowthBook 双轨控制

---

## 十、可应用到自己的改进

### 10.1 工具系统
- [ ] 实现工具的 searchHint
- [ ] 添加工具结果大小限制
- [ ] 统一输入输出 Zod schema

### 10.2 权限系统
- [ ] 添加危险文件/目录黑名单
- [ ] 实现路径遍历检测
- [ ] 完善权限规则引擎

### 10.3 Bash 安全
- [ ] 添加命令前缀提取
- [ ] 环境变量白名单
- [ ] 子命令数量限制

### 10.4 上下文管理
- [ ] 实现系统提示词分块
- [ ] 添加消息压缩
- [ ] 图片/媒体剥离

### 10.5 Hook 系统
- [ ] 实现 Hook 事件系统
- [ ] 支持同步/异步 Hook
- [ ] Hook 超时控制

