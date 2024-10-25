# winscan - Windows Repair Tool

WinScan is a powershell file portable tool designed to repair corrupt Windows OS (10/11) files and fix disk errors. It achieves this by executing the following commands in the specified order:

1. `SFC /ScanNow`: Scans and repairs Windows system files.
2. `CHKDSK`: Scan local drives (C: drive) for bad sectors (use the `/R` parameter for HDD drives).
3. `DISM`: Deployment Image Servicing and Management (DISM) is a command-line tool used to service and prepare Windows images. It can be used to repair system files and prepare Windows installation media.

## Features

- Automated repair process: Execute all repair commands with a single command.
- Sequential execution: Ensures that the commands run in the correct order.

## Usage

1. Open `start.cmd`
2. Follow the prompts and wait until the repair process is completed
- If you encounter any problems, please copy the entire WinScanLog.txt file to 'issues'.


## Support

If you encounter any issues or have questions, feel free to open an issue on the GitHub repository.

## License

This project is licensed under the MIT License.

---

**Note**: Always create a system restore point before running any repair tools. Use this tool at your own risk and use ONLY the release tool. **AND** if this tool doesnt work, than the only option for you, is to reset your Windows.
