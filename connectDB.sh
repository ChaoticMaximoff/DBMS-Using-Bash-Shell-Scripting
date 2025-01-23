#!/bin/bash

if [ -d "./MyDataBases" ] && [ "$(ls -A ./MyDataBases 2>/dev/null)" ]; then
    AvailableDBs=$(ls ./MyDataBases | tr '\n' '\n')
    zenity --info \
        --title="Existing Databases" \
        --text="Available Databases:\n$AvailableDBs"
else
    zenity --warning \
        --title="No Databases" \
        --text="No existing databases found."
    ./menue.sh
fi

database=$(zenity --entry \
    --title="Connect to a Database" \
    --text="Please enter the name of the database you want to connect to:")

if [ -z "$database" ]; then
    zenity --warning \
        --title="Operation Canceled" \
        --text="No database name entered. Returning to the main menu."
    ./menue.sh

elif [[ -d ./MyDataBases/$database ]]; then
    zenity --info \
        --title="Database Connected" \
        --text="Connected to database '$database'."
    . ./tableMenu.sh $database
else
    zenity --error \
        --title="Database Not Found" \
        --text="No database with the name '$database' exists."

    answer=$(zenity --question \
        --title="Create Database" \
        --text="Do you want to create a new database named '$database'?" \
        --ok-label="Yes" \
        --cancel-label="No")

    if [ $? -eq 0 ]; then
        ./createDB.sh
    else
        zenity --warning \
            --title="Returning to Main Menu" \
            --text="Redirecting to the main menu..."
        sleep 1
        ./menue.sh
    fi
fi
