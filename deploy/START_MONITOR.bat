@echo off
powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoExit', '-ExecutionPolicy Bypass', '-File', '%~dp0monitor.ps1'"
