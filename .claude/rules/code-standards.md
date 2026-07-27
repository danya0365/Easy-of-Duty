---
paths:
  - "src/**"
  - "tools/**"
  - "index.html"
  - "vite.config.js"
---

# Code Standards — Easy-of-Duty

> **[ARCHITECTURE.md](../../ARCHITECTURE.md) เป็นสัญญาที่ authoritative — อ่านก่อนเขียนโค้ดใน `src/` ทุกครั้ง**
> ไฟล์นี้ไม่ได้แทน ARCHITECTURE.md แต่สรุปกฎที่ "มีฟัน" + จุดที่พลาดแล้วเจ็บ
> 🚦 เกณฑ์ "เสร็จ" อยู่ที่ [definition-of-done.md](definition-of-done.md)

## Stack ที่มีอยู่จริง (อย่าสมมติเกินนี้)

Plain **JavaScript ES modules** (`"type": "module"`) · **three r180** เป็น runtime dep ตัวเดียว ·
**Vite 7** · **npm** · **ไม่มี** TypeScript · **ไม่มี** eslint/prettier · **ไม่มี** test framework
Verification ใช้ harness ใน `tools/` (Playwright + pngjs) ไม่ใช่ unit test

- import แบบ **relative ESM ใส่ `.js` ท้ายทุกครั้ง** — ไม่มี path alias / tsconfig paths
- `.js` = โมดูลที่รันบน browser · `.mjs` = tool ที่รันบน Node
- **ห้ามติดตั้ง npm dependency ใหม่** (รวม dev dep เช่น prettier/eslint/vitest) — ถ้าจะเอาต้องเขียน ADR ให้พี่เคาะ เพราะทั้ง repo ตั้งอยู่บนกฎ "ไม่มี asset ไม่มี dep รันได้ offline"
- ห้าม fetch CDN / โหลด image/HDRI/model/audio จากภายนอก — ทุกอย่าง generate จากโค้ดตอน load

## Ownership — ห้ามแก้ข้ามบ้าน

1 subsystem = 1 directory ใน `src/` (11 ตัว: render, materials, sky, world, physics, player, weapons, fx, ai, ui, audio)

- **แก้เฉพาะ directory ที่เป็นเจ้าของงานนั้น** ห้ามไปแก้ของ subsystem อื่นเพื่อให้ของตัวเองผ่าน
- **ของ lead — ห้ามแก้เองถ้าพี่ไม่สั่ง:** `src/core/`, `src/main.js`, `src/dev/`, `tools/`, `vite.config.js`, `index.html`
- **ห้าม `import` โมดูลของ subsystem อื่น** — คุยกันตอน runtime ผ่าน `ctx.get('fx')` / `ctx.peek(id)` เท่านั้น
  (`src/main.js` เป็นที่เดียวที่ wire ทุกอย่างเข้าหากัน · subsystem import ได้แค่ `../core/*` กับ `three`)
- interface ของ subsystem: `static id` · `static deps` · `init(ctx)` · `fixedUpdate(h, ctx)` · `update(dt, ctx)` · `lateUpdate(dt, ctx)` · `resize(w, h, ctx)` · `dispose()` — ดู `src/core/registry.js`

## Determinism — พังอันนี้แล้ว pixel gate ใช้ไม่ได้เลย

- **ห้าม `Math.random()`** ใน gameplay/visual → `ctx.rng` หรือ `ctx.rng.fork()` (`src/core/rng.js`)
- **ห้าม `performance.now()` / `new Date()` ขับ logic** → ใช้ `ctx.time` (`elapsed`, `raw`, `dt`, `fixed`, `alpha`, `scale`, `frame`)
  ใช้ `alpha` interpolate ระหว่าง fixed step · `performance.now()` ใช้ได้เฉพาะตอนวัด perf/compile time
- physics fixed step **120 Hz** (`PHYSICS_HZ`, `MAX_SUBSTEPS = 8`) — logic ที่ต้อง reproduce ให้อยู่ใน `fixedUpdate`
- prewarm (`src/core/prewarm.js`): `prewarmMaterials(ctx)` ต้อง compile material ทั้งหมด **โดยไม่** spawn gameplay object, ไม่วาดเฟรมเกม, ไม่แตะ clock/RNG และต้องมี render target bound อยู่ (`outputColorSpace`/`toneMapping` เป็น cache key ที่อ่านจาก target)

