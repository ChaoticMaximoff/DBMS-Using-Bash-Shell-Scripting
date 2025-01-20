#!/bin/bash

while true; do
    option=$(zenity --list \
        --title="Database Management" \
        --text="Choose an action:" \
        --column="Options" \
        "List All Databases" \
        "Create New Database" \
        "Connect to Database" \
        "Drop Database" \
        "Quit")

    case $option in
        "List All Databases")
            ./showDB.sh
            zenity --info --title="List Databases" --text="Operation completed!"
            ;;
        "Create New Database")
            ./createDB.sh
            zenity --info --title="Create Database" --text="New database created successfully!"
            ;;
        "Connect to Database")
            ./connectDB.sh
            zenity --info --title="Connect to Database" --text="Connected to database!"
            ;;
        "Drop Database")
            ./deleteDB.sh
            zenity --info --title="Delete Database" --text="Database deleted successfully!"
            ;;
        "Quit")
            zenity --question --title="Quit" --text="Are you sure you want to quit?"
            if [ $? -eq 0 ]; then
                exit
            fi
            ;;
        *)
            zenity --error --title="Invalid Selection" --text="Please select a valid option."
            ;;
    esac
done
