#!/bin/bash

# Check if three arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <folder-path> <backup-name> <rclone-destination>"
    exit 1
fi

# Assign arguments to variables
FOLDER_PATH="$1"
BACKUP_NAME="$2"
RCLONE_DEST="$3"

# Extract the folder name if not provided for the backup name
if [ -z "$BACKUP_NAME" ]; then
    BACKUP_NAME=$(basename "$FOLDER_PATH")
fi

# Get the current date and time (in YYYY-MM-DD_HH-MM-SS format)
DATE_TIME=$(date +%Y-%m-%d_%H-%M-%S)

# Create the zip file with the specified backup name and current date/time
ZIP_FILE="${BACKUP_NAME}_${DATE_TIME}.zip"

# Zip the folder
zip -r "$ZIP_FILE" "$FOLDER_PATH" && \
    # Upload the zip file using rclone
    rclone copy "$ZIP_FILE" "$RCLONE_DEST" && \
    # Delete the zip file after successful upload
    rm "$ZIP_FILE" && \
    echo "Upload successful and zip file deleted."

# Error handling for failed zip or rclone operations
if [ $? -ne 0 ]; then
    echo "An error occurred during the zip, rclone copy, or delete process."
    exit 2
fi