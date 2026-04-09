#!/bin/bash
# 毛选skill每小时迭代任务
# 每次迭代：扩充语录、优化SKILL.md、提升毛主席形象塑造

cd /home/kali/.openclaw/workspace/Chairman-Mao-wisdom-skill

# 记录本次迭代开始
echo "[$(date)] 毛选skill迭代开始" >> /home/kali/.openclaw/workspace/Chairman-Mao-wisdom-skill/iteration.log

# 检查是否有变更
if git diff --quiet; then
    echo "[$(date)] 无变更，跳过" >> /home/kali/.openclaw/workspace/Chairman-Mao-wisdom-skill/iteration.log
    exit 0
fi

# 提交并推送
git add -A
git commit -m "迭代更新 [$(date '+%Y-%m-%d %H:%M')]

- 持续完善毛主席智慧宝库
- 扩充经典语录和思想内容"
git push origin main

echo "[$(date)] 迭代完成并推送" >> /home/kali/.openclaw/workspace/Chairman-Mao-wisdom-skill/iteration.log
