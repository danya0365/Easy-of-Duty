#!/usr/bin/env bash
# PostToolUse hook — เตือนเมื่อไฟล์ที่เพิ่ง Edit/Write ชนกฎเหล็กใน ARCHITECTURE.md
#
# ทำไมไม่ใช่ auto-format (prettier แบบ template เดิม): repo นี้ไม่มี prettier/eslint
# และ format โค้ด upstream 176 ไฟล์จะสร้าง diff ขยะเทียบ mshumer/claude-of-duty
# กฎที่มีจริงในโปรเจคนี้ตรวจด้วย grep ได้ตรงกว่า — warn-only ไม่เคย block
set -uo pipefail

input="$(cat)"

file="$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
[ -z "$file" ] && file="$(printf '%s' "$input" | sed -n 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
[ -z "$file" ] && exit 0
[ -f "$file" ] || exit 0

# ตรวจเฉพาะโค้ดเกม/harness
case "$file" in
  *.js|*.mjs) ;;
  *) exit 0 ;;
esac
case "$file" in
  */src/*|src/*|*/tools/*|tools/*) ;;
  *) exit 0 ;;
esac

warn() { printf '⚠️  %s\n' "$1" >&2; }
hits=0

if grep -q 'Math\.random(' "$file"; then
  warn "$file: มี Math.random() — determinism แตก ใช้ ctx.rng / ctx.rng.fork() (src/core/rng.js)"
  hits=1
fi

if grep -q 'performance\.now(' "$file"; then
  warn "$file: มี performance.now() — ถ้าใช้ขับ gameplay/visual ให้ใช้ ctx.time (elapsed/dt/alpha); ใช้วัด perf/compile time เท่านั้นถึงจะโอเค"
  hits=1
fi

# import ข้าม subsystem — อนุญาตแค่ ../core/ (config, rng, input)
cross="$(grep -oE "from '\.\./[a-z]+/" "$file" | grep -v "from '\.\./core/" | sort -u | tr '\n' ' ')"
if [ -n "$cross" ]; then
  warn "$file: import ข้าม subsystem ($cross) — ARCHITECTURE.md ห้าม ใช้ ctx.get('<id>') ตอน runtime แทน"
  hits=1
fi

if [ "$hits" = 1 ]; then
  warn "อ่าน ARCHITECTURE.md + .claude/rules/code-standards.md ก่อนแก้ต่อ"
fi

exit 0
