---
name: adr-0001-agent-toolkit
description: ADR-0001 — ชุดเครื่องมือ AI agent (Claude) ของโปรเจคประกอบด้วยอะไรบ้าง และทำไม commit เข้า repo (อ่านเมื่อสงสัยโครง .claude/ หรือจะเพิ่ม/แก้ toolkit)
metadata:
  type: decision
  status: active
  scope: global
  updated: 2026-07-27
---

# ADR-0001 — AI Agent Toolkit

## บริบท
โปรเจคนี้ตั้งค่า Claude Code ให้ทำงานเป็นผู้ช่วยประจำ (persona **Vega**) โดย scaffold มาจาก
template `agent-toolkit-template` (skill `scaffold-agent`) ต้องการให้ config/persona/memory
**พกข้ามเครื่องได้ผ่าน git**

## การตัดสินใจ
เก็บทุกอย่างไว้ใน `.claude/` + `AGENTS.md`/`CLAUDE.md` แล้ว **commit เข้า repo** (ยกเว้นไฟล์ลับต่อเครื่อง) —
setup เครื่องใหม่ดู `SETUP.md`

องค์ประกอบ:
- **Persona** — `AGENTS.md` (root) นิยามตัวตน Vega + project guide + กฎเหล็ก · `CLAUDE.md` = `@AGENTS.md` (shim)
- **Permissions allowlist** — `.claude/settings.json` pre-approve `npm run *`, `node tools/*`, git ที่อ่าน/commit
- **Hooks** — `.claude/hooks/rules-check.sh` (PostToolUse → เตือนเมื่อชนกฎ ARCHITECTURE.md), `commit-reminder.sh` (Stop → เตือนไฟล์ค้าง) ⚠️ ต้องกด workspace-trust
- **Slash commands** — `.claude/commands/`: `/gate` `/new-lesson` `/new-adr` `/memory-status` `/archive-memory`
- **Scoped rules** — `.claude/rules/` (โหลดตาม path): `code-standards.md`, `definition-of-done.md` — **ปรับให้ตรง stack นี้แล้ว** ดู [[adr-0002-project-gates]]
- **Portable memory** — `.claude/memory/` (index lean + recall on-demand + `_archive/` library) ตั้งผ่าน `autoMemoryDirectory` ใน settings.json · กติกาใน [[memory-guide]]
- **MCP** — `.mcp.json.example` (template GitHub MCP; ยังไม่ activate) · เปิดเมื่อมี token ตาม `SETUP.md`

## เหตุผล
- **พกพา** — `git clone` เครื่องใหม่แล้วทำงานต่อได้ทันที (persona + memory + config ตามมาด้วย)
- **context ไม่บวม** — memory โหลดแค่ `MEMORY.md` แล้ว recall on-demand
- **วินัยงานสม่ำเสมอ** — DoD + code-standards บังคับผ่าน rules ทุก session

## ผลที่ตามมา / ข้อควรระวัง
- ⚠️ `autoMemoryDirectory` เป็น path absolute — ถ้าย้าย/เปลี่ยนชื่อโปรเจค ต้องแก้ค่านี้จุดเดียวใน `.claude/settings.json`
- ⚠️ ต้องกด **accept workspace-trust 1 ครั้ง** ต่อเครื่อง `autoMemoryDirectory` + hooks ถึงมีผล
- ไฟล์ลับต่อเครื่อง (`settings.local.json`, `.mcp.json`, `CLAUDE.local.md`) **gitignore** — สร้างใหม่ต่อเครื่อง
