# AI Prevention Platform - TEST/SETUP
# WARNING: Run as Administrator!

Write-Host ""
Write-Host "AI PREVENTION PLATFORM - FULL SETUP" -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Yellow
Write-Host ""

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Please run this script as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell -> Run as Administrator" -ForegroundColor Yellow
    pause
    exit 1
}

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1. Set execution policy
Write-Host "[1/5] Setting execution policy..." -ForegroundColor Cyan
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Write-Host "Done!" -ForegroundColor Green

# 2. Block AI websites
Write-Host "[2/5] Blocking ALL AI websites and endpoints..." -ForegroundColor Cyan
& "$scriptDir\block-ai-websites.ps1"

# 3. Block AI in WSL/VMs
Write-Host "[3/5] Blocking AI in WSL and VMs..." -ForegroundColor Cyan
& "$scriptDir\restrict-ai-in-wsl-vm.ps1"

# 4. Manage IDE extensions
Write-Host "[4/5] Removing AI extensions from IDEs..." -ForegroundColor Cyan
& "$scriptDir\manage-ide-extensions.ps1"

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SETUP COMPLETE! AI IS NOW BLOCKED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "To start continuous monitoring, run:" -ForegroundColor Cyan
Write-Host "  .\monitor.ps1"
Write-Host ""
Write-Host "To unblock everything later, run:" -ForegroundColor Cyan
Write-Host "  .\unblock-everything.ps1"
Write-Host ""
pause
