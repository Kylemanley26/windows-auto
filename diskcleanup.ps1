# This script runs Disk Cleanup (cleanmgr.exe) with all options checked for cleaning up system files

# Define the state key and the options to select
$StateKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
$Options = @(
    "Active Setup Temp Folders",
    "Downloaded Program Files",
    "Internet Cache Files",
    "Old ChkDsk Files",
    "Previous Installations",
    "Recycle Bin",
    "Setup Log Files",
    "System error memory dump files",
    "System error minidump files",
    "Temporary Files",
    "Temporary Setup Files",
    "Temporary Sync Files",
    "Thumbnail Cache",
    "Update Cleanup",
    "Upgrade Discarded Files",
    "User file versions",
    "Windows Defender",
    "Windows ESD installation files",
    "Windows Upgrade Log Files"
)

# Set the state for each option
$Options | ForEach-Object {
    $State = Get-ItemProperty -Path "$StateKey\$_" -Name StateFlags0001 -ErrorAction SilentlyContinue
    if ($State -eq $null) {
        New-ItemProperty -Path "$StateKey\$_" -Name StateFlags0001 -Value 2 -PropertyType DWORD | Out-Null
    } else {
        Set-ItemProperty -Path "$StateKey\$_" -Name StateFlags0001 -Value 2
    }
}

# Run cleanmgr.exe with the specified state
Start-Process cleanmgr.exe -ArgumentList "/sagerun:1"
