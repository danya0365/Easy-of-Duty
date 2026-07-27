---
name: conventions
description: มาตรฐานโค้ด/naming/git ของ Easy-of-Duty แบบย่อ (อ่านก่อนเขียนโค้ดใหม่ หรือเมื่อสงสัยว่าควรวางไฟล์/ตั้งชื่อยังไง) — ชี้ไป ARCHITECTURE.md + code-standards rule
metadata:
  type: convention
  status: active
  scope: global
  updated: 2026-07-27
---

# Coding Conventions (ย่อ)

> **สัญญาตัวจริงคือ [`ARCHITECTURE.md`](../../../ARCHITECTURE.md)** — อ่านก่อนเขียนโค้ดใน `src/` ทุกครั้ง
> มาตรฐานฉบับใช้งาน (โหลดอัตโนมัติตอนแตะโค้ด) อยู่ที่ [`.claude/rules/code-standards.md`](../../rules/code-standards.md)
> + [`definition-of-done.md`](../../rules/definition-of-done.md) · ไฟล์นี้แค่สรุปหัวข้อ

## 6 ข้อที่พลาดบ่อยสุด

1. **1 subsystem = 1 directory** — ห้ามแก้ของบ้านอื่น · `src/core/`, `src/main.js`, `src/dev/`, `tools/`, `vite.config.js` เป็นของ lead
2. **ห้าม import ข้าม subsystem** — ใช้ `ctx.get('<id>')` ตอน runtime (import ได้แค่ `../core/*` กับ `three`)
3. **ห้าม `Math.random()` / `performance.now()` ขับ logic** — ใช้ `ctx.rng`, `ctx.time` (determinism = หัวใจของ pixel gate)
4. **ห้าม allocate ต่อ frame** · `dispose()` ต้องคืนทุกอย่างที่สร้าง · เคารพ budget ใน `config.q`
5. **ห้ามเพิ่ม npm dep** (รวม prettier/eslint/test framework) — ต้องมี ADR ก่อน
6. **event + surface type เป็น closed set** — เพิ่มใหม่ต้องเพิ่มแถวใน `ARCHITECTURE.md` ใน commit เดียวกัน

## Naming & โครงสร้าง

- import แบบ relative ESM **ใส่ `.js` ทุกครั้ง** ไม่มี alias · `.js` = browser, `.mjs` = Node tool
- ทุก subsystem มี `index.js` export คลาสของตัวเอง · เสริมได้ด้วย `preview.html`/`preview.js` (bench แยก), `probe.mjs`/`selftest.js`, `shoot.mjs`
- ชื่อไฟล์ kebab-case ตัวเล็ก · คลาส PascalCase · `static id` เป็นชื่อ subsystem ตัวเล็ก

## Git

- commit **เมื่อพี่สั่งเท่านั้น** (กฎเหล็ก AGENTS.md)
- fork ส่วนตัว → **commit ตรง `main` ได้** ไม่ต้องแตก feature branch
- message: conventional (`feat:`/`fix:`/`perf:`/`docs:`/`refactor:`/`chore:`) เนื้อความไทยได้
- footer: `Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>`

## คอมเมนต์

บันทึก **หลักฐานและตัวเลขที่วัดได้** ไม่ใช่ข้อสรุป — "draw call 1,240 → 380, p95 18.4 → 11.2 ms" ดีกว่า "optimized"

Related: [[project-overview]], [[working-agreements]]
