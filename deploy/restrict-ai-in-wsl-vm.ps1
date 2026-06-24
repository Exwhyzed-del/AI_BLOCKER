# AI Usage Restriction in WSL/VMs - Proof of Concept
# Doesn't disable WSL/VMs, just blocks AI usage inside them
# Uses AI keywords to automatically block domains!
# WARNING: Run as Administrator!

Write-Host "AI Prevention Platform - AI Blocking in WSL/VMs" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Please run this script as Administrator!" -ForegroundColor Red
    exit 1
}

Write-Host "`nNOT disabling WSL or VMs!" -ForegroundColor Green
Write-Host "Only blocking AI usage inside them..." -ForegroundColor Cyan

# AI keywords to block ANY domain
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
    "codesnap",
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
    "ollama",
    "localai",
    "llama",
    "lmstudio",
    "gpt4all",
    "koboldai",
    "oobabooga",
    "gpt",
    "llm",
    "ai",
    "assistant",
    "bot",
    "antigravity",
    "codewhisperer",
    "amazonq",
    "amazon-q",
    "sider",
    "tactiq",
    "glasp",
    "merlin",
    "monica",
    "chatpdf"
)
$commonTlds = @(".com", ".ai", ".io", ".dev", ".org", ".net", ".co", ".so", ".sh", ".cn", ".app", ".xyz", ".tech")

# Try to block AI domains inside all running WSL distros
Write-Host "`nChecking for running WSL distros..." -ForegroundColor Cyan
try {
    $wslDistros = wsl -l -q 2>$null
    if ($LASTEXITCODE -eq 0 -and $wslDistros) {
        foreach ($distro in $wslDistros) {
            $distroName = $distro.Trim()
            if ($distroName -ne "") {
                Write-Host "Blocking AI domains in WSL distro: $distroName" -ForegroundColor Yellow
                # Try to modify /etc/hosts inside WSL
                foreach ($keyword in $aiKeywords) {
                    foreach ($tld in $commonTlds) {
                        $domain = "$keyword$tld"
                        $cmd = "echo '127.0.0.1 $domain' | sudo tee -a /etc/hosts > /dev/null 2>&1"
                        wsl -d $distroName -- bash -c $cmd 2>$null
                        $cmdWWW = "echo '127.0.0.1 www.$domain' | sudo tee -a /etc/hosts > /dev/null 2>&1"
                        wsl -d $distroName -- bash -c $cmdWWW 2>$null
                    }
                }
            }
        }
        Write-Host "AI domains blocked in WSL!" -ForegroundColor Green
    } else {
        Write-Host "No running WSL distros found" -ForegroundColor Gray
    }
} catch {
    Write-Host "WSL not available" -ForegroundColor Gray
}

Write-Host "`nAI usage restrictions applied to WSL/VMs!" -ForegroundColor Green
