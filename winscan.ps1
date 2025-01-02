# Check for admin privileges
if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script with administrator privileges." -ForegroundColor Red
    pause
    exit 1
}

# Initialize log file
$logFile = Join-Path $PSScriptRoot "WinScanLog.txt"
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"Windows Scan Log - $date" | Out-File $logFile

function Write-LogMessage {
    param([string]$message)
    Add-Content $logFile $message
    Write-Host $message
}

# Define functions for scan and repair
function Run-Scan {
    Write-LogMessage "Starting system scan..."
    $commands = @(
        "chkdsk /scan"
        "sfc /verifyonly"
        "dism /online /cleanup-image /scanhealth"
    )
    foreach ($command in $commands) {
        Write-LogMessage "Running $command..."
        $result = Invoke-Expression $command 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-LogMessage "$command failed: $result"
        } else {
            $result | Out-File -Append $logFile
        }
    }
    Write-LogMessage "System scan completed."
}

function Run-Repair {
    Write-LogMessage "Starting system repair..."
    $commands = @(
        "chkdsk /f /r"
        "sfc /scannow"
        "dism /online /cleanup-image /restorehealth"
    )
    foreach ($command in $commands) {
        Write-LogMessage "Running $command..."
        $result = Invoke-Expression $command 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-LogMessage "$command failed: $result"
        } else {
            $result | Out-File -Append $logFile
        }
    }
    Write-LogMessage "System repair completed."
}

# User selection
Write-Host "Select an option:" -ForegroundColor Cyan
Write-Host "1. Scan only (no changes made)" -ForegroundColor Yellow
Write-Host "2. Repair (fix issues)" -ForegroundColor Yellow

$choice = Read-Host "Enter your choice (1 or 2)"

switch ($choice) {
    "1" {
        Run-Scan
    }
    "2" {
        Run-Repair
    }
    default {
        Write-Host "Invalid choice. Exiting." -ForegroundColor Red
        exit 1
    }
}

Write-LogMessage "Operation completed. See log file at $logFile for details."

Write-Host "Press enter to open log file or any other key to exit" -ForegroundColor Cyan
$readKey = [Console]::ReadKey()
if ($readKey.Key -eq [ConsoleKey]::Enter) {
    Start-Process $logFile
}
