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
    # Run CHKDSK
    Write-LogMessage "(1/4) Running CHKDSK..."
    $chkdskResult = chkdsk /scan
    $chkdskResult | Out-File -Append $logFile

    # Run SFC
    Write-LogMessage "(2/4) Running SFC..."
    $sfcResult = sfc /scannow
    $sfcResult | Out-File -Append $logFile

    # Run DISM
    Write-LogMessage "(3/4) Running DISM..."
    $dismResult = DISM /Online /Cleanup-Image /RestoreHealth
    $dismResult | Out-File -Append $logFile

    # Run SFC again
    Write-LogMessage "(4/4) Running SFC again..."
    $sfcResult2 = sfc /scannow
    $sfcResult2 | Out-File -Append $logFile

    Write-LogMessage "Repair process completed. Check $logFile for details."
}
catch {
    Write-LogMessage "An error occurred: $_"
}
finally {
    pause
}