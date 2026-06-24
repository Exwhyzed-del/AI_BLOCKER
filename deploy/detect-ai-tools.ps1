# AI Tool Detector - Proof of Concept
# Detects and stops AI-related processes

Write-Host "AI Prevention Platform - Tool Detector POC" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$aiProcesses = @(
    "*chatgpt*",
    "*openai*",
    "*claude*",
    "*anthropic*",
    "*gemini*",
    "*copilot*",
    "*cursor*",
    "*windsurf*",
    "*continue*",
    "*tabnine*",
    "*kite*"
)

Write-Host "`nScanning for AI-related processes..." -ForegroundColor Cyan

$found = $false
foreach ($pattern in $aiProcesses) {
    $processes = Get-Process -Name $pattern -ErrorAction SilentlyContinue
    if ($processes) {
        $found = $true
        foreach ($proc in $processes) {
            Write-Host "`nDETECTED: $($proc.ProcessName) (PID: $($proc.Id))" -ForegroundColor Red
            $confirm = Read-Host "Stop this process? (Y/N)"
            if ($confirm -eq "Y" -or $confirm -eq "y") {
                Stop-Process -Id $proc.Id -Force
                Write-Host "STOPPED: $($proc.ProcessName)" -ForegroundColor Green
            }
        }
    }
}

if (-not $found) {
    Write-Host "`nNo AI-related processes detected!" -ForegroundColor Green
}

# Check VS Code extensions
Write-Host "`nChecking VS Code extensions..." -ForegroundColor Cyan
$vscodeExtensionsPath = "$env:USERPROFILE\.vscode\extensions"
if (Test-Path $vscodeExtensionsPath) {
    $aiExtensions = Get-ChildItem -Path $vscodeExtensionsPath -Directory | Where-Object {
        $_.Name -like "*copilot*" -or 
        $_.Name -like "*tabnine*" -or 
        $_.Name -like "*kite*" -or 
        $_.Name -like "*cursor*" -or 
        $_.Name -like "*continue*"
    }
    
    if ($aiExtensions) {
        foreach ($ext in $aiExtensions) {
            Write-Host "AI Extension Found: $($ext.Name)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "No AI extensions found in VS Code!" -ForegroundColor Green
    }
}
