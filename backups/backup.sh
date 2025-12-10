#!/bin/bash

# Restic backup script - Povilas Infrastructure Lab
export RESTIC_REPOSITORY="/repo"
export RESTIC_PASSWORD="labas123"

LOGFILE="/var/log/restic-backup.log"

echo "===== Backup started at $(date) =====" | tee -a $LOGFILE

# Initialize repo if missing
if [ ! -d "$RESTIC_REPOSITORY" ]; then
    mkdir -p $RESTIC_REPOSITORY
    restic init >> $LOGFILE 2>&1
fi

# Run backup
restic backup /etc /var/www /home >> $LOGFILE 2>&1

# Apply retention
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune >> $LOGFILE 2>&1

echo "===== Backup finished at $(date) =====" | tee -a $LOGFILE

