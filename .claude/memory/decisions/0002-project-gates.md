---
name: adr-0002-project-gates
description: ADR-0002 — ทำไม rules ของโปรเจคนี้ไม่ใช้ lint/typecheck/test แบบ template แต่ใช้ build + capture + pixel diff และทำไมเปลี่ยน hook auto-format เป็น rules-check (อ่านเมื่อสงสัยว่าทำไม gate ที่นี่ไม่เหมือนโปรเจคอื่น)
metadata:
  type: decision
  status: active
  scope: global
  updated: 2026-07-27
---

# ADR-0002 — gate ของ Easy-of-Duty คือ build + capture + pixel diff

## บริบท

`scaffold-agent` template ตั้งอยู่บนสมมติฐาน stack แบบ TypeScript + eslint/prettier + test framework
(`code-standards.md` พูดถึง `Result<T>` และ hexagonal boundary · `definition-of-done.md` สั่งให้ `lint + typecheck + test` เขียว)

โปรเจคนี้ไม่มีอย่างนั้นเลย: plain JavaScript ESM, dep เดียวคือ `three`, ไม่มี TypeScript, ไม่มี eslint/prettier,
ไม่มี test framework, ไม่มี CI · `package.json` มีแค่ `dev`, `build`, `preview`, `shot`
สิ่งที่ทำหน้าที่ gate จริงคือ harness ใน `tools/` — Playwright + pngjs ที่ถ่ายเฟรมแล้วเทียบ pixel

ถ้าคง template ไว้ตามเดิม กฎจะสั่งให้รัน `npm test` ที่ไม่มีอยู่ → agent จะเดา, ข้าม, หรือ (แย่สุด) เคลมว่าผ่าน

## การตัดสินใจ

1. **เขียน `code-standards.md` ใหม่** ให้ชี้ว่า `ARCHITECTURE.md` เป็นสัญญา authoritative แล้วสรุปกฎเหล็กที่มีจริง
   (directory ownership · ห้าม import ข้าม subsystem · ห้ามเพิ่ม dep · ห้าม `Math.random()`/`performance.now()` ·
   ห้าม allocate ต่อ frame · `dispose()` · `config.q` budget · light-count เป็น shader permutation key · `owNoShadow`)
2. **เขียน `definition-of-done.md` ใหม่** ให้ gate = `npm run build` + `node tools/capture.mjs` และงาน visual/perf
   ต้องได้ `identical: true` จาก `tools/baseline.mjs` + `tools/imagediff.mjs` โดยยกข้อความ `GATE` จาก
   `tools/workflows/perf.js` มาตรงๆ · งาน perf ต้องมี p50/p95/p99 อย่างน้อย 3 รอบต่อฝั่ง
3. **แทน hook `format.sh` (prettier) ด้วย `rules-check.sh`** — เตือนเมื่อไฟล์ที่เพิ่งแก้มี `Math.random()`,
   `performance.now()` หรือ import ข้าม subsystem · warn-only ไม่ block
4. **ตัดกฎ feature-branch** — fork ส่วนตัว commit ตรง `main` ได้เมื่อพี่สั่ง (กฎ "ห้าม commit เอง" ยังอยู่)
5. **domain = คอร์ส** → `/new-topic` กลายเป็น `/new-lesson` + โฟลเดอร์ `.claude/memory/course/` และเพิ่ม `/gate`

## เหตุผล

- **กฎต้องชี้ไปที่คำสั่งที่มีอยู่จริง** ไม่งั้นมันกลายเป็นเสียงรบกวนที่สอน agent ให้เคลมลอยๆ
- **prettier จะทำลายคุณค่าของ fork** — reformat โค้ด upstream 176 ไฟล์แล้ว diff กับ `mshumer/claude-of-duty` จะอ่านไม่ได้
  ซึ่ง diff นั้นคือสิ่งที่คอร์สใช้สอน · การไม่มี formatter จึงเป็นการตัดสินใจ ไม่ใช่ความบกพร่อง
- pixel gate ให้ผลตรวจที่ **แข็งกว่า unit test** สำหรับงานประเภทนี้ (เปลี่ยนไป 1 pixel ก็จับได้) ตราบใดที่ determinism ยังอยู่

## ผลที่ตามมา / ข้อควรระวัง

- ไม่มี lint/typecheck → พลาดพวก typo ที่ static type จะจับได้ ต้องพึ่ง `npm run build` + capture + สายตา
- pixel gate เทียบได้ **เครื่องเดียวกันเท่านั้น** (GPU/driver ต่างกัน = ภาพต่างกัน) baseline จึงไม่ commit เข้า repo
- `vite.config.js` ตั้ง `strictPort: true` → รัน agent/harness พร้อมกันต้องแจก `--port` คนละตัว (convention: `5300 + n`)
- ถ้าวันหนึ่งจะเพิ่ม prettier/eslint/vitest จริง ต้องเขียน ADR ใหม่ที่ supersede ข้อ 3 ของ ADR นี้ พร้อมยอมรับ diff ที่จะเกิด

Related: [[adr-0001-agent-toolkit]], [[conventions]], [[project-overview]]
