if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
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

try {
    # Check directory for log file
    if (-not (Test-Path $PSScriptRoot)) {
        New-Item -ItemType Directory -Path $PSScriptRoot
    }

    # Run CHKDSK
    Write-LogMessage "(1/5) Running CHKDSK..."
    $chkdskResult = chkdsk /scan 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "CHKDSK failed: $chkdskResult"
    } else {
        $chkdskResult | Out-File -Append $logFile
    }

    # Run SFC
    Write-LogMessage "(2/5) Running SFC..."
    $sfcResult = sfc /scannow 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "SFC failed: $sfcResult"
    } else {
        $sfcResult | Out-File -Append $logFile
    }

    # Run DISM
    Write-LogMessage "(3/5) Running DISM..."
    $dismResult = DISM /Online /Cleanup-Image /RestoreHealth 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "DISM failed: $dismResult"
    } else {
        $dismResult | Out-File -Append $logFile
    }

    # Run SFC again
    Write-LogMessage "(4/5) Running SFC again..."
    $sfcResult2 = sfc /scannow 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "Second SFC failed: $sfcResult2"
    } else {
        $sfcResult2 | Out-File -Append $logFile
    }

    Write-LogMessage "(5/5) Running Windows Defender Quick Scan..."
    $defenderResult = Start-MpScan -ScanType QuickScan -ErrorAction Stop
    if ($LASTEXITCODE -ne 0) {
        Write-LogMessage "Windows Defender scan failed: $defenderResult"
    } else {
        Write-LogMessage "Windows Defender scan completed successfully."
    }

    Write-LogMessage "Repair process completed. Check $logFile for details."
}
catch {
    Write-LogMessage "An unexpected error occurred: $_"
}
finally {
    pause
}