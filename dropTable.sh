#!/bin/bash


while true; do

    if [ "$(ls)" ]; then
        deletedTB=$(ls | zenity --list \
            --title="Available Tables of $1 Database" \
            --text="Select a table to drop:" \
            --column="Tables") 2> /dev/null
        if [ -z "$deletedTB" ]; then
            break
        
        elif [ -f $deletedTB ]; then
            rm -f $deletedTB
            rm -f .$deletedTB-metadata
            zenity --info \
                --title="Table Deleted" \
                --text="The table "$deletedTB" has been deleted successfully."
                break
        else
            zenity --error \
                --title="This is not a table" \
                --text="The selected item is not a table."
                break
        fi

    else
        zenity --warning \
            --title="No Tables" \
            --text="No tables are available to show."
        break
    fi
done