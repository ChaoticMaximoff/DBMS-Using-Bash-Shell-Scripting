#!/bin/bash

while true; do
    AvailableDBs=$(ls ./MyDataBases | tr '\n' '\n')
    zenity --info \
        --title="Existing Databases" \
        --text="Available Databases:\n\n$AvailableDBs"

    DataBaseName=$(zenity --entry \
        --title="Delete Database" \
        --text="Enter the database name:" \
        --entry-text="")

    # Check if Cancel was pressed
    if [ $? -ne 0 ]; then
        # User pressed Cancel, return to menu
        break
        # ./menue.sh
        # exit
    fi

    if [ -z "$DataBaseName" ]; then
        zenity --warning \
            --title="Operation Canceled" \
            --text="No database name entered. Please enter a valid database name."
        continue
    fi

    if [ -d "./MyDataBases/$DataBaseName" ]; then
        rm -r "./MyDataBases/$DataBaseName" 2> /dev/null
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
