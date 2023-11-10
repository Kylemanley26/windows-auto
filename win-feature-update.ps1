#big update
#installs feature updates provided smol update has already been ran

$osversion = Get-CimInstance -ClassName Win32_OperatingSystem
$osbuild = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name DisplayVersion).DisplayVersion

$proceed = $false

if ($osversion.Caption -like "*Microsoft Windows 10*") {
    Write-Output "Windows 10 detected"
    if ($osbuild -in "21H2", "2004", "22H1", "20H2", "21H1") {
        Write-Output "Build of Windows is compatible"
        $proceed = $true
    } else {
        Write-Output "Build of Windows is not compatible"
    }
} else {
    Write-Output "Windows 10 not detected"
}

if ($proceed -eq $true) {
    Write-Output "Downloading the update file"
    $folderPresent = Test-Path -Path "C:\tempsyncro"
    if (-not $folderPresent) {
        Write-Output "Folder C:\tempsyncro didn't exist, creating it"
        New-Item -Path "C:\tempsyncro" -ItemType Directory | Out-Null
    }

    if ([Environment]::Is64BitOperatingSystem) {
        Write-Output "64-bit Windows detected"
        $url = ""
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile("http://b1.download.windowsupdate.com/c/upgr/2022/07/windows10.0-kb5015684-x64_d2721bd1ef215f013063c416233e2343b93ab8c1.cab","C:\tempsyncro\windows10.0-kb5015684-x64_d2721bd1ef215f013063c416233e2343b93ab8c1.cab")
        $updaterunArguments = '/Online /Add-Package /PackagePath:"C:\tempsyncro\windows10.0-kb5015684-x64_d2721bd1ef215f013063c416233e2343b93ab8c1.cab" /quiet /norestart'
    }
    else {
        Write-Output "32-bit Windows detected"
        $url = ""
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile("http://b1.download.windowsupdate.com/c/upgr/2022/07/windows10.0-kb5015684-x86_3734a3f6f4143b645788cc77154f6288c8054dd5.cab","C:\tempsyncro\windows10.0-kb5015684-x86_3734a3f6f4143b645788cc77154f6288c8054dd5.cab")
        $updaterunArguments = '/Online /Add-Package /PackagePath:"C:\tempsyncro\windows10.0-kb5015684-x86_3734a3f6f4143b645788cc77154f6288c8054dd5.cab" /quiet /norestart'
    }
    
    $updaterunProcessCfg = New-Object System.Diagnostics.ProcessStartInfo
    $updaterunProcessCfg.FileName = 'C:\Windows\system32\dism.exe'
    $updaterunProcessCfg.RedirectStandardError = $true
    $updaterunProcessCfg.RedirectStandardOutput = $true
    $updaterunProcessCfg.UseShellExecute = $false
    $updaterunProcessCfg.Arguments = $updaterunArguments
    $updaterunProcess = New-Object System.Diagnostics.Process
    $updaterunProcess.StartInfo = $updaterunProcessCfg
    $updaterunProcess.Start() | Out-Null
    $updaterunProcess.WaitForExit()
    $updaterunProcessOutput = $updaterunProcess.StandardOutput.ReadToEnd()
    $updaterunProcessErrors = $updaterunProcess.StandardError.ReadToEnd()
    $updaterunProcessExitCode = $updaterunProcess.ExitCode

    Write-Output "Execution Output: $updaterunProcessOutput"
    Write-Output "Execution Errors: $updaterunProcessErrors"
    Write-Output "Execution Exit Code: $updaterunProcessExitCode"
    if ($updaterunProcessExitCode -eq 3010) {
        Write-Output "Exit code 3010 detected, triggering a system reboot"
        Restart-Computer -Force
    }
}