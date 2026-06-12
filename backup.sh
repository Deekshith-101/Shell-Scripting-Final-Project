#!/bin/bash

# Task 1: Check whether the number of arguments is correct
# The script expects 2 arguments: target_directory and destination_directory
if [ $# -ne 2 ]
then
  echo "Usage: backup.sh target_directory_name destination_directory_name"
  exit 1
fi

# Task 2: Check if argument 1 and argument 2 are valid directory paths
if [ ! -d $1 ] || [ ! -d $2 ]
then
  echo "Invalid directory path provided"
  exit 1
fi

# Task 3: Set two variables using the arguments provided by the user
targetDirectory=$1
destinationDirectory=$2

# Task 4: Display the names of the target and destination directories in the terminal
echo "Target directory to back up: $targetDirectory"
echo "Destination directory for backup: $destinationDirectory"

# Task 5: Define a variable holding the current timestamp (Format: YYYYMMDD)
currentTS=$(date +%Y%m%d)

# Task 6: Define a variable for the name of the destination backup file
# Example output name format: backup_20260613.tar.gz
backupFileName="backup_${currentTS}.tar.gz"

# Task 7: Define the absolute or relative path to the current working directory
origAbsPath=$(pwd)

# Task 8: Change directories to the destination directory and capture its absolute path
cd "$destinationDirectory" || exit
destAbsPath=$(pwd)

# Task 9: Change directories back to the target directory to prepare for archiving
cd "$origAbsPath" || exit
cd "$targetDirectory" || exit

# Task 10: Define a time parameter (in seconds) equivalent to 24 hours ago
# 24 hours * 60 mins * 60 secs = 86400 seconds
yesterdayTS=$(($(date +%s) - 86400))

# Task 11: Declare an array to hold the names of files updated in the last 24 hours
toBackup=()

# Task 12: Loop through all files in the target directory to check their modification time
for file in $(ls)
do
  # Check if the file's modification time is greater than (newer than) 24 hours ago
  if (( $(date -r "$file" +%s) > yesterdayTS ))
  in
    # Append the file name to the tracking array
    toBackup+=("$file")
  fi
done

# Task 13: Compress, archive, and save the filtered files to the destination directory
if [ ${#toBackup[@]} -gt 0 ]
then
  tar -czf "${destAbsPath}/${backupFileName}" "${toBackup[@]}"
  echo "Backup successfully completed for updated files."
else
  echo "No files have been updated in the last 24 hours. Backup skipped."
fi

# Exit the script gracefully
exit 0
