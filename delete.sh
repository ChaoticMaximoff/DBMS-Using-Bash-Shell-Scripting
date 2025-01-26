#!/bin/bash
database=$1

AvailableTBs=$(ls | tr '\n' '\n')
    zenity --info \
        --title="Available Tables of $1 Database" \
        --text="Available Tables:\n$AvailableTBs" 2> /dev/null

# Prompt user to enter the table name
tableName=$(zenity --entry --title="Delete from Table" --text="Enter the table name:" --width=300)

if [[ $? -ne 0 ]]; then
    return
fi

# Check if the table name was entered
if [[ -z $tableName ]]; then
    zenity --error --text="Table name cannot be empty!" --width=300
    return
fi

# Construct the absolute path for the table
tablePath="./MyDataBases/$database/$tableName"

# Check if the table exists
if [[ -f $tableName ]]; then
    # Display the success message
    zenity --info --text="Delete from $tableName" --width=300
else
    # Show error message if the table does not exist
    zenity --error --text="Table '$tableName' does not exist in the database '$database'!" --width=300
    # ./delete.sh "$database"
   return
fi

# Options for the menu
options=("By Column" "Return To Previous Menu")

# Use zenity to display a choice dialog
option=$(zenity --list \
    --title="Choose an Option" \
    --text="Please select an action:" \
    --column="Options" "${options[@]}" \
    --width=400 --height=200)

if [[ $? -ne 0 ]]; then
    return
fi

# Process the chosen option
case $option in
    "By Column")
        . ../../deleteByColumn.sh "$database" "$tableName"
        ;;
    "Return To Previous Menu")
        . ../../tableMenu.sh "$database"
        ;;
    *)
        # If the user cancels or closes the dialog
        zenity --error --text="Invalid or no option selected. Returning to Delete Menu." --width=300
        ./delete.sh "$database"
        ;;
esac
