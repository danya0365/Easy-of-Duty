---
paths:
  - "src/**"
  - "tools/**"
  - "index.html"
  - "vite.config.js"
---

# Definition of Done — Easy-of-Duty

> **กฎข้อเดียวที่สำคัญสุด:** ห้ามบอกพี่ว่างาน "เสร็จ" จนกว่าจะผ่าน checklist นี้ครบ —
> ไม่ว่าจะ session ไหน, AI ตัวไหน, มี persona Vega หรือไม่
> โปรเจคนี้ **ไม่มี** lint / typecheck / unit test — gate จริงคือ **build + capture + pixel diff**
> ถ้าไปเจอ template ที่พูดถึง `npm test`/`npm run lint` แปลว่ามันไม่ใช่ของโปรเจคนี้

## ✅ Checklist ก่อนปิดงาน

### 1. Build + capture ผ่าน — **บังคับทุกงานที่แตะ `src/`, `tools/`, `index.html`, `vite.config.js`**

```bash
npm run build              # ต้องผ่าน
node tools/capture.mjs     # ต้องได้เฟรมออกมาจริง
```

### 2. Pixel gate — **บังคับทุกงานที่แตะ visual หรือ perf**

ยกจาก `tools/workflows/perf.js` (`GATE`) ตรงๆ เพราะเป็นข้อความที่ทำให้งาน perf ของ repo นี้ converge:

> **An optimization that is 20% faster and changes one pixel is a FAILED optimization and must be reverted.**
> It must report **"identical: true". Not "close". Not "withinEpsilon". IDENTICAL.**

```bash
OW_NO_HMR=1 node tools/baseline.mjs --out=/tmp/before --port=<PORT>
# ...แก้โค้ด...
OW_NO_HMR=1 node tools/baseline.mjs --out=/tmp/after  --port=<PORT>
node tools/imagediff.mjs --a=/tmp/before --b=/tmp/after
```

- ต้องใช้ `tools/baseline.mjs` — มัน isolate แต่ละ shot ใน page ของตัวเอง ซึ่งเป็นเหตุผลเดียวที่มันเทียบแบบ bit-reproducible ได้
  **ห้ามใช้ `tools/shotset.mjs` แทน** (แชร์ page เดียวทุก shot → ภาพ drift)
- ตกกate แล้วมี **สองทางเลือกเท่านั้น**: (1) หาสาเหตุที่ pixel เปลี่ยนแล้วกำจัด แล้ว verify ใหม่ (2) revert แล้วรายงานว่า not-viable พร้อมเหตุผล
  **ห้ามอธิบาย diff ว่า "แทบไม่เห็น / imperceptible" เพื่อให้ผ่าน**
- pixel gate เป็นเรื่อง **เครื่องเดียวกันเท่านั้น** — baseline ข้ามเครื่อง/ข้าม GPU เทียบกันไม่ได้

### 3. งาน perf ต้องมีตัวเลข — **บังคับเมื่ออ้างว่าเร็วขึ้น**

```bash
node tools/profile.mjs --port=<PORT> --dpr=2 --frames=900
```

รายงาน **p50/p95/p99 ก่อน–หลัง อย่างน้อย 3 รอบต่อฝั่ง** + program count ถ้าเป็นเรื่อง hitch
"รู้สึกว่าลื่นขึ้น" ไม่นับ · ตัวเลขรอบเดียวก็ไม่นับ

### 4. ห้ามเคลมโดยไม่มี output จริง

**paste output ของคำสั่งที่รันจริง** ทุกครั้งที่บอกว่าผ่าน · ไม่ได้รัน → พูดตรงๆ ว่าไม่ได้รันและบอกคำสั่งให้พี่รัน
ถ้าผลวัดขัดกับ brief ที่ได้รับ → **แย้งด้วยตัวเลข** (ผลที่ดีที่สุดของ repo ต้นทางมาจาก agent ที่แย้ง brief ตัวเอง)

### 5. รันหลาย agent พร้อมกัน = แจก port คนละตัว

`vite.config.js` ตั้ง `strictPort: true` บน `127.0.0.1:5173` → agent ที่รันพร้อมกันต้องใช้ `--port` คนละตัว
(convention ของ repo: `5300 + n`) ไม่แจก port = วัดเซิร์ฟเวอร์ของคนอื่นโดยไม่รู้ตัว

### 6. Commit สะอาด

- conventional message (`feat:`/`fix:`/`perf:`/`docs:`…) · subject ไทยได้ · body ≤100 char/บรรทัด
- ปิดท้าย `Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>`
- ไม่มี secret หลุด · ไม่ commit `shots/` (780 MB, gitignore ไว้แล้ว)
- **commit ตรง `main` ได้ แต่เมื่อพี่สั่งเท่านั้น** (กฎเหล็กใน AGENTS.md)

### 7. รายงานตรง (ห้าม overclaim)

บอกชัด: ผ่านอะไร / ข้ามอะไร / เหลืออะไร · "เสร็จและพิสูจน์แล้ว" = ผ่านข้อ 1–3 ที่เกี่ยวข้องจริงเท่านั้น

## ข้อยกเว้น

งานที่แตะแค่ **`docs/`, `.claude/`, `README.md`, `ARCHITECTURE.md`, `prompt.md`** (เอกสาร/คอร์ส/toolkit)
→ ข้อ 1–3 ไม่บังคับ แต่ข้อ 4, 6, 7 ยังบังคับ

## สรุปสั้น (จำ 1 บรรทัด)

> **build + capture ผ่าน → แตะ visual/perf ต้องได้ `identical: true` + ตัวเลข p50/p95/p99 → paste output จริง → commit สะอาด (เมื่อสั่ง) → รายงานตรง**

มาตรฐานโค้ดเต็ม: [code-standards.md](code-standards.md) · สัญญาระดับ subsystem: [ARCHITECTURE.md](../../ARCHITECTURE.md)
