@echo off
setlocal

:: Pfad zur PowerShell-Datei
set "PowerShellScript=winscan.ps1"

:: Überprüfen, ob das Skript existiert
if not exist "%PowerShellScript%" (
    echo Das PowerShell-Skript wurde nicht gefunden: %PowerShellScript%
    pause
    exit /b 1
)

:: PowerShell mit Administratorrechten ausführen
powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%CD%\%PowerShellScript%\"' -Verb RunAs"

cmd /k

endlocal