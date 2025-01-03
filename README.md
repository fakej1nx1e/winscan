# WinScan - Windows Repair Tool

WinScan is a portable PowerShell tool designed to repair corrupt Windows files (Windows 10/11) and fix disk errors. It allows users to choose between a scan mode (check only) and a repair mode (fix issues).

## Features

- **Two Modes**: Select either system diagnostics or full repair.
- **Integrated Tools**: Sequentially runs the following commands:
  - `CHKDSK`: Scans and repairs disk errors.
  - `SFC`: Scans and repairs Windows system files.
  - `DISM`: Checks and repairs the Windows component store.
- **Logging**: All results are saved in the `WinScanLog.txt` file.

## Usage

1. **Download**: Download this repository and open `start.cmd`.
  - If flagged by antivirus software, temporarily disable it or verify the script with a service like [VirusTotal](https://www.virustotal.com).
2. **Choose a Mode**:
   - **1**: Scan only.
   - **2**: Repair issues.
3. **Review Log File**: After execution, check the `WinScanLog.txt` file for detailed results.

## Command Details

- **CHKDSK**:
  - Scan Mode: `chkdsk /scan` - Checks the disk for errors.
  - Repair Mode: `chkdsk /f /r` - Fixes detected disk errors.
- **SFC**:
  - Scan Mode: `sfc /verifyonly` - Verifies the integrity of system files without making changes.
  - Repair Mode: `sfc /scannow` - Repairs corrupted system files.
- **DISM**:
  - Scan Mode: `dism /online /cleanup-image /scanhealth`.
  - Repair Mode: `dism /online /cleanup-image /restorehealth` - Repairs the Windows component store.

## Important Notes

- Always create a **system restore point** before running repair tools.
- **Use at your own risk**: If repairs fail to resolve issues, a clean Windows installation might be your only option.

## Support

If you encounter any issues or have questions, please open an issue on the GitHub repository. Include the `WinScanLog.txt` file for faster analysis.

## License

This project is licensed under the **MIT License**.
