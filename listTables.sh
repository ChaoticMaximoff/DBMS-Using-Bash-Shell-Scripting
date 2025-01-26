#!/bin/bash

if [ "$(ls -A)" ]; then
    AvailableTBs=$(ls | tr '\n' '\n')
    zenity --info \
        --title="Available Tables of $1 Database" \
        --text="Available Tables:\n$AvailableTBs" 2> /dev/null
else
    zenity --warning \
        --title="No Tables" \
        --text="No tables are available to show." 2> /dev/null
fi
