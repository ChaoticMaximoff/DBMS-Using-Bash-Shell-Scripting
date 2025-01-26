#!/bin/bash

# Navigate to the database directory
listTable 2> /dev/null
cd ./MyDataBases/$database/ 2> /dev/null

# Ask for the table name
table=$(zenity --entry --title="Delete from Table" --text="Please enter the table name:")

if [[ -f $table ]]; then
    # Display table header using metadata
    headers=$(awk -F: '{ printf "%-15s", $1 }' .$table-metadata)
    zenity --info --title="Table Header" --text="$headers"

    # Ask for the column name
    field=$(zenity --entry --title="Delete from Table" --text="Enter Column name:")
    if [[ $? -ne 0 ]]; then
        return
    fi

    # Get the field number from metadata
    fieldNumber=$(awk -F: -v column="$field" 'BEGIN { found=0 }
    {
        if ($1 == column) {
            found=1
            print NR
            exit
        }
    }
    END {
        if (found == 0) {
            exit 1
        }
    }' .$table-metadata)

    # echo $fieldNumber 

    if [[ $? -ne 0 ]]; then
        zenity --error --title="Error" --text="Column '$field' not found."
        return
    fi

    # Ask for the value to delete
    value=$(zenity --entry --title="Delete from Table" --text="Enter value for column '$field':")
    if [[ $? -ne 0 ]]; then
        return
    fi

    # Check if the value exists in the specified column
    result=$(awk -F: -v fieldNum="$fieldNumber" -v val="$value" '
    {
        if (tolower($fieldNum) == tolower(val)) {
            print NR
        }
    }' $table)

    if [[ -z "$result" ]]; then
        zenity --error --title="Error" --text="Value '$value' not found in column '$field'."
        return
    else
        # # Iterate over the matching row numbers and delete them
        # for rowNum in $result; do
        #     sed -i "${rowNum}d" $table
        # done

        awk -v value="$value" -v i="$fieldNumber" -F: '
            BEGIN{
                OFS=FS
            }
            {
                if ($i != value) {
                    print $0
                }
            }
            ' $table 1> $table.tmp

        cat $table.tmp > $table
        rm -f $table.tmp

        # Notify the user of success
        zenity --info --title="Success" --text="Row(s) with '$value' in column '$field' deleted successfully."
        return
    fi
else
    # Notify the user if the table doesn't exist
    zenity --error --title="Error" --text="Table '$table' does not exist."
    return
fi
