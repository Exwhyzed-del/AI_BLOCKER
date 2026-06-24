# AI Prevention Platform - Persistent Monitor
# Kills ANY process with AI keywords!
# Runs continuously in background

Write-Host "AI Prevention Platform - Persistent Monitor" -ForegroundColor Cyan
Write-Host "Kills ANY process with AI keywords! Press Ctrl+C to stop." -ForegroundColor Cyan

# AI keywords to block ANY process
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

while ($true) {
    # Get ALL running processes
    $allProcesses = Get-Process -ErrorAction SilentlyContinue
    foreach ($proc in $allProcesses) {
        $procName = $proc.ProcessName.ToLower()
        foreach ($keyword in $aiKeywords) {
            if ($procName -like "*$keyword*") {
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] DETECTED & STOPPED: $($proc.ProcessName)" -ForegroundColor Red
                Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
                break
            }
        }
    }
    Start-Sleep -Seconds 1  # Check every 1 second!
}
