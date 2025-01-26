#!/bin/bash

AvailableTBs=$(ls | tr '\n' '\n')
    zenity --info \
        --title="Available Tables of $1 Database" \
        --text="Available Tables:\n$AvailableTBs" 2> /dev/null

    Tb_name=$(zenity --entry --text="Please Enter Table Name")
    if [[ $? -ne 0 ]]; then
        return
    fi

    if [[ -z $Tb_name || $Tb_name =~ ^[" "]+$ ]]; then
        zenity --error --text="Table Name Can't Be Empty"
        return
    fi

    if [[ ! -e $Tb_name ]]; then
        zenity --error --text="Table '$Tb_name' Does Not Exist"
        return
    fi

    metadata_file=".$Tb_name-metadata"
    if [[ ! -e $metadata_file ]]; then
        zenity --error --text="Metadata for Table '$Tb_name' Does Not Exist"
        return
    fi

    columns=($(cut -d: -f1 $metadata_file))
    data_types=($(cut -d: -f2 $metadata_file))

    # Display the column names as a list for the user to choose from
    selected_columns=$(zenity --list --title="Select Columns" --column="Columns" --multiple "${columns[@]}")
    if [[ $? -ne 0 ]]; then
    return
    fi
    if [[ -z $selected_columns ]]; then
        zenity --error --text="No columns selected"
        return
    fi

    # Convert the selected columns into an array
    IFS='|' read -r -a selected_columns_array <<< "$selected_columns"

    # Get the indices of the selected columns
    selected_indices=()
    for column in "${selected_columns_array[@]}"; do
        for i in "${!columns[@]}"; do
            if [[ ${columns[$i]} == $column ]]; then
                selected_indices+=("$i")
                break
            fi
        done
    done

    # column name
    header=""
    for column in "${selected_columns_array[@]}"; do
        header+="$column\t"
    done
    header=${header%$'\t'}  

    # Read the table data and format it into rows
    output="$header\n"
    while IFS= read -r line; do
        IFS=':' read -r -a row <<< "$line"
        row_data=""
        for index in "${selected_indices[@]}"; do
            row_data+="${row[$index]}\t"
        done
        row_data=${row_data%$'\t'}  
        output+="$row_data\n"
    done < "$Tb_name"

    if [[ -z $output ]]; then
        zenity --error --text="No data found in the table"
    else
        # Display the data in a tabular format with column names
        zenity --info --title="Data from Table '$Tb_name'" --text="$(echo -e "$output")" --width=400 --height=200
    fi
