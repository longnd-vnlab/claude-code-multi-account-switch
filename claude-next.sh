#!/bin/bash

# Claude Next Account - Chuyển sang account tiếp theo

BACKUP_DIR="$HOME/.claude-accounts"
CLAUDE_CONFIG="$HOME/.claude.json"
STATE_FILE="$BACKUP_DIR/.current_index"

# Lấy danh sách accounts
accounts=($(ls "$BACKUP_DIR"/*.json 2>/dev/null | xargs -n1 basename 2>/dev/null | sed 's/.json//'))
total=${#accounts[@]}

[ $total -eq 0 ] && { echo "❌ No accounts found"; exit 1; }

# Đọc index hiện tại
index=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
next=$(( (index + 1) % total ))

# Chuyển account
account="${accounts[$next]}"
"$(dirname "$0")/claude-switch.sh" "$account"

# Lưu index
echo $next > "$STATE_FILE"
echo "📍 ($((next+1))/$total)"
