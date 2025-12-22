# Claude Code Multi-Account Switcher

Quickly switch between multiple Claude Code accounts.

## Installation

```bash
./init.sh
source ~/.bashrc
```

The `init.sh` script automatically creates convenient aliases for all commands:
- `claude-switch` → `claude-switch.sh`
- `claude-sync` → `claude-sync.sh`
- `claude-next` → `claude-next.sh`
- `claude-usage` → `python3 claude-usage.py`

After installation, you can run these commands from anywhere in your terminal!

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
```
<img width="784" height="114" alt="Screenshot from 2025-12-22 22-51-28" src="https://github.com/user-attachments/assets/b4c71d33-23ae-4152-a529-b6d1c40e60de" />

```bash
claude-switch status    # Show current account
```
<img width="853" height="45" alt="Screenshot from 2025-12-22 22-51-04" src="https://github.com/user-attachments/assets/01e8f373-e175-4584-8992-935239903f34" />

```bash
claude-next             # Switch to next account (round-robin)
```
<img width="727" height="63" alt="Screenshot from 2025-12-22 22-50-34" src="https://github.com/user-attachments/assets/8cbcbe21-c347-4adc-aa66-cfbf6a5563b3" />

```bash
claude-usage            # Show usage of all accounts
```
<img width="880" height="306" alt="Screenshot from 2025-12-22 22-51-49" src="https://github.com/user-attachments/assets/d29e01ba-18d5-4b49-aa94-2da9d47ed362" />


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


