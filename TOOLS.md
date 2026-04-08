# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## MiniMax / 抖音

```markdown
#### 视频发布偏好
- 旁白必须用中文 TTS（speech-2.8-hd），不要英文
- 视频主题风格：电影质感、高饱和色调（炫技类）、冲击力强

#### API Key
- MiniMax CN: sk-cp-LYTvK2pbGQWpOheDDkI3nH9-GrC0XdAADVpPMSvRhmnyzAm3v4eaNzQnCK97WnwWtvYh_4ZmYYlxL6i2Lkht6UtMJCpbMsrKOZ7ODuRG_A9YVe9Uqf6L0M0
- 视频模型：Hailuo-2.3 / Hailuo-2.3-Fast（Fast版仅支持I2V不支持T2V）
```

## GitHub

```markdown
#### 网络

- 宿主机 IP: 192.168.57.20
- OpenClaw 容器 IP: 192.168.57.2
- 网段: 192.168.57.0/24 (pener5577)
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
权限: repo, delete_repo, workflow（当前使用）

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（旧token，可能已失效）
```


