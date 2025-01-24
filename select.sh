#!/bin/bash

# Accept the database name as an argument
database=$1

if [[ -z "$database" ]]; then
    zenity --error --title="No Database Selected" --text="No database name provided. Exiting..."
    exit 1
fi

# Display the SELECT menu
zenity --info --title="Select Options" --text="SELECT (Connected to '$database')"

while true; do
    # Zenity menu for SELECT options
    option=$(zenity --list \
        --title="Select Action" \
        --text="Choose an action (Database: $database):" \
        --column="Options" \
        "All" \
        "Column" \
        "Return To Previous Menu")

    # Handle user selection
    case $option in 
        "All")
            . ../../selectAll.sh "$database"
            ;;
        "Column")
            . ../../selectByColumn.sh "$database"
            ;;
        "Return To Previous Menu")
            . ../../tableMenu.sh "$database"
            exit 0
            ;;
        "")
            zenity --info --title="Operation Cancelled" --text="The operation has been cancelled."
            . ../../tableMenu.sh "$database"
            exit 0
            ;;
        *)
            zenity --error --title="Invalid Option" --text="Invalid option. Please try again."
            ;;
    esac
done
