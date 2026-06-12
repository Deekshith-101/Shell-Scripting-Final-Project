#!/bin/bash

# Criteria #1: Set targetDirectory and destinationDirectory variables to $1 and $2
targetDirectory=$1
destinationDirectory=$2

# Criteria #2: Print the targetDirectory and destinationDirectory variables using echo
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

# Criteria #3: Set currentTS to the current timestamp in seconds
currentTS=$(date '+%s')

# Criteria #4: Set backupFileName to "backup-${currentTS}.tar.gz"
backupFileName="backup-${currentTS}.tar.gz"

# Criteria #5: Define origAbsPath as the current working directory
origAbsPath=$(pwd)

# Criteria #6: Change to destinationDirectory and assign the path to destAbsPath
cd "$destinationDirectory" || exit
destAbsPath=$(pwd)

# Criteria #7: Change working directory back to origAbsPath, then to targetDirectory
cd "$origAbsPath" || exit
cd "$targetDirectory" || exit

# Criteria #8: Set yesterdayTS to the timestamp of 24 hours ago using arithmetic expression
yesterdayTS=$(($currentTS - 24 * 60 * 60))

# Initialize an array to hold files to backup
toBackup=()

# Criteria #9: Use the wildcard * inside a for loop to iterate through all files/directories
for file in *; do

  # Criteria #10: Check if the file was updated within the past day
  # (date -r fetches the last modification time of the file in seconds)
  if [ $(date -r "$file" +%s) -gt $yesterdayTS ]; then
    
    # Criteria #11: Add the file name to the toBackup array
    toBackup+=("$file")
    
  fi
done

# Criteria #12: Create an archived and compressed backup file using tar -czvf
# We only create the tar if there are actually files to back up
if [ ${#toBackup[@]} -gt 0 ]; then
  tar -czvf "$backupFileName" "${toBackup[@]}"
  
  # Criteria #13: Move the backup file to the destination directory using variables
  mv "$backupFileName" "$destAbsPath/"
else
  echo "No files modified in the last 24 hours to backup."
fi
