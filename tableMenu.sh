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
                . ../../listTables.sh $1
                ;;
            "Drop Table")
                . ../../dropTable.sh $1 2> /dev/null
                ;;
            "Insert into Table")
                . ../../insert.sh $1 2> /dev/null
                ;;
            "Select from Table")
                . ../../select.sh $1
                ;;
            "Delete from Table")
                . ../../delete.sh $1
                ;;
            "Update Table")
                . ../../updateTable.sh $1 2> /dev/null
                ;;
            "Return to Databases Menu")
                zenity --question --title="Return to Databases Menu" --text="Are you sure you want to return to Databases Menu?"
                if [ $? -eq 0 ]; then
                    break
                fi
                ;;
            *)
                zenity --question --title="Return to Databases Menu" --text="Are you sure you want to return to Databases Menu?"
                if [ $? -eq 0 ]; then
                    break
                fi
                ;;
        esac
done