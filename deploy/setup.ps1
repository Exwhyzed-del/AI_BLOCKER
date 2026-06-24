# AI Prevention Platform - Master Setup Script
# WARNING: Run as Administrator!

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     AI PREVENTION AND ENDPOINT CONTROL PLATFORM - SETUP           ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Please run this script as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell → Run as Administrator" -ForegroundColor Yellow
    pause
    exit 1
}

# Set execution policy
Write-Host "[1/5] Setting execution policy..." -ForegroundColor Cyan
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Write-Host "Done!" -ForegroundColor Green

# Block AI websites
Write-Host "[2/5] Blocking AI websites..." -ForegroundColor Cyan
& "$PSScriptRoot\block-ai-websites.ps1"

# Block AI in WSL/VMs (without disabling them)
Write-Host "[3/5] Blocking AI in WSL/VMs..." -ForegroundColor Cyan
& "$PSScriptRoot\restrict-ai-in-wsl-vm.ps1"

# Manage IDE extensions
Write-Host "[4/5] Managing IDE extensions..." -ForegroundColor Cyan
& "$PSScriptRoot\manage-ide-extensions.ps1"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║     SETUP COMPLETE!                                                ║" -ForegroundColor Green
Write-Host "╠═══════════════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║  Next steps:                                                       ║" -ForegroundColor Green
Write-Host "║  • Run 'monitor.ps1' to start continuous monitoring               ║" -ForegroundColor Green
Write-Host "║  • Run 'unblock-everything.ps1' to remove restrictions            ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
pause