## Performance — ละเมิดแล้ว frame ตกทันที

- **ห้าม allocate ต่อ frame** — `new THREE.Vector3()` ใน `update()`/`fixedUpdate()` คือ bug · preallocate ใน `init()` แล้ว reuse
- **`dispose()` ต้องคืนทุกอย่างที่สร้าง** — geometry, material, texture, render target
- **เคารพ budget ใน `src/core/config.js`** — `config.q` (low/medium/high/ultra) คุม `renderScale, shadowMapSize, cascades, taa, gtao, ssr, volumetrics, motionBlur, particleBudget, decalBudget` · **ห้ามเกิน** และห้าม hardcode ค่าที่ควรอ่านจาก `config.q`
- หน่วย: **เมตร / วินาที / กิโลกรัม**

## กับดัก 2 อย่างที่ต้องจำ (บันทึกไว้ใน ARCHITECTURE.md)

1. **จำนวน point-light ที่ visible = shader permutation key** — ไฟข้ามขอบ cull radius ทำให้ material ที่รับแสงทั้งหมด recompile (+33–36 program, hitch 640–900 ms)
   → ไล่ `intensity` ลง 0 **อย่าใช้ `visible = false`** หรือคง ballast light ไว้ (`_stabiliseLightCount` ใน `src/world`)
2. **`owNoShadow` เป็นสวิตช์ shadow-caster ตัวเดียวที่มีผล** — cascade ใช้ `scene.overrideMaterial` และ **ไม่เคยอ่าน** `mesh.castShadow` · ข้าม prepass ด้วย `mesh.userData.owNoPrepass`

## Vocabulary ที่เป็น closed set

- **event bus** (`ctx.events`): `weapon:fire`, `bullet:impact`, `damage:dealt`, `actor:death`, `player:footstep`, `player:state`, `explosion`, `resize`, … ตามตารางใน ARCHITECTURE.md
  → **ต้องเพิ่ม event ใหม่? เพิ่มแถวใน ARCHITECTURE.md ใน commit เดียวกัน** ห้ามยิง event ที่ไม่มีในตาราง
- **surface types 12 ตัว**: `concrete metal wood dirt sand glass water foliage fabric flesh rubber plaster` — ห้ามคิดเพิ่มเอง (physics/fx/audio อ่านชุดเดียวกัน)

## สไตล์โค้ด/คอมเมนต์

- **คอมเมนต์บันทึกหลักฐานและตัวเลขที่วัดได้ ไม่ใช่ข้อสรุป** — "draw call 1,240 → 380, p95 18.4 → 11.2 ms" ดีกว่า "optimized for performance" (สไตล์เดิมของ repo · playbook §08.3)
- เขียนให้เหมือนไฟล์รอบข้าง — repo นี้เขียนโดย agent fleet ที่ยึด ARCHITECTURE.md เป็นสัญญา ความสม่ำเสมอสำคัญกว่ารสนิยมส่วนตัว
- **ห้ามแก้โค้ด upstream โดยไม่มีเหตุ** — fork นี้มีค่าเพราะ diff กับ `mshumer/claude-of-duty` ยังอ่านรู้เรื่อง งานคอร์สให้เพิ่มใน `docs/` แทนการไปแก้ `src/`
- **ห้าม format ทั้งไฟล์/ทั้งโปรเจค** (prettier ฯลฯ) — จะกลบ diff จริงจนรีวิวไม่ได้

## Git

- ห้าม commit/push เอง ถ้าพี่ไม่สั่ง (กฎเหล็กใน `AGENTS.md`)
- **fork ส่วนตัว → commit ตรง `main` ได้เมื่อพี่สั่ง** ไม่ต้องแตก feature branch (แตกได้ถ้างานยาว แต่ไม่บังคับ)
- commit message: conventional (`feat:`/`fix:`/`docs:`/`perf:`/`refactor:`/`chore:`) เนื้อความไทยได้

## เมื่อออกกฎใหม่

กฎใหม่ที่ตกลงกันแล้ว → เขียนลงไฟล์นี้ (หรือ ARCHITECTURE.md ถ้าเป็นสัญญาระดับ subsystem) + สรุปใน [conventions.md](../memory/core/conventions.md)
การตัดสินใจใหญ่ → ADR ผ่าน `/new-adr` · **กฎที่ไม่ได้เขียนลงไฟล์ = ไม่มีอยู่**
