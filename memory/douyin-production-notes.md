# 抖音自动发布 — 生产规范

## 画面比例（必须严格遵守）

**⚠️ 绝对禁止拉伸或变形图片！**

目标分辨率：1080×1920（9:16竖屏）

**正确方法：**
1. 先确认图片原生尺寸（image-01生成的是720×1280，即9:16）
2. 将图片缩放至宽度=1080，高度等比缩放（=1920）
3. 如果缩放后高度<1920，在上下加黑边（pad）补满
4. 如果缩放后高度>1920，裁剪上下多余部分（crop）再 pad

**推荐 ffmpeg 命令（单图测试）：**
```bash
# 方法A：高度优先（高度撑满1920，宽度等比缩放，多出来的左右黑边pad）
vf "scale=1080:1920:force_original_aspect_ratio=increase,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:color=black"

# 方法B：宽度优先（宽度=1080，高度等比，超出部分crop居中裁剪）
vf "scale=1080:-1,crop=1080:1920:(iw-1080)/2:0"

# 方法C：智能自适应（检查图片比例，选择pad或crop）
# 先scale到至少1080x1920，再crop/pad到精确尺寸
vf "scale=min(1080\,iw*1920/ih):min(1920\,ih*1080/iw),crop=1080:1920:(iw-1080)/2:(ih-1920)/2"
```

**幻灯片合成命令（40张图，每张1.2秒，共48秒）：**
```bash
# 最可靠方式：先生成单图处理脚本，再合并
ffmpeg -y \
  -framerate 1/1.2 \
  -i city_frame_%02d.jpg \
  -vf "scale=min(1080\,iw*1920/ih):min(1920\,ih*1080/iw),crop=1080:1920:(iw-1080)/2:(ih-1920)/2,fps=30" \
  -c:v libx264 \
  -preset fast \
  -crf 18 \
  -pix_fmt yuv420p \
  slideshow_raw.mp4
```

**调试方法：**
```bash
# 先检查单张图片的原始尺寸
ffprobe -v quiet -print_format json -show_streams city_frame_01.jpg

# 如果图片本身就是 9:16 (例如 720x1280)，可以直接缩放：
# scale=1080:1920（不加任何参数，因为比例完全一致）
```

**最安全做法（如果图片确实是9:16原生）：**
```bash
# 直接按比例放大到1080宽度，高度自动算出1920（正好9:16）
ffmpeg -y \
  -framerate 1/1.2 \
  -i city_frame_%02d.jpg \
  -vf "scale=1080:1920:flags=lanczos,fps=30" \
  -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p \
  slideshow.mp4
```

## 语速控制（必须）

**目标：** 旁白时长精确匹配视频时长（48秒 ± 1秒）

**方法：**
1. 写完旁白文字后，计算字数
2. 中文正常语速：约 3-3.5 字/秒
3. 目标字数：48秒 × 3.5 = 168字（最多170字）
4. **直接用 TTS `--speed` 参数生成慢速语音**，不要用 ffmpeg atempo 事后减速！
5. 宁可短一点不要硬撑，留1-2秒呼吸空间

**TTS 慢速生成（直接指定速度，不要 ffmpeg 减速）：**
```bash
# 用 generate_voice.sh 的 --speed 参数直接生成慢速语音
# speed=0.85 表示 0.85 倍速（比正常慢）
bash scripts/tts/generate_voice.sh tts "旁白文字..." \
  -v female-shaonv \
  --speed 0.85 \
  -o minimax-output/narration.mp3
```

**不要再用 ffmpeg atempo 减速！**
```bash
# 错误 ❌ - 事后减速会导致音质损失
ffmpeg -y -i input.mp3 -filter:a "atempo=0.85" output_slow.mp3

# 正确 ✅ - 直接让 TTS 生成慢速
bash scripts/tts/generate_voice.sh tts "文字" --speed 0.85 -o output.mp3
```

## 字幕制作（必须）

**SRT格式生成 → ffmpeg Burn-in**

### 步骤1：生成SRT文件
每个字幕片段格式：
```
1
00:00:01,200 --> 00:00:03,500
城市睡着了。
```

### 步骤2：用ffmpeg烧录字幕
```bash
ffmpeg -y -i video_with_audio.mp4 -vf "subtitles=subtitle.srt:force_style='FontSize=28,PrimaryColour=&H00FFFFFF&,Alignment=2,MarginV=200'" -c:a copy video_with_subtitle.mp4
```

**字体样式规范：**
- 中文字体：使用系统自带中文字体
  - Linux: `/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc` 或 `NotoSansCJK-Regular.ttc`
  - 查找字体: `fc-list :lang=zh | head -5`
- 字号：1080p视频建议28-32pt
- 颜色：白色 (&H00FFFFFF&)
- 位置：底部居中，MarginV=200
- 对齐：Alignment=2（底部居中）

**如果字幕文件含中文路径问题：**
```bash
# 先把字幕转为ass格式
ffmpeg -y -i subtitle.srt subtitle.ass
# 然后烧录
ffmpeg -y -i video.mp4 -vf "ass=subtitle.ass" -c:a copy output.mp4
```

## 完整工作流（图片模式）

1. 选主题，写旁白（控制字数 ≤ 170字）
2. 生成40张9:16图片（确认是 9:16 比例）
3. **ffmpeg 合成幻灯片（48秒，每张1.2秒）**
   - 用 `scale=1080:1920:flags=lanczos` 直接按比例放大（不加 pad/crop）
   - 不允许任何拉伸、变形
4. TTS生成旁白，**用 `--speed 0.85` 直接生成慢速语音**，不要用 ffmpeg atempo 减速
5. 生成BGM
6. 混音（旁白60% + BGM 22%）
7. **生成SRT字幕文件，与旁白逐句对应时间轴**
8. **ffmpeg烧录字幕到视频**
9. sau上传

## 常见问题

- 字幕字体乱码 → 使用 `fc-list :lang=zh` 查找中文字体路径，或转ass格式
- 字幕遮挡画面 → 加大MarginV值（200以上）
- 语速太快/太慢 → 用 TTS `--speed` 参数调节（如 0.85），不要用 ffmpeg atempo
- API rate limit → 每批8张图，间隔5秒
- **图片变形** → 绝对不能用 `scale=1080:1920` 而不加 `flags=lanczos`，且必须用 `force_original_aspect_ratio`
