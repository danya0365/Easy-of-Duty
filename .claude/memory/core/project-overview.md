---
name: project-overview
description: Easy-of-Duty คืออะไร — fork ของ claude-of-duty ที่ใช้เป็นสื่อสอน harness-driven prompting, stack, harness command, roadmap (อ่านตอนเริ่ม session หรือทบทวนภาพรวม)
metadata:
  type: convention
  status: active
  scope: global
  updated: 2026-07-27
---

# Easy-of-Duty — ภาพรวม

## โปรเจคนี้คืออะไร

**fork ของ `mshumer/claude-of-duty`** — FPS บน browser (Three.js r180 + WebGL2) ~70,000 บรรทัด 176 ไฟล์
11 subsystem ที่ agent fleet สร้างขึ้นจาก prompt **11 บรรทัด** (`prompt.md`)

คุณสมบัติที่นิยามโปรเจค: **ไม่มี art asset เลย** — texture, mesh, animation, เสียง generate จากโค้ดตอน load ทั้งหมด
ไม่มีไฟล์ภาพ/โมเดล/เสียง/HDRI · runtime dep มี `three` ตัวเดียว · รันได้ offline

repo นี้เล่นสองบทบาทพร้อมกัน:

1. **ตัวอย่างอ้างอิง** ของวิธี orchestrate agent fleet ด้วย harness
2. **spine ของคอร์ส** ที่พี่กำลังทำ — `docs/one-prompt-playbook.md` (ไทย 13 บท, 811 บรรทัด) คือ commit เดียวที่พี่เพิ่มเข้ามาเอง
   → รายละเอียดคอร์สอยู่ที่ [[course-overview]]

**default ของงานที่นี่จึงเป็น "เขียนเอกสาร/บทเรียน" ไม่ใช่ "แก้เกม"** — จะแตะ `src/` ต้องมีเหตุผลที่บอกพี่ได้

## 3 เสาที่ทำให้ prompt สั้นๆ ทำงานได้ (แกนของทั้งคอร์ส)

1. **Coordination contract** — `ARCHITECTURE.md` เป็นสัญญาเดียวที่ agent ทุกตัวต้องอ่านก่อนเขียนโค้ด
   (ownership 1 dir/1 subsystem · ห้าม import ข้ามบ้าน · event vocabulary + surface types เป็น closed set)
2. **Measurement harness** — `tools/` แปลงคำว่า "สวย/ลื่น" ให้เป็นตัวเลขที่ตรวจได้ (pixel diff, p50/p95/p99, HDR probe)
   ทำให้ agent ตัดสินงานตัวเองได้แทนที่จะเดา
3. **Determinism** — `ctx.rng` + fixed step 120 Hz + `ctx.time` ทำให้เฟรมเดิม reproduce แบบ **bit-identical**
   ไม่มีข้อนี้ pixel gate ใช้ไม่ได้ และทั้งระบบพัง

บทเรียนที่ upstream บันทึกใน `README.md`: **sequential single-owner pass ชนะ parallel fan-out บนงานที่ coupled กัน**
(+1.00 คะแนน · defect 66 → 26 เทียบกับ +0.46 และ defect 60 → 47 → 66 จาก 3 รอบ × 6 agent ขนาน)
คะแนนสุดท้ายของเกม **5.05/10** และแพ้ CoD จริงในทุก blind A/B — ตัวเลขนี้ต้องคงอยู่ในคอร์ส เพราะเป็นจุดที่ทำให้คอร์สน่าเชื่อ

## Stack

Plain JS ESM · three r180 · Vite 7 · npm · **ไม่มี** TypeScript / eslint / prettier / test framework / CI
กฎการเขียนโค้ด: `.claude/rules/code-standards.md` · เกณฑ์ปิดงาน: `.claude/rules/definition-of-done.md` · สัญญา: `ARCHITECTURE.md`

## Harness command (gate จริงของโปรเจค)

| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `npm run build` | gate ขั้นต่ำ ต้องผ่านทุกครั้ง |
| `node tools/capture.mjs` | ถ่ายเฟรมเดียว (`npm run shot`) |
| `OW_NO_HMR=1 node tools/baseline.mjs --out=DIR --port=N` | capture ที่ reproduce ได้ — input ของ pixel gate |
| `node tools/imagediff.mjs --a=DIR --b=DIR` | ต้องได้ `identical: true` |
| `node tools/profile.mjs --port=N --dpr=2 --frames=900` | p50/p95/p99 + hitch attribution จาก program count |
| `node tools/playtest.mjs` · `node tools/probe.mjs` | smoke test เดิน/ยิง · วัด scene radiance เป็น stop |
| `tools/workflows/perf.js` | workflow orchestration จริง (Determinism → Verify → Optimize → Measure) — ตัวอย่างชั้นดีสำหรับสอน |

`shots/` ถูก gitignore (780 MB) regenerate ด้วย `tools/baseline.mjs` · pixel gate เทียบได้เฉพาะเครื่องเดียวกัน

## Roadmap (ปรับกับพี่)

1. ✅ playbook ไทย 13 บท + เผยแพร่เป็น Artifact (ดู [[claude-of-duty-sources]])
2. LAB 1 (SVG icon set) รันจริงให้จบ เพื่อได้ **ตัวเลขต้นทุนจริง** แทนค่าประมาณในบทที่ 09
3. slide deck สำหรับสอนสด
4. `starter-kit` — `ARCHITECTURE.md` เปล่า + โครง `tools/` ให้นักเรียน clone
5. worked example `GTA-V/` (repo แยก) — ดู [[gta-v-launchpad]]

Related: [[course-overview]], [[user-marosdee]], [[working-agreements]], [[conventions]]
