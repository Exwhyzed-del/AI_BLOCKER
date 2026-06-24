# Log all running processes with full paths every 2 seconds!
$logFile = "c:\Users\sharm\OneDrive\Desktop\blocker\deploy\process-log.txt"
Write-Host "Logging processes to $logFile every 2 seconds!" -ForegroundColor Cyan
Write-Host "Press CTRL+C to stop logging!" -ForegroundColor Yellow
Write-Host "Make sure Antigravity is running while this script runs!" -ForegroundColor Green
Write-Host ""

# Delete old log if exists
if (Test-Path $logFile) { Remove-Item $logFile -Force }

try {
    while ($true) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $logFile -Value "--- $timestamp ---"
        $procs = Get-Process -ErrorAction SilentlyContinue
        foreach ($proc in $procs) {
            $procPath = "N/A"
            try {
                $procPath = $proc.MainModule.FileName
            } catch {}
            Add-Content -Path $logFile -Value "Name: $($proc.ProcessName) | ID: $($proc.Id) | Path: $procPath"
        }
        Start-Sleep -Seconds 2
    }
} finally {
    Write-Host ""
    Write-Host "Process log saved to: $logFile" -ForegroundColor Green
    Write-Host "Check that file for Antigravity's process name/path!" -ForegroundColor Cyan
}
