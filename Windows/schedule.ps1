#Interval, day of the week, time
$trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 2 -DaysOfWeek Monday -At 2pm
#Action: Open powershell and execute script.
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-ExecutionPolicy Bypass C:\path\to\CleanLogs.ps1'
#StartWhenAbailable mean that the script will run even after the trigger time. This can happen if the computer has been powered off when the trigger occurred. 
$settings =  New-ScheduledTaskSettingsSet -StartWhenAvailable
Register-ScheduledTask LogCleaning -Action $action -Trigger $trigger -Settings $settings