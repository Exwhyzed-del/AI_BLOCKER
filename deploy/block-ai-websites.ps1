# AI Website Blocker - Proof of Concept
# Blocks ANY domain with AI keywords
# WARNING: This modifies your system hosts file! Run as Administrator!

$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$aiKeywords = @(
    "chatgpt",
    "openai",
    "claude",
    "anthropic",
    "gemini",
    "copilot",
    "githubcopilot",
    "codeium",
    "tabnine",
    "kite",
    "continue",
    "cursor",
    "windsurf",
    "codestory",
    "replit",
    "huggingface",
    "mistral",
    "stability",
    "midjourney",
    "perplexity",
    "poe",
    "you.com",
    "youchat",
    "character",
    "replika",
    "synthesia",
    "elevenlabs",
    "runway",
    "leonardo",
    "firefly",
    "gencraft",
    "playground",
    "deepai",
    "neural",
    "letsenhance",
    "topaz",
    "luminar",
    "clipdrop",
    "cleanup",
    "remove.bg",
    "upscale",
    "remini",
    "myheritage",
    "deepswap",
    "faceapp",
    "reface",
    "unboring",
    "ollama",
    "localai",
    "llama",
    "lmstudio",
    "gpt4all",
    "koboldai",
    "oobabooga",
    "gpt",
    "llm",
    "ai"
)

# Specific Copilot and AI API endpoints
$specificAiEndpoints = @(
    "api.githubcopilot.com",
    "copilot-proxy.githubusercontent.com",
    "copilot-telemetry.githubusercontent.com",
    "origin-tracker.githubusercontent.com",
    "copilot-cdn.githubusercontent.com",
    "api.individual.githubcopilot.com",
    "copilot.microsoft.com",
    "api.copilot.microsoft.com",
    "msit-copilot.azureedge.net",
    "api.openai.com",
    "api.anthropic.com",
    "generativelanguage.googleapis.com",
    "api.together.xyz",
    "api.endpoints.anyscale.com",
    "api.lepton.run",
    "api.fireworks.ai",
    "api.deepinfra.com",
    "gateway.ai.cloudflare.com",
    "api.cohere.ai",
    "api.mistral.ai",
    "api.stability.ai"
)

Write-Host "AI Prevention Platform - Website Blocker" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Please run this script as Administrator!" -ForegroundColor Red
    pause
    exit 1
}

# Backup hosts file
$backupPath = "$hostsPath.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
Copy-Item $hostsPath -Destination $backupPath
Write-Host "Hosts file backed up to: $backupPath" -ForegroundColor Green

# Read existing hosts file into memory
$hostsContent = Get-Content -Path $hostsPath -Raw
$hostsLines = Get-Content -Path $hostsPath
$hostsLinesLower = $hostsLines | ForEach-Object { $_.ToLower() }

# Generate all AI domain entries
$commonTlds = @(".com", ".ai", ".io", ".dev", ".org", ".net", ".co", ".so", ".sh", ".cn")
$newEntries = @()

# Add keyword-based entries
foreach ($keyword in $aiKeywords) {
    foreach ($tld in $commonTlds) {
        $domain = "$keyword$tld"
        $wwwDomain = "www.$domain"
        foreach ($d in @($domain, $wwwDomain)) {
            $entry = "127.0.0.1 $d"
            $found = $false
            foreach ($line in $hostsLinesLower) {
                if ($line -like "*$d*") {
                    $found = $true
                    break
                }
            }
            if (-not $found) {
                $newEntries += $entry
            }
        }
    }
}

# Add specific API endpoints
foreach ($d in $specificAiEndpoints) {
    $entry = "127.0.0.1 $d"
    $found = $false
    foreach ($line in $hostsLinesLower) {
        if ($line -like "*$d*") {
            $found = $true
            break
        }
    }
    if (-not $found) {
        $newEntries += $entry
    }
}

# Combine existing content with new entries
if ($newEntries.Count -gt 0) {
    $finalContent = $hostsContent + "`n" + ($newEntries -join "`n")
    # Write the entire file back with retries
    $retryCount = 5
    $success = $false
    for ($i = 0; $i -lt $retryCount; $i++) {
        try {
            [System.IO.File]::WriteAllText($hostsPath, $finalContent)
            $success = $true
            break
        } catch {
            Write-Host "Waiting for hosts file to be available... (Attempt $($i+1)/$retryCount)" -ForegroundColor Yellow
            Start-Sleep -Milliseconds 500
        }
    }
    if ($success) {
        Write-Host "Successfully blocked $($newEntries.Count) AI domains!" -ForegroundColor Green
    } else {
        Write-Host "ERROR: Could not write to hosts file! Please close any programs that might be using it." -ForegroundColor Red
    }
} else {
    Write-Host "No new AI domains to block!" -ForegroundColor Gray
}

# Flush DNS cache
ipconfig /flushdns | Out-Null
Write-Host "DNS cache flushed!" -ForegroundColor Green
Write-Host "All AI websites and endpoints are now blocked!" -ForegroundColor Green
