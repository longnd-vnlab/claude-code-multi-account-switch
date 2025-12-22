# Claude Code Multi-Account Switcher

Quickly switch between multiple Claude Code accounts.

## Installation

```bash
./init.sh
source ~/.bashrc
```

## Usage

### 1. Save account

```bash
claude login                    # Login
claude-switch save work         # Save as "work"
```

### 2. Switch account

```bash
claude-switch work
claude-switch personal
```

### 3. Other commands

```bash
claude-switch list      # List all accounts
claude-switch status    # Show current account
claude-next             # Switch to next account (round-robin)
claude-usage            # Show usage of all accounts
```

## Sync Sessions Between Accounts

Share conversation history between all accounts so `claude --resume` works on any account.

```bash
claude-sync    # Cross-sync all sessions between accounts
```

### Workflow

```bash
# Work on account1, create new session
claude-switch account1
claude

# Sync sessions to all accounts
claude-sync

# Switch to account2, resume same session
claude-switch account2
claude --resume
```

## Notes

- Data stored at `~/.claude-accounts/`
- Script auto-backups before switching
- Each account keeps its own login token
- Sync only shares conversation history, not tokens
- `claude-usage` requires Python 3 (uses standard library only, no pip install needed)
# claude-code-multi-account-switch
