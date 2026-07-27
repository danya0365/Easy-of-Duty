---
name: working-agreements
description: ข้อตกลงการทำงานที่พี่สั่งไว้ — สร้าง launchpad แล้วหยุด อย่ายิง agent fleet เอง, แจ้งต้นทุนก่อนใช้เงิน, พิสูจน์ gate ก่อนส่งมอบ (อ่านก่อนเริ่มงานที่จะกิน token เยอะ หรือก่อนตั้ง /loop)
metadata:
  type: feedback
  status: active
  scope: global
  updated: 2026-07-27
---

เวลาพี่ขอให้สร้างโปรเจค "แบบ Claude-of-Duty" ให้สร้าง **launchpad** — contract, harness,
deterministic kernel, stub — แล้ว **verify ว่า gate เขียว แล้วหยุด**
**อย่า spawn agent fleet และอย่าเริ่ม `/loop` เอง** ถ้าพี่ไม่สั่งชัดๆ

**Why:** ถามพี่ตรงๆ แล้ว (2026-07-27, โปรเจค GTA-V) พี่เลือก "สร้าง launchpad อย่างเดียว" ไม่ใช่ "สร้างแล้วยิง prompt ให้เลย"
เหตุผลสองข้อ: fleet run หนึ่งครั้งเป็นเงินหลายร้อยดอลลาร์ และพี่กำลังเรียนเทคนิคนี้อยู่ — การกดปุ่มคือส่วนที่พี่ต้องการทำเอง

**How to apply:**
- ส่งมอบ scaffolding + `prompt.md` ที่พร้อม paste แล้วบอกตรงๆ ว่ารันแล้วจะกินเท่าไร
- **พิสูจน์ gate ก่อน** และแปะ output จริง — launchpad ที่ไม่เคยรัน gate คือสิ่งเดียวที่ทำให้เงินก้อนถัดไปไม่ converge
- แจ้งต้นทุนก่อนลงมือกับอะไรที่กิน budget ใหญ่ ไม่ใช่แจ้งทีหลัง

**เรื่อง git:** สำหรับ **fork ของพี่เอง** พี่สั่ง `commit + push` และโอเคกับการเข้า `main` ตรง
(Easy-of-Duty, 2026-07-27) — ยังคง "ห้าม commit เองถ้าไม่ได้สั่ง" ไว้ แต่ไม่ต้องยืนกรานเรื่อง branch + PR
สำหรับงานเอกสารบน personal fork

Related: [[user-marosdee]], [[gta-v-launchpad]], [[course-overview]]
