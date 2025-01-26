#!/bin/bash
DataBaseName=$(zenity --entry \
    --title="Create New Database" \
    --text="Enter the database name:" \
    --entry-text="")

if [[ $? -ne 0 ]]; then
    exit 1
fi

while ! [[ $DataBaseName =~ ^[a-zA-Z_][a-zA-Z0-9_\$\@#]*$ ]]; do
    zenity --error \
        --title="Invalid Name" \
        --text="The database name must start with a letter or underscore and follow MySQL naming conventions.\n\nTry again." 2> /dev/null  # Redirect stderr to /dev/null to hide the error message

    DataBaseName=$(zenity --entry \
        --title="Create New Database" \
        --text="Enter a valid database name:" \
        --entry-text="") 2> /dev/null  # Redirect stderr to /dev/null to hide the error message

    if [[ $? -ne 0 ]]; then
        exit 1
    fi
done

if [[ -d ./MyDataBases/$DataBaseName ]]; then
    zenity --error \
        --title="Database Exists" \
        --text="A database named '$DataBaseName' already exists. Please choose a different name."
    # exec ./creating_database.sh
else
    mkdir -p ./MyDataBases/"$DataBaseName"
    zenity --info \
        --title="Database Created" \
        --text="Database '$DataBaseName' was created successfully!"
fi
