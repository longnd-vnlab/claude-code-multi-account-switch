#!/usr/bin/env python3
"""Claude Usage Checker - Get usage from all accounts"""

import os
import sys
import re
import time
import subprocess
import pty
import select

BACKUP_DIR = os.path.expanduser("~/.claude-accounts")
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

def get_usage():
    """Execute claude /usage via PTY (like sleepless-agent)"""
    master_fd, slave_fd = pty.openpty()
    env = os.environ.copy()
    env["TERM"] = "xterm-256color"
    
    # Run "claude /usage" directly (not interactive mode)
    process = subprocess.Popen(
        ["claude", "/usage"],
        stdin=slave_fd,
        stdout=slave_fd,
        stderr=slave_fd,
        env=env,
        close_fds=True,
    )
    os.close(slave_fd)
    
    buffer = []
    os.set_blocking(master_fd, False)
    
    try:
        deadline = time.monotonic() + 10
        while time.monotonic() < deadline:
            if process.poll() is not None:
                break
            ready, _, _ = select.select([master_fd], [], [], 0.1)
            if master_fd in ready:
                try:
                    chunk = os.read(master_fd, 4096)
                    if chunk:
                        buffer.append(chunk)
                        decoded = chunk.decode("utf-8", errors="ignore")
                        if "Resets" in decoded or "% used" in decoded:
                            time.sleep(0.5)
                            break
                except OSError:
                    break
        
        # Send Esc to exit
        try:
            os.write(master_fd, b"\x1b")
        except:
            pass
        
    finally:
        process.terminate()
        try:
            process.wait(timeout=2)
        except:
            process.kill()
        os.close(master_fd)
    
    output = b"".join(buffer).decode("utf-8", errors="ignore")
    return parse_usage(output)

def parse_usage(output):
    """Parse usage output"""
    # Remove ANSI codes
    ansi_escape = re.compile(r'\x1B\[[0-?]*[ -/]*[@-~]')
    text = ansi_escape.sub('', output)
    
    result = {"session": None, "week": None}
    
    # Find session usage
    session_match = re.search(r'Current session.*?(\d+)%\s*used.*?Resets\s+([^\n]+)', text, re.DOTALL)
    if session_match:
        result["session"] = f"{session_match.group(1)}% - Resets {session_match.group(2).strip()}"
    
    # Find week usage  
    week_match = re.search(r'Current week.*?(\d+)%\s*used.*?Resets\s+([^\n]+)', text, re.DOTALL)
    if week_match:
        result["week"] = f"{week_match.group(1)}% - Resets {week_match.group(2).strip()}"
    
    # Fallback: single line format "used X% of your weekly limit · resets ..."
    if not result["week"]:
        fallback = re.search(r"(\d+)%\s+of\s+your\s+weekly\s+limit\s*[·•]\s*resets\s+([^\\r\\n\x00-\x1f]+)", text, re.IGNORECASE)
        if fallback:
            reset_time = fallback.group(2).strip()
            # Fix truncated timezone
            if "Asia/Saigo" in reset_time and ")" not in reset_time:
                reset_time = reset_time.replace("Asia/Saigo", "Asia/Saigon)")
            result["week"] = f"{fallback.group(1)}% - Resets {reset_time}"
    
    return result

def switch_account(name):
    """Switch to account"""
    subprocess.run([f"{SCRIPT_DIR}/claude-switch.sh", name], 
                   capture_output=True, text=True)

def main():
    accounts = []
    for f in os.listdir(BACKUP_DIR):
        if f.endswith(".json") and not f.startswith("."):
            accounts.append(f[:-5])
    
    if not accounts:
        print("❌ No accounts found")
        return
    
    # Save current index
    current_idx = None
    idx_file = os.path.join(BACKUP_DIR, ".current_index")
    if os.path.exists(idx_file):
        with open(idx_file) as f:
            current_idx = f.read().strip()
    
    for name in sorted(accounts):
        print(f"━━━ {name} ━━━")
        switch_account(name)
        
        try:
            usage = get_usage()
            if usage["session"]:
                print(f"  Session: {usage['session']}")
            if usage["week"]:
                print(f"  Week:    {usage['week']}")
            if not usage["session"] and not usage["week"]:
                print("  No usage data")
        except Exception as e:
            print(f"  Error: {e}")
        print()
    
    # Restore
    if current_idx and accounts:
        try:
            idx = int(current_idx)
            if 0 <= idx < len(accounts):
                switch_account(sorted(accounts)[idx])
        except:
            pass

if __name__ == "__main__":
    main()
