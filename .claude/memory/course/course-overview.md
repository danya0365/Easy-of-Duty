---
name: course-overview
description: คอร์สสอน harness-driven prompting ที่สร้างจากวิธีของ claude-of-duty — มีอะไรแล้ว, จะทำอะไรต่อ, framing ที่ต้องรักษา (อ่านก่อนทำงานเกี่ยวกับคอร์ส/บทเรียน/สไลด์)
metadata:
  type: project
  status: active
  scope: course
  updated: 2026-07-27
---

งานที่กำลังทำ (เริ่ม 2026-07-27): คอร์สที่สอน **วิธีการ** เบื้องหลัง `mshumer/claude-of-duty` —
ว่า prompt สั้นๆ ทำงานได้เพราะมันกำหนด **reward function** และงานจริงคือ 3 เสาที่ agent สร้างก่อน
(coordination contract, measurement harness, determinism)

**Why:** พี่ fork โปรเจคมา พบว่ามันเล่นได้จริง และอยากสอน *เทคนิค* ไม่ใช่ตัวเกม

**How to apply:** กระดูกสันหลังของคอร์สคือ `docs/one-prompt-playbook.md` (13 บท, ภาษาไทย)
เวอร์ชันเว็บที่แชร์ได้เผยแพร่เป็น Artifact แล้ว (URL ใน [[claude-of-duty-sources]])
`GTA-V/` เป็น worked example ที่นักเรียนต่อยอด — ดู [[gta-v-launchpad]]

## ขั้นถัดไป (คุยแล้วแต่ยังไม่เริ่ม)

- รัน **LAB 1 (SVG icon set)** ให้จบ เพื่อได้ **ตัวเลขต้นทุนจริง** แทนค่าประมาณในบทที่ 09
- slide deck สำหรับสอนสด
- **starter-kit** — `ARCHITECTURE.md` เปล่า + โครง `tools/` ให้นักเรียน clone

## Framing ที่ต้องรักษา (สำคัญที่สุดของคอร์สนี้)

ขายว่า **"AI ที่รู้ว่างานตัวเองยังไม่ดีพอ"** — **ห้าม** ขายว่า *"prompt เดียวสร้างเกม AAA"*
โปรเจคอ้างอิงได้ **5.05/10** และ critic ทุกคนเลือก Call of Duty ตัวจริงในการเทียบแบบ blind A/B
พี่เห็นด้วยว่า framing ที่ซื่อตรงสอนได้ดีกว่าและน่าเชื่อกว่า และ playbook เขียนแบบนั้นทั้งเล่ม — **รักษาไว้**

Related: [[user-marosdee]], [[claude-of-duty-sources]], [[project-overview]]
