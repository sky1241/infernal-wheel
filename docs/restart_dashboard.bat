@echo off
taskkill /F /IM powershell.exe 2>nul
timeout /t 3 /nobreak >nul
start "" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:\Users\ludov\.infernal_wheel\hellwell\start_dashboard.ps1"
