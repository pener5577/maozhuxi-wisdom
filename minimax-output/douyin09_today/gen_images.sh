#!/bin/bash
export MINIMAX_API_HOST="https://api.minimaxi.com"
export MINIMAX_API_KEY="sk-cp-LYTvK2pbGQWpOheDDkI3nH9-GrC0XdAADVpPMSvRhmnyzAm3v4eaNzQnCK97WnwWtvYh_4ZmYYlxL6i2Lkht6UtMJCpbMsrKOZ7ODuRG_A9YVe9Uqf6L0M0"
SCRIPT="/root/.openclaw/skills/minimax-multimodal-toolkit/scripts/image/generate_image.sh"
OUT="/root/.openclaw/workspace/minimax-output/douyin09_today"

# Batch 1: 身勤 (Physical diligence)
bash "$SCRIPT" --prompt "A lone figure walking on a long winding mountain road at dawn, misty atmosphere, cinematic lighting, warm golden sunrise breaking through clouds, shoes worn from the journey, determined stride, photorealistic, low saturation tones, Chinese landscape style" --aspect-ratio 9:16 -o "$OUT/img_001.jpg"
bash "$SCRIPT" --prompt "A person building a stone wall with bare hands in a quiet countryside, sweat on brow, sunset backlighting, dust particles in the air, rugged determination, documentary photography style, muted earthy tones" --aspect-ratio 9:16 -o "$OUT/img_002.jpg"

# Batch 2: 眼勤 (Visual diligence)
bash "$SCRIPT" --prompt "Close-up of eyes carefully observing a calligraphy brush stroke, a master calligrapher's hand in frame, afternoon light through rice paper screen, contemplative atmosphere, shallow depth of field, warm ink tones" --aspect-ratio 9:16 -o "$OUT/img_003.jpg"
bash "$SCRIPT" --prompt "A person sitting alone in a traditional library, afternoon sunlight streaming through lattice windows, dust motes floating in light beams, rows of ancient books, serene and contemplative mood, cinematic composition" --aspect-ratio 9:16 -o "$OUT/img_004.jpg"

# Batch 3: 手勤 (Hand diligence)
bash "$SCRIPT" --prompt "Hands gently picking up fallen autumn leaves from a stone garden path, soft morning light, raked gravel patterns visible, zen garden atmosphere, meditative quality, close-up perspective, warm earth tones" --aspect-ratio 9:16 -o "$OUT/img_005.jpg"
bash "$SCRIPT" --prompt "A worn notebook on a wooden desk, pen resting across the open page, notes and ideas written carefully, warm desk lamp glow, late night study atmosphere, intimate and quiet mood" --aspect-ratio 9:16 -o "$OUT/img_006.jpg"

# Batch 4: 口勤 (Verbal diligence)
bash "$SCRIPT" --prompt "Two people in a traditional tea house having a warm conversation, steam rising from teacups, soft winter light through paper windows, respectful listening postures, friendship and humility depicted, cinematic emotional tone" --aspect-ratio 9:16 -o "$OUT/img_007.jpg"
bash "$SCRIPT" --prompt "A mentor and student sitting by a tranquil pond, autumn maple leaves falling, the mentor gesturing thoughtfully while the student listens attentively, Chinese scholar garden setting, warm golden light" --aspect-ratio 9:16 -o "$OUT/img_008.jpg"

# Batch 5: 心勤 (Heart diligence)
bash "$SCRIPT" --prompt "A single candle burning in a dark room, its warm glow illuminating an open book, the flame representing sincerity and dedication, quiet midnight atmosphere, poetic and contemplative mood, soft warm light" --aspect-ratio 9:16 -o "$OUT/img_009.jpg"
bash "$SCRIPT" --prompt "A person standing on a hilltop at sunrise with arms slightly raised, vast landscape stretching below, golden morning mist, moment of epiphany, spiritual and inspiring atmosphere, cinematic wide shot" --aspect-ratio 9:16 -o "$OUT/img_010.jpg"

