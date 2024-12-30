if (![Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script with administrator privileges." -ForegroundColor Red
    pause
    exit 1
}

$logFile = Join-Path $PSScriptRoot "WinScanLog.txt"
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"Windows Scan Log - $date" | Out-File $logFile

function Write-LogMessage {
    param([string]$message)
    Add-Content $logFile $message
    Write-Host $message
}

function Run-Scan {
    Write-LogMessage "Starting system scan..."

    # Run CHKDSK
    Write-LogMessage "(1/3) Running CHKDSK..."
    $chkdskResult = chkdsk /scan 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "CHKDSK failed: $chkdskResult"
    } else {
        $chkdskResult | Out-File -Append $logFile
    }

    # Run SFC
    Write-LogMessage "(2/3) Running SFC..."
    $sfcResult = sfc /verifyonly 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "SFC failed: $sfcResult"
    } else {
        $sfcResult | Out-File -Append $logFile
    }

    # Run DISM
    Write-LogMessage "(3/3) Running DISM /CheckHealth and /ScanHealth..."
    $dismCheckResult = dism /online /cleanup-image /checkhealth 2>&1
    $dismScanResult = dism /online /cleanup-image /scanhealth 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "DISM check/scan failed: $dismCheckResult $dismScanResult"
    } else {
        $dismCheckResult | Out-File -Append $logFile
        $dismScanResult | Out-File -Append $logFile
    }

    Write-LogMessage "System scan completed."
}

function Run-Repair {
    Write-LogMessage "Starting system repair..."

    # Run CHKDSK with repair
    Write-LogMessage "(1/3) Running CHKDSK with repair..."
    $chkdskResult = chkdsk /f /r 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "CHKDSK repair failed: $chkdskResult"
    } else {
        $chkdskResult | Out-File -Append $logFile
    }

    # Run SFC with repair
    Write-LogMessage "(2/3) Running SFC with repair..."
    $sfcResult = sfc /scannow 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "SFC repair failed: $sfcResult"
    } else {
        $sfcResult | Out-File -Append $logFile
    }

    # Run DISM with repair
    Write-LogMessage "(3/3) Running DISM /RestoreHealth..."
    $dismRepairResult = dism /online /cleanup-image /restorehealth 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "DISM repair failed: $dismRepairResult"
    } else {
        $dismRepairResult | Out-File -Append $logFile
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
pause
