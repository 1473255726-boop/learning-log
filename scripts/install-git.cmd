@echo off
chcp 65001 >nul
setlocal
set "PS=pwsh"
where pwsh >nul 2>nul || set "PS=powershell"
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-git.ps1" %*
echo %cmdcmdline% | find /i "%~nx0" >nul
if not errorlevel 1 pause
