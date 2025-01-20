#!/bin/bash

while true; do
    DataBaseName=$(zenity --entry \
        --title="Delete Database" \
        --text="Enter the database name:" \
        --entry-text="")

    if [ -z "$DataBaseName" ]; then
        zenity --warning \
            --title="Operation Canceled" \
            --text="No database name entered. Operation canceled."
        exit 0
    fi

    if [ -d "./MyDataBases/$DataBaseName" ]; then
        rm -r "./MyDataBases/$DataBaseName"
        zenity --info \
            --title="Database Deleted" \
            --text="Database '$DataBaseName' was deleted successfully."
        break
    else
        zenity --error \
            --title="Database Does Not Exist" \
            --text="A database named '$DataBaseName' does not exist. Please try again."
    fi
done
