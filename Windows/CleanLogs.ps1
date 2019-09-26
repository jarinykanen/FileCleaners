Write-Host "Starting log cleaning"
# Script for mocing and ziping or deleting files
# NOTE: If you have to use path with spaces on Windows you must use ` character before the space
# C:\Program` Files\...

# Params for time and expiration date threshold
$time = Get-Date -Format dd_M_yyyy_HH_mm_ss
$expDays = -1;

# Option for deleting: 0 = DON'T DELETE, 1 = DELETE
$delete = 0

# Directories to use:
# $logDir = Directories for cleaning
# $archiveDir = Path where the archived files will be moved
# $currentArchiveDir = This dir is used as a temp folder for the logs when moving.
# This directory is created only when delete is set to 0.
$logDir = "C:\path\to\files\"
$archiveDir = "C:\path\to\archive\"
$currentArchiveDir
if ($delete -eq 0) {
    #Force a creation of new directory.
    New-Item -ItemType Directory -Force -Path $archiveDir$time
    $currentArchiveDir = Join-Path $archiveDir -ChildPath $time
}

# Handle file deletion/archiving
function handle { 

    # Check if delete param is set to 0/1. If 0 -> move to archice else delete.
    Write-Host $_.FullName " is expired"
    if ($delete -eq 1) {
        Write-Host "Delete set to true. Deleting log file " Write-Host $_.FullName
        Remove-Item -Path $_.FullName
    }
    else {
        Write-Host "Delete set to false. Moving log file " Write-Host $_.FullName " to archive."
        Move-Item -Path $_.FullName -Destination $currentArchiveDir
    }

}

# Get current date
$currentDate = Get-Date

# "Expiration" date of the files. currentdate +-expDate
$expDate = $currentDate.AddDays($expDays)

# Get all child element with -Recurse keyword. This will go through all sub directories.
# Filter files with .log prefix
# Goes through all folders inside logDir
Get-ChildItem $logDir -Recurse -Filter *.log| 
# Handle each file
Foreach-Object {

    # Creation time of the current file
    $creationTime = $_.CreationTime
    
    # Check if file creatonTime is less or equal to expDate
    $expired = $creationTime -le $expDate
   
    # If true handle file
    if ($expired) {
        handle
    }
}

# If delete == 0, compress the archive directory to .zip and remove the archive dir.
if ($delete -eq 0) {
    Compress-Archive -Path $currentArchiveDir -DestinationPath $currentArchiveDir
    Remove-Item -Force -Recurse $currentArchiveDir
}
Write-Host "Cleaning done!"