# Batch 6: 勤奋五重境界 - 综合
bash "$SCRIPT" --prompt "Five stone steps ascending a mountain path, each step illuminated by different quality of light representing the five types of diligence, morning mist, Chinese ink painting aesthetic merged with photorealism" --aspect-ratio 9:16 -o "$OUT/img_011.jpg"
bash "$SCRIPT" --prompt "A traditional Chinese scholar's desk at dawn, withered brush, scattered manuscripts, a small potted pine tree, the desk lamp casting long shadows, scene of dedicated work, low warm light" --aspect-ratio 9:16 -o "$OUT/img_012.jpg"

# Batch 7: 身勤 - journey
bash "$SCRIPT" --prompt "Long exposure photograph of a hiking trail at twilight, a single headlamp glowing in the distance, winding mountain path, stars beginning to appear, sense of solitary determination, cinematic atmosphere" --aspect-ratio 9:16 -o "$OUT/img_013.jpg"
bash "$SCRIPT" --prompt "A farmer's weathered hands holding rich soil, dawn light illuminating the earth, seeds scattered across the palm, symbolic of fruitful labor, close-up documentary style, warm earth tones" --aspect-ratio 9:16 -o "$OUT/img_014.jpg"

# Batch 8: 眼勤 - observation
bash "$SCRIPT" --prompt "An elderly craftsman using a magnifying glass to examine fine wood grain, hands steady and experienced, workshop filled with natural northern light, focus and precision, shallow depth of field" --aspect-ratio 9:16 -o "$OUT/img_015.jpg"
bash "$SCRIPT" --prompt "A person gazing out of a rain-streaked window at a blurred city at night, reflections in glass, contemplative mood, urban solitude, cinematic bokeh lights in background, cool blue tones" --aspect-ratio 9:16 -o "$OUT/img_016.jpg"

# Batch 9: 手勤 - small habits
bash "$SCRIPT" --prompt "A neat desk surface with organized sticky notes, a pen, a small succulent plant, morning sunlight from window, every small object in its proper place, minimal and focused workspace aesthetic" --aspect-ratio 9:16 -o "$OUT/img_017.jpg"
bash "$SCRIPT" --prompt "Hands tying a knot on a worn leather journal, the journal filled with handwritten entries, warm afternoon light on the cover, ritual of recording thoughts, intimate close-up perspective" --aspect-ratio 9:16 -o "$OUT/img_018.jpg"

# Batch 10: 口勤 - humility
bash "$SCRIPT" --prompt "A young person bowing respectfully to an elderly master in a traditional courtyard, cherry blossom petals falling, atmosphere of mutual respect and learning, soft spring light, emotional and dignified composition" --aspect-ratio 9:16 -o "$OUT/img_019.jpg"
bash "$SCRIPT" --prompt "Group discussion around a circular table in a modern library, diverse people sharing ideas respectfully, warm pendant lighting above, collaborative learning atmosphere, humanistic documentary style" --aspect-ratio 9:16 -o "$OUT/img_020.jpg"

# Batch 11: 心勤 - dedication
bash "$SCRIPT" --prompt "A person meditating in a mountain monastery at sunrise, clouds floating below, bell with golden light rim, spiritual devotion, zen Buddhist atmosphere, ethereal and peaceful, wide cinematic framing" --aspect-ratio 9:16 -o "$OUT/img_021.jpg"
bash "$SCRIPT" --prompt "Close-up of an open ancient book with beautiful calligraphy, fingers gently turning the page, dramatic side lighting casting shadows across the text, reverence for knowledge, warm golden tones" --aspect-ratio 9:16 -o "$OUT/img_022.jpg"

