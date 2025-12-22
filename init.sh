#!/bin/bash

# Init Claude Code Multi-Account Switcher

DIR="$(cd "$(dirname "$0")" && pwd)"

chmod +x "$DIR/claude-switch.sh" "$DIR/claude-sync.sh" "$DIR/claude-next.sh" "$DIR/claude-usage.py"

# Add aliases
grep -q "claude-switch=" ~/.bashrc || echo "alias claude-switch=\"$DIR/claude-switch.sh\"" >> ~/.bashrc
grep -q "claude-sync=" ~/.bashrc || echo "alias claude-sync=\"$DIR/claude-sync.sh\"" >> ~/.bashrc
grep -q "claude-next=" ~/.bashrc || echo "alias claude-next=\"$DIR/claude-next.sh\"" >> ~/.bashrc
grep -q "claude-usage=" ~/.bashrc || echo "alias claude-usage=\"python3 $DIR/claude-usage.py\"" >> ~/.bashrc

echo "✅ Installed!"
echo ""
echo "👉 Run this to activate: source ~/.bashrc"
echo "   Or restart your terminal"
echo ""
echo "Commands:"
echo "  claude-switch <name>  - Switch account"
echo "  claude-switch save <name> - Save current account"
echo "  claude-switch list    - List accounts"
echo "  claude-sync           - Sync sessions between all accounts"
echo "  claude-next           - Switch to next account"
echo "  claude-usage          - View usage of all accounts"
