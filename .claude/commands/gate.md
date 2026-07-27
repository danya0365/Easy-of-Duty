---
description: รัน gate ของโปรเจค (build → capture → pixel diff ถ้าแตะ visual) แล้วรายงานพร้อม output จริง
argument-hint: "[visual | perf | quick]  (ว่างไว้ = เลือกให้ตามไฟล์ที่แก้)"
---

รัน gate ของ Easy-of-Duty ตาม `.claude/rules/definition-of-done.md` โหมด: **$ARGUMENTS**

1. ดู `git status --short` + `git diff --stat` ก่อน เพื่อรู้ว่าแตะอะไรไป
   - แตะแค่ `docs/`, `.claude/`, `*.md` → บอกพี่ว่าไม่ต้องรัน gate แล้วจบ
   - แตะ `src/`, `tools/`, `index.html`, `vite.config.js` → ไปข้อ 2
2. **quick gate (บังคับทุกครั้ง)**
   ```bash
   npm run build
   node tools/capture.mjs
   ```
3. **ถ้าแตะ visual/perf (หรือพี่สั่ง `visual`)** — pixel gate:
   ```bash
   git stash                                     # เอา baseline ของ "ก่อนแก้"
   OW_NO_HMR=1 node tools/baseline.mjs --out=/tmp/gate-before --port=5301
   git stash pop
   OW_NO_HMR=1 node tools/baseline.mjs --out=/tmp/gate-after  --port=5301
   node tools/imagediff.mjs --a=/tmp/gate-before --b=/tmp/gate-after
   ```
   - ต้องได้ **`identical: true`** เท่านั้น — "close"/"withinEpsilon" ไม่ผ่าน
   - ⚠️ ถาม/เตือนพี่ก่อน `git stash` ทุกครั้ง ถ้ามีงานค้างที่ยัง stash ไม่ได้ ให้ข้ามข้อนี้แล้วบอกพี่ว่าข้ามเพราะอะไร
   - ห้ามใช้ `tools/shotset.mjs` แทน `baseline.mjs` (ภาพ drift)
4. **ถ้าเป็นงาน perf (หรือพี่สั่ง `perf`)**
   ```bash
   node tools/profile.mjs --port=5301 --dpr=2 --frames=900
   ```
   รัน **อย่างน้อย 3 รอบต่อฝั่ง** แล้วรายงาน p50/p95/p99 ก่อน–หลัง
5. **รายงาน**: paste output จริงของทุกคำสั่งที่รัน · บอกชัดว่าอะไรผ่าน/ไม่ผ่าน/ข้าม
   - ตกกate → เสนอสองทางเท่านั้น: หาสาเหตุที่ pixel เปลี่ยนแล้วแก้ หรือ revert แล้วรายงานว่า not-viable
   - **ห้ามสรุปว่าผ่านโดยไม่มี output** และห้ามอธิบาย diff ว่า "แทบมองไม่เห็น"
6. ยังไม่ commit — รอพี่สั่ง
