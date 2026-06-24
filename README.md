# AI_BLOCKER - AI Prevention & Endpoint Control Platform

A comprehensive, keyword-based system to block AI usage across Windows devices!

## What It Blocks
- **AUTOMATICALLY blocks ANY AI website/app/extension** using keywords (no need to list every new AI tool!)
- Blocks ANY domain with AI keywords (gpt, llm, copilot, chatgpt, claude, etc.)
- Blocks ALL GitHub Copilot API endpoints
- Blocks ANY VS Code extension with AI keywords (auto-removes them!)
- Kills ANY running process with AI keywords every 2 seconds
- Blocks AI usage inside WSL/Ubuntu and VMs (without disabling WSL/VMs!)
- Flushes DNS cache to ensure changes take effect immediately

## How to Use

### 1. Installation
1. **Right-click PowerShell → Run as Administrator**
2. Navigate to the `deploy` folder:
   ```powershell
   cd c:\path\to\AI_BLOCKER\deploy
   ```
3. Run the full setup:
   ```powershell
   .\test-demo.ps1
   ```

### 2. Continuous Monitoring
Run the monitor script to automatically kill any AI processes that try to start:
```powershell
.\monitor.ps1
```
Leave this running in a PowerShell window!

### 3. Uninstall/Unblock
If you want to remove all restrictions, run:
```powershell
.\unblock-everything.ps1
```

## Files in deploy/
| File | Purpose |
|------|---------|
| `test-demo.ps1` | FULL SETUP - runs all components! |
| `block-ai-websites.ps1` | Blocks AI domains via hosts file (keyword + specific endpoints) |
| `detect-ai-tools.ps1` | Detects and stops running AI tools |
| `manage-ide-extensions.ps1` | Removes AI extensions from VS Code (auto!) |
| `restrict-ai-in-wsl-vm.ps1` | Blocks AI inside WSL/VMs |
| `monitor.ps1` | Persistent background monitor (kills AI processes every 2 sec) |
| `unblock-everything.ps1` | Removes ALL restrictions |
| `start-as-admin.ps1` | Auto-elevates to admin and runs setup |

## Project Structure
```
AI_BLOCKER/
├── kernel-driver/       # Windows KMDF driver (skeleton for future)
├── user-mode-service/   # Windows security service (skeleton for future)
├── backend/             # Go backend API (skeleton for future)
├── dashboard/           # Web dashboard UI
├── deploy/              # PowerShell POC scripts (the working part!)
└── README.md            # This file
```

## Notes
- The PowerShell scripts are the working proof-of-concept
- The kernel-driver, user-mode-service, and backend are skeletons for future expansion
- Always run scripts as **Administrator**
- To modify which keywords are blocked, edit the `$aiKeywords` array in each script
