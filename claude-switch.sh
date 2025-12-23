#!/bin/bash

# Claude Code Multi-Account Switcher

CLAUDE_DIR="$HOME/.claude"
CLAUDE_CONFIG="$HOME/.claude.json"
BACKUP_DIR="$HOME/.claude-accounts"

mkdir -p "$BACKUP_DIR"

switch_account() {
    local account="$1"
    
    # Auto-save current account
    if [ -f "$CLAUDE_CONFIG" ]; then
        for f in "$BACKUP_DIR"/*.json; do
            [ -f "$f" ] || continue
            name=$(basename "$f" .json)
            if cmp -s "$CLAUDE_CONFIG" "$f" 2>/dev/null; then
                cp "$CLAUDE_CONFIG" "$f"
                [ -d "$CLAUDE_DIR" ] && { rm -rf "$BACKUP_DIR/$name-dir"; cp -r "$CLAUDE_DIR" "$BACKUP_DIR/$name-dir"; }
                break
            fi
        done
    fi
    
    # Switch
    if [ -f "$BACKUP_DIR/$account.json" ]; then
        cp "$BACKUP_DIR/$account.json" "$CLAUDE_CONFIG"
        [ -d "$BACKUP_DIR/$account-dir" ] && { rm -rf "$CLAUDE_DIR"; cp -r "$BACKUP_DIR/$account-dir" "$CLAUDE_DIR"; }
        echo "[OK] Switched to $account"
    else
        echo "[ERROR] Account '$account' not found. Save it first with: $0 save $account"
    fi
}

case "$1" in
    save)
        [ -z "$2" ] && { echo "Usage: $0 save <account_name>"; exit 1; }
        cp "$CLAUDE_CONFIG" "$BACKUP_DIR/$2.json"
        [ -d "$CLAUDE_DIR" ] && { rm -rf "$BACKUP_DIR/$2-dir"; cp -r "$CLAUDE_DIR" "$BACKUP_DIR/$2-dir"; }
        echo "[OK] Saved as $2"
        ;;
    list)
        echo "Accounts:"
        for f in "$BACKUP_DIR"/*.json; do [ -f "$f" ] && echo "  - $(basename "$f" .json)"; done
        ;;
    status)
        for f in "$BACKUP_DIR"/*.json; do
            [ -f "$f" ] && cmp -s "$CLAUDE_CONFIG" "$f" 2>/dev/null && { echo "[OK] Current: $(basename "$f" .json)"; exit 0; }
        done
        echo "[?] Unknown account"
        ;;
    ""|help|-h|--help)
        echo "Usage: $0 <command>"
        echo ""
        echo "Commands:"
        echo "  save <name>   Save current account"
        echo "  <name>        Switch to account"
        echo "  list          List all accounts"
        echo "  status        Show current account"
        ;;
    *)
        switch_account "$1"
        ;;
esac
