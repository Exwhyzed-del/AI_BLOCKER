# AI_BLOCKER - AI Prevention & Endpoint Control Platform

A comprehensive, keyword-based system to block AI usage across Windows devices!

## ✅ What It Does
- **AUTOMATICALLY blocks ANY AI website/app/extension using keywords** (no need to list every new AI tool!)
- Blocks **ANY domain** with AI keywords (gpt, llm, copilot, chatgpt, claude, etc.)
- Blocks **all known AI API endpoints** (GitHub Copilot, OpenAI, Anthropic, etc.)
- **Uninstalls ANY VS Code extension** with AI keywords
- **Kills ANY running process** with AI keywords every 1 second
- **Blocks AI usage inside WSL/VMs** without disabling WSL/VMs!
- **Flushes DNS cache** to ensure changes take effect immediately

## 📁 Project Structure
```
AI_BLOCKER/
├── kernel-driver/       # Skeleton for Windows kernel driver (future work)
├── user-mode-service/   # Skeleton for Windows system service (future work)
├── backend/             # Skeleton for Go backend (future work)
├── dashboard/           # Simple HTML admin dashboard
├── deploy/              # ⭐ WORKING PROOF-OF-CONCEPT SCRIPTS (use these!)
│   ├── RUN_ME_AS_ADMIN.bat  # Easy one-click setup (right-click → Run as admin)
│   ├── test-demo.ps1        # Full setup (runs all components)
│   ├── block-ai-websites.ps1# Blocks AI domains via hosts file
│   ├── detect-ai-tools.ps1  # Detects and stops running AI tools
│   ├── manage-ide-extensions.ps1  # Removes AI extensions from VS Code
│   ├── restrict-ai-in-wsl-vm.ps1  # Blocks AI inside WSL/VMs
│   ├── monitor.ps1          # Persistent monitor (kills AI processes every 1 sec)
│   ├── unblock-everything.ps1  # Removes ALL restrictions
│   └── UNBLOCK_ME.bat          # Easy one-click unblock (right-click → Run as admin)
└── README.md              # This file!
```

## 🚀 Quick Start (Easiest Way)
1. **Right-click `deploy/RUN_ME_AS_ADMIN.bat` → Run as administrator**
2. Done! Now open **another PowerShell as administrator** and run:
   ```powershell
   cd c:\path\to\AI_BLOCKER\deploy
   .\monitor.ps1
   ```
   (leave this running to continuously kill AI processes!)

---

## 🛠️ Manual Commands (All PowerShell scripts must be run as Administrator!)

### 1. Full Setup
```powershell
cd c:\path\to\AI_BLOCKER\deploy
.\test-demo.ps1
```

### 2. Only Block AI Websites
```powershell
cd c:\path\to\AI_BLOCKER\deploy
.\block-ai-websites.ps1
```

### 3. Only Detect/Stop AI Tools
```powershell
cd c:\path\to\AI_BLOCKER\deploy
.\detect-ai-tools.ps1
```

### 4. Only Remove AI Extensions from VS Code
```powershell
cd c:\path\to\AI_BLOCKER\deploy
.\manage-ide-extensions.ps1
```

### 5. Only Block AI inside WSL/VMs
```powershell
cd c:\path\to\AI_BLOCKER\deploy
.\restrict-ai-in-wsl-vm.ps1
```

### 6. Start Persistent Monitor (Kills AI Processes Every 1 Second)
```powershell
cd c:\path\to\AI_BLOCKER\deploy
.\monitor.ps1
```
(leave this PowerShell window open!)

### 7. UNBLOCK EVERYTHING
**Easiest way:** Right-click `deploy/UNBLOCK_ME.bat` → Run as administrator

Or manually:
```powershell
cd c:\path\to\AI_BLOCKER\deploy
.\unblock-everything.ps1
```

---

## 📝 Notes
- **Always run scripts as Administrator** (right-click PowerShell → Run as administrator)
- **To add more keywords**, edit the `$aiKeywords` array in any script
- **Monitor script checks every 1 second** to kill any AI process instantly
- **Restart VS Code after running `manage-ide-extensions.ps1`** for changes to take effect

---

## 🚧 Future Work
- Kernel driver for low-level process monitoring
- Windows service for auto-start on boot
- Go backend with PostgreSQL for policy management
- Proper web dashboard with real-time threat reports
- Signed MSI installer for enterprise deployment
