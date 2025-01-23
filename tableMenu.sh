#!/bin/bash

cd ./MyDataBases/$1 2>/dev/null

while true; do
    option=$(zenity --list \
        --title="Tables Management" \
        --text="Choose an action:" \
        --column="Options" \
        "Create Table" \
        "List Tables" \
        "Drop Table" \
        "Insert into Table" \
        "Select from Table" \
        "Delete from Table" \
        "Update Table" \
        "Return to Databases Menu")

        # Check if Cancel or dialog close
        # if [ $? -ne 0 ]; then
        #     zenity --question --title="Exit Database Confirmation" --text="Are you sure you want to return to the databases menu?"
        #     # if [ $? -eq 0 ]; then
        #         cd ..
        #         . ./menue.sh
        #     else
        #         continue
        #     # fi
        # fi

        case $option in 
            "Create Table")
                . ../../createTable.sh $1
                ;;
            "List Tables")
                echo hello
                ;;
            "Drop Table")
                echo hello
                ;;
            "Insert into Table")
                echo hello
                ;;
            "Select from Table")
                echo hello
                ;;
            "Delete from Table")
                echo hello
                ;;
            "Update Table")
                echo hello
                ;;
            "Return to Databases Menu")
                echo hello
                ;;
            *)
                echo "Invalid option. Please try again."
        esac
done