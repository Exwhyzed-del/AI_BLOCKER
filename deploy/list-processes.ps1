# List all running processes to find Antigravity's name
Write-Host "Listing all running processes..." -ForegroundColor Cyan
Write-Host "Look for anything with 'antigravity' or similar in the name!" -ForegroundColor Yellow
Write-Host ""
Get-Process | Select-Object ProcessName, Id | Format-Table -AutoSize
Write-Host ""
Write-Host "Copy the ProcessName of Antigravity and tell us what it is!" -ForegroundColor Green
pause
