# UNBLOCK SCRIPT - Cleans up all restrictions
# WARNING: Run as Administrator!

Write-Host "AI Prevention Platform - UNBLOCK Script" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Please run this script as Administrator!" -ForegroundColor Red
    pause
    exit 1
}

# Restore hosts file
Write-Host "`nRestoring hosts file..." -ForegroundColor Cyan
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$backups = Get-ChildItem -Path "$env:SystemRoot\System32\drivers\etc\" -Filter "hosts.backup.*" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
if ($backups) {
    $latestBackup = $backups[0].FullName
    Copy-Item -Path $latestBackup -Destination $hostsPath -Force
    Write-Host "Hosts file restored from: $latestBackup" -ForegroundColor Green
} else {
    Write-Host "No backup found. Removing ALL AI blocks from hosts file..." -ForegroundColor Yellow
    $hostsContent = Get-Content -Path $hostsPath
    # Remove any line that has 127.0.0.1 and AI-related keywords
    $cleanContent = $hostsContent | Where-Object {
        -not ($_ -match "127\.0\.0\.1" -and ($_ -match "chatgpt|openai|claude|anthropic|gemini|cohere|huggingface|mistral|stability|midjourney|perplexity|poe|copilot|cursor|codeium|tabnine|kite|ollama|localai|antigravity|cody|ghostwriter|sourcery|mutable|codepen|codesandbox|codewhisperer|amazonq|sider|tactiq|glasp|merlin|monica|chatpdf|gpt|llm|ai|assistant|bot" -or $_ -match "\.ai|\.dev"))
    }
    $cleanContent | Set-Content -Path $hostsPath
}

# Flush DNS
ipconfig /flushdns | Out-Null

# Unblock AI in WSL
Write-Host "`nUnblocking AI in WSL..." -ForegroundColor Cyan
try {
    $wslDistros = wsl -l -q 2>$null
    if ($LASTEXITCODE -eq 0 -and $wslDistros) {
        foreach ($distro in $wslDistros) {
            $distroName = $distro.Trim()
            if ($distroName -ne "") {
                Write-Host "Unblocking in WSL distro: $distroName" -ForegroundColor Yellow
                # Remove any line with 127.0.0.1 and AI keywords from /etc/hosts in WSL
                $cmd = "sudo sed -i '/127\.0\.0\.1.*\(chatgpt\|openai\|claude\|anthropic\|gemini\|cohere\|huggingface\|mistral\|stability\|midjourney\|perplexity\|poe\|copilot\|cursor\|codeium\|tabnine\|kite\|ollama\|localai\|antigravity\|cody\|ghostwriter\|sourcery\|mutable\|codepen\|codesandbox\|codewhisperer\|amazonq\|sider\|tactiq\|glasp\|merlin\|monica\|chatpdf\|gpt\|llm\|ai\|assistant\|bot\|\.ai\)/d' /etc/hosts"
                wsl -d $distroName -- bash -c $cmd 2>$null
            }
        }
        Write-Host "AI unblocked in WSL!" -ForegroundColor Green
    }
} catch {}

Write-Host "`nAll restrictions removed!" -ForegroundColor Green
Write-Host ""
pause