# Batch 12: 勤奋主题
bash "$SCRIPT" --prompt "A worn but sturdy wooden boat oar resting against a misty riverbank at dawn, representing persistent effort through rough waters, soft grey-blue morning tones, poetic and symbolic composition" --aspect-ratio 9:16 -o "$OUT/img_023.jpg"
bash "$SCRIPT" --prompt "A calligraphy scroll unfurling in slow motion in a sunlit traditional hall, the characters 勤奋 rendered in powerful xingshū style, warm afternoon light illuminating the ink, elegant atmosphere" --aspect-ratio 9:16 -o "$OUT/img_024.jpg"

# Batch 13: 身勤 - action
bash "$SCRIPT" --prompt "A marathon runner at the precise moment of crossing the finish line alone, empty racetrack, triumphant pose, dramatic sky, exhaustion and accomplishment in the expression, cinematic sports photography" --aspect-ratio 9:16 -o "$OUT/img_025.jpg"
bash "$SCRIPT" --prompt "Time-lapse style photograph of a bamboo grove, each stalk at different growth stages, morning dew, representing steady daily progress, serene and metaphorical, lush green tones" --aspect-ratio 9:16 -o "$OUT/img_026.jpg"

# Batch 14: 眼勤 - insight
bash "$SCRIPT" --prompt "A detective's eye viewed through a magnifying glass revealing hidden details in an old photograph, mystery and discovery, dramatic chiaroscuro lighting, cinematic noir atmosphere" --aspect-ratio 9:16 -o "$OUT/img_027.jpg"
bash "$SCRIPT" --prompt "A child staring intently at a butterfly landing on their finger, pure wonder and focus in the expression, soft garden bokeh background, golden hour warmth, innocent observation" --aspect-ratio 9:16 -o "$OUT/img_028.jpg"

# Batch 15: 手勤 - consistency
bash "$SCRIPT" --prompt "Stack of worn practice calligraphy sheets covering a desk, each showing gradual improvement in brush strokes, late afternoon studio light, the daily discipline of mastery visible in the accumulated papers" --aspect-ratio 9:16 -o "$OUT/img_029.jpg"
bash "$SCRIPT" --prompt "A well-worn leather toolbox on a workbench, each tool marked by years of use, afternoon light creating dramatic shadows across the well-organized workspace, honoring craftsmanship" --aspect-ratio 9:16 -o "$OUT/img_030.jpg"

# Batch 16: 口勤 - encouragement
bash "$SCRIPT" --prompt "A teacher writing an encouraging note on a student's homework, red pen in hand, warm desk lamp glow, the gesture of guidance, intimate educational moment, documentary warmth" --aspect-ratio 9:16 -o "$OUT/img_031.jpg"
bash "$SCRIPT" --prompt "Group of diverse people clapping genuinely for someone giving a speech, warm atmosphere of genuine appreciation, soft focus background, human connection and support, emotional documentary style" --aspect-ratio 9:16 -o "$OUT/img_032.jpg"

# Batch 17: 心勤 - sincerity
bash "$SCRIPT" --prompt "A paper lantern floating in a night sky among stars, its warm glow representing sincere heart, long exposure photograph, magical realism aesthetic, dreamy and aspirational atmosphere" --aspect-ratio 9:16 -o "$OUT/img_033.jpg"
bash "$SCRIPT" --prompt "A person lighting incense in a mountain temple, smoke curling upward toward ancient stone carvings, spiritual devotion, early morning light, profound tranquility, cinematic composition" --aspect-ratio 9:16 -o "$OUT/img_034.jpg"

# Batch 18: 综合意境
bash "$SCRIPT" --prompt "A split image: left side shows a chaotic messy desk, right side shows a perfectly organized one, transition through the middle, symbolic of discipline and diligent habits, clean editorial style" --aspect-ratio 9:16 -o "$OUT/img_035.jpg"
bash "$SCRIPT" --prompt "A vast library with a single reader at a distant desk, warm lamplight creating a pool of light in the darkness, the figure small against towering bookshelves, knowledge as a lighthouse" --aspect-ratio 9:16 -o "$OUT/img_036.jpg"

