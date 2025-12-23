#!/bin/bash

# Claude Session Sync - Cross-sync sessions between ALL accounts

BACKUP_DIR="$HOME/.claude-accounts"
CLAUDE_DIR="$HOME/.claude"

sync_cross() {
    # Collect all sessions from all accounts + current
    tmp=$(mktemp -d)
    
    # From current account
    [ -d "$CLAUDE_DIR/projects" ] && cp -r "$CLAUDE_DIR/projects"/* "$tmp/" 2>/dev/null
    
    # From all saved accounts
    for f in "$BACKUP_DIR"/*-dir/projects; do
        [ -d "$f" ] && cp -rn "$f"/* "$tmp/" 2>/dev/null
    done
    
    # Distribute to all
    [ -d "$tmp" ] && [ "$(ls -A "$tmp" 2>/dev/null)" ] && {
        # To current
        mkdir -p "$CLAUDE_DIR/projects"
        cp -r "$tmp"/* "$CLAUDE_DIR/projects/"
        
        # To all saved accounts
        for f in "$BACKUP_DIR"/*-dir; do
            [ -d "$f" ] || continue
            mkdir -p "$f/projects"
            cp -r "$tmp"/* "$f/projects/"
            echo "[OK] Synced: $(basename "$f" -dir)"
        done
    }
    
    rm -rf "$tmp"
    echo "[OK] Cross-sync complete!"
}

case "$1" in
    sync|"")
        sync_cross
        ;;
    *)
        echo "Usage: $0 [sync]"
        echo "Cross-sync all sessions between ALL accounts"
        ;;
esac
