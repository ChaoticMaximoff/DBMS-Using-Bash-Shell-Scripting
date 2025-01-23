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

    # Check if Cancel or dialog close
    if [ $? -ne 0 ]; then
        zenity --question --title="Quit Confirmation" --text="Are you sure you want to quit?"
        if [ $? -eq 0 ]; then
            exit 0
        else
            continue
        fi
    fi

    case $option in
        "List All Databases")
            ./showDB.sh
            zenity --info --title="List Databases" --text="Operation completed!"
            ;;
        "Create New Database")
            ./createDB.sh
            ;;
        "Connect to Database")
            ./connectDB.sh
            zenity --info --title="Connect to Database" --text="Connected to database!"
            ;;
        "Drop Database")
            ./deleteDB.sh
            ;;
        "Quit")
            zenity --question --title="Quit Confirmation" --text="Are you sure you want to quit?"
            if [ $? -eq 0 ]; then
                exit 0
            fi
            ;;
        *)
            zenity --error --title="Invalid Selection" --text="Please select a valid option."
            ;;
    esac
done
