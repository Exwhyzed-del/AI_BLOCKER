# Auto-elevate to Administrator and run the test
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
$testScript = Join-Path -Path $scriptDir -ChildPath "test-demo.ps1"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Restarting as Administrator..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoExit", "-ExecutionPolicy Bypass", "-File", $testScript -Verb RunAs
    exit
}
