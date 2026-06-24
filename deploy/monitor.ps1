# AI Prevention Platform - Persistent Monitor
# Kills ANY process with AI keywords!
# Runs continuously in background - EASY TO STOP!

# Clear the console for clean look
Clear-Host

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   AI Prevention Platform - Monitor Mode" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press **CTRL + C** at ANY time to stop the monitor!" -ForegroundColor Yellow
Write-Host "Or just close this window!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Monitoring for AI processes... (checking every 0.25 seconds)" -ForegroundColor Cyan
Write-Host ""

# AI keywords to block ANY process - SUPER AGGRESSIVE!
$aiKeywords = @(
    "chatgpt",
    "openai",
    "claude",
    "anthropic",
    "gemini",
    "copilot",
    "cursor",
    "windsurf",
    "continue",
    "tabnine",
    "kite",
    "codeium",
    "cody",
    "ghostwriter",
    "replit",
    "stability",
    "dreamstudio",
    "midjourney",
    "leonardo",
    "firefly",
    "runway",
    "synthesia",
    "elevenlabs",
    "ollama",
    "localai",
    "llama",
    "gpt4all",
    "lmstudio",
    "koboldai",
    "oobabooga",
    "gpt",
    "llm",
    "ai",
    "assistant",
    "bot",
    "model",
    "antigravity",
    "antigravity ide",
    "agent-tool-host",
    "codewhisperer",
    "amazonq",
    "amazon-q",
    "sider",
    "tactiq",
    "glasp",
    "merlin",
    "monica",
    "chatpdf",
    "doctrina",
    "filechat",
    "quillbot",
    "grammarly",
    "wordtune",
    "jasper",
    "copy.ai",
    "writesonic",
    "rytr",
    "frase",
    "outranking",
    "surfer",
    "clearscope",
    "marketmuse",
    "marketbrew"
)

try {
    while ($true) {
        # Get ALL running processes
        $allProcesses = Get-Process -ErrorAction SilentlyContinue
        foreach ($proc in $allProcesses) {
            $procName = $proc.ProcessName.ToLower()
            $procPath = ""
            try {
                $procPath = $proc.MainModule.FileName.ToLower()
            } catch {}
            
            $killIt = $false
            foreach ($keyword in $aiKeywords) {
                if ($procName -like "*$keyword*" -or $procPath -like "*$keyword*") {
                    $killIt = $true
                    break
                }
            }
            
            if ($killIt) {
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] DETECTED & STOPPED: $($proc.ProcessName)" -ForegroundColor Red
                try {
                    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
                } catch {
                    # Ignore errors if process already stopped
                }
            }
        }
        Start-Sleep -Milliseconds 250  # Check every 0.25 seconds!
    }
} finally {
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "   Monitor stopped successfully!" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host ""
}
