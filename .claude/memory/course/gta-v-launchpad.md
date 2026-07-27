---
name: gta-v-launchpad
description: /Users/marosdeeuma/GTA-V เป็น launchpad Wave-0 (repo แยก) ที่รอพี่ยิง prompt.md เอง — สถานะ, กฎ, กับดัก port (อ่านเมื่อจะกลับไปทำ GTA-V หรืออ้างเป็นตัวอย่างในคอร์ส)
metadata:
  type: project
  status: active
  scope: course
  updated: 2026-07-27
---

`/Users/marosdeeuma/GTA-V` (repo แยกจาก Easy-of-Duty) เป็น worked example ของคอร์ส: **launchpad ไม่ใช่เกม**
สถานะ Wave 0 ณ 2026-07-27 — contract, harness, deterministic kernel และ subsystem stub 15 ตัว gate เขียวหมด commit `e3a0185`

**ทำไมหยุดที่นี่:** พี่จะ paste `prompt.md` แล้วยิง fleet เองเมื่อพี่เลือก — ดู [[working-agreements]]

**ถ้าจะกลับไปทำต่อ:**
- `npm run gate` ต้องเขียว **ก่อน** ทำอะไรทั้งสิ้น นั่นคือ premise ของการออกแบบทั้งหมด — ห้ามเริ่ม `/loop` บน gate แดง
- ทำตาม wave plan ใน `prompt.md`: W1 parallel ×5 → W2 parallel ×4 → **W3 sequential (driving feel)** → W4 parallel ×2 → **W5 sequential (police)**
  cluster ที่ coupled กัน 4 ก้อนใน `ARCHITECTURE.md` **ห้าม fan out**
- **ยังไม่มี git remote** ยังไม่ได้ push อะไรเลย — ถามพี่ก่อนสร้าง
- `shots/base` ถูก gitignore โดยเจตนา — pixel gate เทียบได้เฉพาะเครื่องเดียวกัน เป็น local reference ที่บันทึกด้วย `npm run gate -- --rebaseline`
- dev server อยู่ **port 5273** ไม่ใช่ 5173 เพราะมี server ของโปรเจคข้างๆ ถูกวัดแทนแบบเงียบๆ ตอน dev
  ทุก tool ยัง assert `window.__PROJECT__ === 'district'` ด้วย

รายละเอียดการออกแบบและเหตุผลอยู่ใน `ARCHITECTURE.md` + `README.md` ของ repo นั้น — อ่านจากที่นั่น อย่า re-derive

Related: [[course-overview]], [[working-agreements]]
