# SETUP — ตั้งค่าเครื่องใหม่ (AI agent / Claude Code)

โปรเจคนี้เก็บ config ของผู้ช่วย AI (**Vega**) ไว้ใน git ทั้งหมด (ดู [ADR-0001](.claude/memory/decisions/0001-agent-toolkit.md))
เมื่อ `git clone` เครื่องใหม่ ทำตามนี้:

## 1. กด accept workspace-trust (บังคับ)

เปิดโปรเจคใน Claude Code แล้ว **กด accept workspace-trust 1 ครั้ง** —
ค่า `autoMemoryDirectory` และ hooks (`rules-check.sh`, `commit-reminder.sh`) ถึงจะทำงาน

## 2. ตรวจ path ของ memory

`.claude/settings.json` → `autoMemoryDirectory` ชี้ `/Users/marosdeeuma/Easy-of-Duty/.claude/memory`
ถ้าพี่ clone ไปไว้ที่อื่น/เปลี่ยนชื่อโฟลเดอร์ → แก้ค่านี้ให้ตรง (จุดเดียว)

## 3. ติดตั้ง dependency ของโปรเจค

```bash
npm install     # three + vite + playwright + pngjs
npm run build   # gate ขั้นต่ำ ต้องผ่าน
```

⚠️ **ไม่มี prettier/eslint/test framework โดยเจตนา** — ห้ามติดตั้ง (ดู [ADR-0002](.claude/memory/decisions/0002-project-gates.md))
hook `rules-check.sh` ใช้แค่ `grep` ไม่ต้องลงอะไรเพิ่ม

## 4. (ถ้าจะใช้) MCP — GitHub server

1. `cp .mcp.json.example .mcp.json` (`.mcp.json` ถูก gitignore)
2. สร้าง GitHub personal access token แล้วใส่ใน `.claude/settings.local.json`:
   ```json
   { "env": { "GITHUB_TOKEN": "ghp_xxx" } }
   ```
3. รีสตาร์ท session

## 5. Model / auth

โปรเจคนี้ใช้ auth/model ปกติของ Claude Code
ถ้าอยากตั้งค่า env เฉพาะเครื่อง → สร้าง `.claude/settings.local.json` (gitignore) เอง

---

## ไฟล์ที่ gitignore (สร้างใหม่ต่อเครื่อง)

- `.claude/settings.local.json` — env/ค่าเฉพาะเครื่อง (เช่น GITHUB_TOKEN)
- `.mcp.json` — config MCP จริง (คัดจาก `.mcp.json.example`)
- `CLAUDE.local.md` — note ส่วนตัวต่อเครื่อง (ถ้ามี)
