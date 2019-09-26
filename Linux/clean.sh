#!/bin/bash
echo "Starting cleaning"
# Shell script for moving and compressing or deleting files.
#
#  Add this line to /etc/crontab and restart crontab service
#  0 0 * * * mipro  run-parts /path/to/this/dir/
#

# Handle file deletion/archiving
handle()
{
    # Check if delete param is set to 0/1. If 0 -> move to archice else delete.

    echo $1 "is expired"
    if [ $delete = "true" ]
    then
        echo "Delete set to true. Deleting log file " $1
        rm $1
    else
        echo "Delete set to false. Moving log file $1 to archive."
        mv $i "$archiveDir""$time"/$1
    fi
}

# Loop files
# Filter files with .log prefix
clean()
{
    for i in *.log *.LOG
    do
        echo "Handling: $i" 
        lastModified="$(stat --format "%Y" $i)"
        if [ $lastModified -le $expDate ]
        then
            handle "$(stat --format "%n" $i)"
        fi
    done
}

# Handle tar.gz file deletion/archiving
handleTarGz()
{
    # Check if delete param is set to 0/1. If 0 -> move to archice else delete.
    echo $1 "is expired"
    rm $1
}

cleanTarGz()
{
    for i in *.tar.gz
    do
        echo "Handling: $i" 
        lastModified="$(stat --format "%Y" $i)"
        if [ $lastModified -le $expDateTarGz ]
        then
            handleTarGz "$(stat --format "%n" $i)"
        fi
    done
}

###### MAIN SCRIPT ######

# Params for time and expiration date thresholds
time="$(date +%d_%m_%Y_%H_%M_%S)"
expHours=-24
expHoursTarGz=-48

delete="true"

# Directories to use:
# $archiveDir = Path where the archived files will be moved
# $currentArchiveDir = This dir is used as a temp folder for the logs when moving.
# This directory is created only when delete is set to 0.
archiveDir="/path/to/archive"
currentArchiveDir=""

if [ $delete = "false" ]
then
    #Force a creation of new directory.
    mkdir -p "$archiveDir""$time"
fi

# Get current date
currentDate="$(date +%s)"

# "Expiration" date of the files. currentdate +-expHours and format to milliseconds
expDate=$(date -d "+$expHours hours" +%s)
expDateTarGz=$(date -d "+$expHoursTarGz hours" +%s)

input="/path/to/list/file.txt"
while IFS= read -r line
do
  echo "$line"
        cd $line
	echo current dir is: 
	pwd
        clean
done < "$input"

if [ $delete = "false" ]
then    
    cd "$archiveDir"
    echo "Compressing files"
    tar -czvf "$time".tar.gz "$time"
    rm -r "$time"

    echo "Checking old compressed files"
    cleanTarGz
    echo "Old tar.gz files removed"
fi
echo "Cleaning done"
