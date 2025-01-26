#!/bin/bash

database=$1
cd ./MyDataBases/$database/ 2>/dev/null

AvailableTBs=$(ls | tr '\n' '\n')
    zenity --info \
        --title="Available Tables of $1 Database" \
        --text="Available Tables:\n$AvailableTBs" 2> /dev/null

table=$(zenity --entry \
    --title="Select Table" \
    --text="Enter the table name to view all records:")
if [[ $? -ne 0 ]]; then
    return
fi


if [[ -f $table ]]; then
    zenity --info --title="Table Found" --text="Displaying all records from '$table':"

    # Extract column headers from metadata
    headers=$(awk -F: '{ printf "%s ", $1 }' .$table-metadata)

    # Prepare the zenity column arguments
    columns=()
    for header in $headers; do
        columns+=(--column="$header")
    done

    # Read the table data and split it into fields
    data=()
    while IFS=: read -r line; do
        [[ -z "$line" ]] && continue  # Skip empty lines
        IFS=: read -r -a fields <<< "$line"
        data+=("${fields[@]}")
    done < "$table"

    # Use zenity --list to display the data
    zenity --list \
        --title="Table: $table" \
        --width=600 \
        --height=400 \
        "${columns[@]}" \
        "${data[@]}" > /dev/null
else
    zenity --error --title="Error" --text="Table '$table' does not exist."
fi