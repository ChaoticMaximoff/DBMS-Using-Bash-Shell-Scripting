#!/bin/bash

DBsDir="./MyDataBases"

if [ -d "$DBsDir" ] && [ "$(ls -A $DBsDir)" ]; then
    AvailableDBs=$(ls "$DBsDir" | tr '\n' '\n')
    zenity --info \
        --title="Available Databases" \
        --text="Available Databases:\n$AvailableDBs" 2> /dev/null
else
    zenity --warning \
        --title="No Databases" \
        --text="No databases are available to show." 2> /dev/null
fi
