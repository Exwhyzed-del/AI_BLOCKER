# IDE Extension Manager - Proof of Concept
# Automatically removes ANY extension with AI keywords!
# Manages extensions for VS Code, Visual Studio, JetBrains IDEs

Write-Host "AI Prevention Platform - IDE Extension Manager" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# AI keywords to block ANY extension
$aiKeywords = @(
    "copilot",
    "tabnine",
    "kite",
    "cursor",
    "continue",
    "windsurf",
    "codeium",
    "cody",
    "ghostwriter",
    "amazon",
    "sourcery",
    "mutable",
    "codestory",
    "codesnap",
    "replit",
    "codepen",
    "codesandbox",
    "gpt",
    "llm",
    "chatgpt",
    "claude",
    "gemini",
    "mistral",
    "cohere",
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

# VS Code Extensions - try to remove via code CLI if available
Write-Host "`n--- VS Code Extensions ---" -ForegroundColor Cyan
$codePaths = @(
    "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd",
    "${env:ProgramFiles}\Microsoft VS Code\bin\code.cmd",
    "${env:ProgramFiles(x86)}\Microsoft VS Code\bin\code.cmd"
)
$codeExe = $null
foreach ($path in $codePaths) {
    if (Test-Path $path) {
        $codeExe = $path
        break
    }
}

# First try to uninstall via VS Code CLI
if ($codeExe) {
    Write-Host "Trying to uninstall AI extensions via VS Code CLI..." -ForegroundColor Yellow
    & $codeExe --uninstall-extension GitHub.copilot 2>$null
    & $codeExe --uninstall-extension GitHub.copilot-chat 2>$null
    & $codeExe --uninstall-extension GitHub.copilot-labs 2>$null
    Write-Host "Done!" -ForegroundColor Green
}

# Then manually remove from extensions folder
$vscodeExtensionsPath = "$env:USERPROFILE\.vscode\extensions"
if (Test-Path $vscodeExtensionsPath) {
    $allExtensions = Get-ChildItem -Path $vscodeExtensionsPath -Directory -ErrorAction SilentlyContinue
    foreach ($ext in $allExtensions) {
        $extName = $ext.Name.ToLower()
        foreach ($keyword in $aiKeywords) {
            if ($extName -like "*$keyword*") {
                Write-Host "REMOVING AI Extension: $($ext.Name)" -ForegroundColor Red
                Remove-Item -Path $ext.FullName -Recurse -Force -ErrorAction SilentlyContinue
                break
            }
        }
    }
    Write-Host "VS Code AI extensions removed!" -ForegroundColor Green
} else {
    Write-Host "VS Code extensions folder not found" -ForegroundColor Gray
}

# VS Code settings to disable AI features COMPLETELY
Write-Host "`nUpdating VS Code settings..." -ForegroundColor Cyan
$vscodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
if (-not (Test-Path $vscodeSettingsPath)) {
    New-Item -Path $vscodeSettingsPath -ItemType File -Force | Out-Null
    "{}" | Set-Content -Path $vscodeSettingsPath
}
try {
    $settings = Get-Content -Path $vscodeSettingsPath -Raw | ConvertFrom-Json
    # Disable ALL known Copilot and AI settings
    $settings | Add-Member -MemberType NoteProperty -Name "github.copilot.enable" -Value @{"*" = $false} -Force
    $settings | Add-Member -MemberType NoteProperty -Name "github.copilot.enableCompletions" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "github.copilot.enableChat" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "github.copilot.chat.codeExecution" -Value "never" -Force
    $settings | Add-Member -MemberType NoteProperty -Name "github.copilot.editor.enableAutoCompletions" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "github.copilot.codeSuggestions.enabled" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "github.copilot.chat.enableHistory" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "github.copilot.chat.enableIndexing" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "github.copilot.chat.enableVoice" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "tabnine.enabled" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "codeium.enable" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "continue.enable" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "cody.enabled" -Value $false -Force
    $settings | Add-Member -MemberType NoteProperty -Name "sourcery.enabled" -Value $false -Force
    $settings | ConvertTo-Json -Depth 10 | Set-Content -Path $vscodeSettingsPath
    Write-Host "VS Code AI features COMPLETELY DISABLED!" -ForegroundColor Green
} catch {
    Write-Host "Could not update VS Code settings" -ForegroundColor Yellow
}

# Also modify VS Code workspace storage to disable Copilot
Write-Host "`nCleaning VS Code AI extension storage..." -ForegroundColor Cyan
$vscodeStoragePath = "$env:APPDATA\Code\User\globalStorage"
if (Test-Path $vscodeStoragePath) {
    $copilotFolders = Get-ChildItem -Path $vscodeStoragePath -Directory -ErrorAction SilentlyContinue | Where-Object {
        foreach ($keyword in $aiKeywords) {
            if ($_.Name -like "*$keyword*") {
                return $true
            }
        }
        return $false
    }
    foreach ($folder in $copilotFolders) {
        Write-Host "Deleting: $($folder.Name)" -ForegroundColor Red
        Remove-Item -Path $folder.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "`nIDE extension management complete!" -ForegroundColor Green
Write-Host "IMPORTANT: Please RESTART VS CODE for changes to take effect!" -ForegroundColor Yellow
