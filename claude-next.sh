#!/bin/bash

# Claude Next Account - Switch to next account

BACKUP_DIR="$HOME/.claude-accounts"
CLAUDE_CONFIG="$HOME/.claude.json"
STATE_FILE="$BACKUP_DIR/.current_index"

# Get accounts list
accounts=($(ls "$BACKUP_DIR"/*.json 2>/dev/null | xargs -n1 basename 2>/dev/null | sed 's/.json//'))
total=${#accounts[@]}

[ $total -eq 0 ] && { echo "[ERROR] No accounts found"; exit 1; }

# Read current index
index=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
next=$(( (index + 1) % total ))

# Switch account
account="${accounts[$next]}"
"$(dirname "$0")/claude-switch.sh" "$account"

# Save index
echo $next > "$STATE_FILE"
echo "Position: ($((next+1))/$total)"
