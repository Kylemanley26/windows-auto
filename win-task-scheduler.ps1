# Define the action for the task - replace 'script.ps1' with your script path
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-File script.ps1'

# Define the trigger for the task to run daily at 3am
$trigger = New-ScheduledTaskTrigger -Daily -At 3am

# Define the settings for the task
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -RestartInterval (New-TimeSpan -Minutes 1) -RestartCount 3

# Register the scheduled task
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "DiskCleanup" -Description "Daily Disk Cleanup" -Settings $settings -User "System"
