@echo off
echo AI_BLOCKER - UNBLOCK EVERYTHING
echo.
echo If you don't see "Administrator" in the window title, close this and right-click -> Run as administrator!
echo.
pause
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File unblock-everything.ps1
pause
