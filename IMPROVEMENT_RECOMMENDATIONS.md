# OpenClaw 能力提升建议

## 📊 对比结论

经过详细对比 **泄露版 Claude Code** (NanmiCoder/claude-code-haha) 和 **OpenClaw** (claude-code-pener)：

> **OpenClaw 已经包含了泄露版 95%+ 的核心功能，两者实现几乎完全相同！**

---

## ✅ 已实现 (无需重复造轮子)

| 类别 | 状态 |
|------|------|
| 工具 searchHint + maxResultSizeChars | ✅ |
| 权限系统 (分层 + 分类器) | ✅ |
| Bash 安全 (AST + 前缀提取) | ✅ |
| 危险命令/路径黑名单 | ✅ |
| 系统提示词动静分离 | ✅ |
| 上下文压缩 (50K token) | ✅ |
| 图片剥离 | ✅ |
| Hook 事件系统 | ✅ |
| 多 Agent 协调 | ✅ |
| 弯引号保留 | ✅ |
| CYBER_RISK_INSTRUCTION | ✅ |
| KAIROS / PROACTIVE 模式 | ✅ |
| Swarm / Teammate | ✅ |

---

## 🎯 可进一步改进的方向

虽然核心功能完备，但以下是一些**细节优化**方向：

### 1. Ant (内部版) 特有功能外部化

泄露版有一些 Ant 内部专用功能，可以考虑外部化：

```typescript
// 1. Token Budget 控制
if (feature('TOKEN_BUDGET')) {
  // "When the user specifies a token target (e.g., "+500k")..."
}

// 2. 数值长度锚点 (减少输出 token)
"Length limits: keep text between tool calls to ≤25 words."
```

### 2. 验证 Agent 协议增强

当前 OpenClaw 有 `verificationAgent`，但可以增强协议：

```
Non-trivial implementation =:
- 3+ file edits
- backend/API changes  
- infrastructure changes

验证流程:
1. Spawn verificationAgent with subagent_type="verification"
2. Pass original request + all files changed + approach + plan
3. On FAIL: fix, resume verifier, repeat until PASS
4. On PASS: spot-check 2-3 commands from report
```

### 3. 2阶段分类器优化

泄露版有 fast→thinking 两阶段分类器：
```typescript
stage?: 'fast' | 'thinking'
stage1Usage?: ClassifierUsage  // fast 阶段
stage2Usage?: ClassifierUsage // thinking 阶段
```
OpenClaw 的 yoloClassifier 可以检查是否需要类似的分级优化。

### 4. 自主模式行为规范

泄露版对 KAIROS/PROACTIVE 模式有更具体的行为规范：

```typescript
// Tick 处理
if (tick === 'first') {
  // 首次 tick: 简单问候，等待方向
} else if (nothing_useful) {
  MUST call SleepTool  // 不能只发"等待中"
}

// Terminal focus 响应
unfocused: 自主行动，只在不可逆时暂停
focused: 协作模式，暴露选择
```

### 5. 输出效率规范

泄露版有详细的用户面向文本规范：

```
用户面向文本 vs 代码/工具输出：
- 用户面向: 流畅散文，避免符号
- 代码: 保持原样
- 表格: 仅用于简短可枚举事实

倒金字塔结构 (inverted pyramid)
先行动，后解释
```

### 6. 错误处理优化

泄露版有详细的错误处理模式：

```typescript
// 报告要faithful
if (tests.fail) → 必须说 "tests failed"
Never claim "all tests pass" when output shows failures

// 解释决策
"我不确定X和Y哪个更好，选了Y因为Z"
```

---

## 🔧 具体实现建议

### 建议 1: 增强 FileEditTool 的智能处理

```typescript
// 在 FileEditTool 中添加
const IMPROVED_QUOTE_HANDLING = {
  // 检测弯引号使用趋势
  detectQuoteStyle: (fileContent: string) => 'curly' | 'straight',
  
  // 智能替换 (不改变原有风格)
  smartReplace: (oldStr, newStr, fileContent) => newStr,
  
  // 检测编码
  detectEncoding: (content: string) => 'utf8' | 'latin1' | ...
}
```

### 建议 2: 添加安全增强

```typescript
// 1. 命令复杂度分析
const COMMAND_COMPLEXITY = {
  SIMPLE: 0-2 tokens,
  MEDIUM: 3-5 tokens with pipes/redirs,
  COMPLEX: 6+ tokens or multiple operators
}

// 2. 敏感操作二次确认
if (operation === 'rm -rf' || operation.includes('git push --force')) {
  requireExplicitConfirmation()
}

// 3. 路径遍历智能检测
containsPathTraversal(cmd) → {
  // 0./1./2./  等多种编码
  // Unicode 规范化
  // 大小写混淆
}
```

### 建议 3: 上下文管理优化

```typescript
// 1. 动态 budget
const CONTEXT_BUDGET = {
  CRITICAL: 5000,  // 必须保留
  IMPORTANT: 20000, // 尽量保留
  NORMAL: 50000,   // 标准压缩点
  LARGE: 100000    // 大项目上限
}

// 2. 智能摘要策略
smartSummary(messages) → {
  // 保留决策点
  // 压缩重复操作
  // 保留关键错误/修复
}
```

### 建议 4: Hook 增强

```typescript
// 添加更多 Hook 点
const HOOK_POINTS = {
  PreToolUse: true,
  PostToolUse: true,
  PreCompact: true,       // 新增
  PostCompact: true,      // 新增
  OnTokenBudget: true,    // 新增
  OnError: true,           // 新增
  OnIdle: true,            // 新增
}

// Hook 优先级
hook.priority = 'high' | 'medium' | 'low'
```

---

## 📋 实施优先级

| 优先级 | 改进项 | 工作量 | 影响 |
|--------|--------|--------|------|
| P1 | 增强验证 Agent 协议 | 小 | 高 |
| P1 | 2阶段分类器检查 | 中 | 中 |
| P2 | 自主模式行为规范 | 小 | 中 |
| P2 | 输出效率指南 | 小 | 中 |
| P3 | 智能引号处理增强 | 小 | 低 |
| P3 | 安全复杂度分析 | 中 | 中 |

---

## 📝 总结

1. **OpenClaw 已经很完善** - 与泄露 Claude Code 几乎同水平
2. **不需要大改** - 核心架构已经非常好
3. **细节优化** - 可以在现有框架内优化细节
4. **最佳路径** - 关注 Ant 内部版功能的外部化

---

*创建时间: 2026-04-02*
*来源: 对比分析 claude-code-haha vs claude-code-pener*
