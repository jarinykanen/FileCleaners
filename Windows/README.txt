This is a guide of how to set up a log rotation using POWERSHELL and windows task scheduler. These sciprts won't work with basic CMD tool.
NOTE: You might have to update the powershell to a newer version if using older windows.
This setup is tested with PowerShell version 5.1.17134 rev.590. PowerShell version can be checked with: $PSVersionTable.
6.1.3 version can be found from: https://github.com/PowerShell/PowerShell/releases/tag/v6.1.3

Instruction for setup:
1. Set Windows ExecutionPolicy to Unrestricted. Open PowerShell with admin rights, type: Set-ExecutionPolicy Unrestricted and accept.
2. Modify all paths from schedule.ps1 and CleanLogs.ps1 files to match the environment log paths. More accurate discriptions of paths can be found from the CleanLogs.ps1 file.
3. Modify the time and intervals that are needed for the environment. Can be found from schedule.ps1 file. Currently set to run every 2 weeks on Monday at 2pm.
3. Run schedule.ps1 file and open windows task scheduler.
4. Check that the task is setup correctly and run it for the first time. If the script won't run, check that the paths are correct and that the user is set to admin.
5. When the sciprt runs it should popup a powershell console. If the sciprt fails for some reason, add "pause" word to the end of the backup sciprt. This will hold the console open.

Instruction for testing:
You might want to test the delete and backup actions with some unused log files.
    - This can be done by setting the path from CleanLogs.ps1 to some dir with .log files.
    - Set the expiration date from CleanLogs.ps1 to -1. This means that every .log file that is older then 1 day from the current date will be effected.
    - Set the archive path.
    - Test both actions by setting the $delete variable to either 0 or 1. 
        - 0 means don't delete, move and compress to .zip.
            - Verify that only the correct logs are effected and that the compression works.
        - 1 means delete all logs that are older then the expiration threashold.
            - Verify that only the correct logs are deleted.
    - Run the script with PowerShell.