#!/bin/bash


if [[ $# -eq 2 ]]
then
    syncing_directory=$1
    storage_directory=$2
    status="Mismatched files have been added"
    if [ -f $syncing_directory ]; then $status="Files not stored in syncing directory have been deleted"; fi
    rsync -qa --recursive --progress --delete $syncing_directory $storage_directory 
    echo `date` ::$status :: $syncing_directory >> ./backup.log;
else
    echo "You have to run script with 2 arguments (syncing diryctory and storage directory)."
fi



