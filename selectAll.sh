#!/bin/bash

database=$1
cd ./MyDataBases/$database/ 2>/dev/null

table=$(zenity --entry \
    --title="Select Table" \
    --text="Enter the table name to view all records:")

if [[ -f $table ]]; then
    zenity --info --title="Table Found" --text="Displaying all records from '$table':"
    
    # Process and format the metadata as a table
    table_content=$(cut -d: -f1 .$table-metadata)

    # Display the formatted table using zenity
    zenity --text-info \
        --title="Table: $table" \
        --width=600 \
        --height=400 \
        --filename=<(echo "$table_content")
else
    zenity --error --title="Error" --text="Table '$table' does not exist."
fi