# Batch 19: 勤奋-路虽远
bash "$SCRIPT" --prompt "A tiny figure climbing an enormous spiral staircase that reaches into the clouds, perspective distortion making the stairs monumental, surreal metaphorical image of the long journey of diligence" --aspect-ratio 9:16 -o "$OUT/img_037.jpg"
bash "$SCRIPT" --prompt "The same mountain path photographed in four seasons: spring blossoms, summer green, autumn leaves, winter snow, showing the consistent walker returning through all conditions, triptych composition" --aspect-ratio 9:16 -o "$OUT/img_038.jpg"

# Batch 20: 眼勤 - 看人
bash "$SCRIPT" --prompt "Two hands shaking in a business setting, but the camera focuses on the eyes of both people meeting for the first time, reading character through careful observation, dramatic close-up" --aspect-ratio 9:16 -o "$OUT/img_039.jpg"
bash "$SCRIPT" --prompt "An artist studying their own reflection in a mirror while painting, double exposure effect blending self-portrait and painting, introspection and self-awareness, moody studio lighting" --aspect-ratio 9:16 -o "$OUT/img_040.jpg"

# Batch 21: 手勤 - 随手
bash "$SCRIPT" --prompt "Hands sweeping fallen leaves from a stone path in a zen garden, the meditative quality of small consistent actions, early morning mist, the beauty of humble daily rituals, peaceful atmosphere" --aspect-ratio 9:16 -o "$OUT/img_041.jpg"
bash "$SCRIPT" --prompt "A small water droplet falling into a still pond creating perfect ripples, macro photography, representing how small diligent actions create lasting impact, meditative quality" --aspect-ratio 9:16 -o "$OUT/img_042.jpg"

# Batch 22: 口勤 - 谦虚
bash "$SCRIPT" --prompt "A proud-looking young person listening with genuine surprise to an elderly person's story, the expression shift from skepticism to genuine respect, warm human connection, cinematic street photography" --aspect-ratio 9:16 -o "$OUT/img_043.jpg"
bash "$SCRIPT" --prompt "A microphone on a podium with a small sign saying '倾听' (listen), empty conference hall, spotlight creating atmosphere of the importance of listening, minimalist composition" --aspect-ratio 9:16 -o "$OUT/img_044.jpg"

# Batch 23: 心勤 - 精诚
bash "$SCRIPT" --prompt "Water eroding through stone over centuries, the drop finally breaking through creating a small hole, representing how sincere persistent effort conquers even the hardest obstacles, macro nature photography" --aspect-ratio 9:16 -o "$OUT/img_045.jpg"
bash "$SCRIPT" --prompt "A heart made of origami paper floating in a sunbeam, the delicate art of patience and heartfelt dedication, white background with soft light, minimalist and symbolic composition" --aspect-ratio 9:16 -o "$OUT/img_046.jpg"

# Batch 24: 万勤才皆顺
bash "$SCRIPT" --prompt "Five rivers converging into one powerful waterfall at sunset, each tributary representing one type of diligence, the unified flow representing successful outcomes, majestic nature photography" --aspect-ratio 9:16 -o "$OUT/img_047.jpg"
bash "$SCRIPT" --prompt "A compass on a wooden navigation table, the needle pointing steadily north, representing finding the right direction through diligent practice, warm nautical atmosphere, golden afternoon light" --aspect-ratio 9:16 -o "$OUT/img_048.jpg"

# Batch 25: 愿你找到方向
bash "$SCRIPT" --prompt "A lighthouse at the edge of a cliff in a storm, its beam cutting through rain and darkness, guiding ships to safety, representing finding direction through diligent effort, dramatic cinematic photography" --aspect-ratio 9:16 -o "$OUT/img_049.jpg"
bash "$SCRIPT" --prompt "The final scene: a person standing at a mountain summit watching the sunrise, arms relaxed at sides, the long journey completed, golden light washing over the vast landscape below, sense of peace and arrival, cinematic wide shot" --aspect-ratio 9:16 -o "$OUT/img_050.jpg"

echo "All 50 images generated!"
