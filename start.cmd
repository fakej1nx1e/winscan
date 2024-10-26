@echo off
setlocal

:: Path to PowerShell script
set "PowerShellScript=winscan.ps1"

:: Check if script exists
if not exist "%PowerShellScript%" (
    echo PowerShell script not found: %PowerShellScript%
    pause
    exit /b 1
)

:: Run PowerShell with administrator rights
powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%CD%\%PowerShellScript%\"' -Verb RunAs"

endlocal
