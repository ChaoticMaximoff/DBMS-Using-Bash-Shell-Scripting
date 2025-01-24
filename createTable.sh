#!/bin/bash

TableName=$(zenity --entry \
    --title="Create New Table" \
    --text="Enter the name of the new table:" \
    --entry-text="")

while ! [[ $TableName =~ ^[a-zA-Z_][a-zA-Z0-9_\$\@#]*$ ]]; do
    zenity --error \
        --title="Invalid Name" \
        --text="The table name must start with a letter or underscore and follow MySQL naming conventions.\n\nTry again."
    TableName=$(zenity --entry \
        --title="Create New Table" \
        --text="Enter a valid table name:" \
        --entry-text="")
done


if [[ -e $TableName ]]; then
    zenity --error \
        --title="Table Exists" \
        --text="A database named '$TableName' already exists. Please choose a different name."

else
    colsNum=$(zenity --entry \
        --title="Specify Number of Columns" \
        --text="Enter the number of columns for the table:" \
        --entry-text="")
    
    while ! [[ $colsNum =~ ^[1-9][0-9]*$ ]]; do
        zenity --error \
            --title="Invalid Number of Columns" \
            --text="The number of columns must be a positive integer.\n\nTry again."
        colsNum=$(zenity --entry \
        --title="Specify Number of Columns" \
        --text="Enter a valid number of columns for the table:" \
        --entry-text="")
    done

    mark=0
    touch .$TableName-metadata
    for ((i=1; i<=$colsNum; i++)); do
        line=""

        # Ask for column name
        colName=$(zenity --entry \
            --title="Specify Column Name" \
            --text="Enter the name of column $i:" \
            --entry-text="")

        while ! [[ $colName =~ ^[a-zA-Z_][a-zA-Z0-9_\$\@#]*$ && $colName != "varchar" && $colName != "int" && $colName != "pk" ]]; do
            zenity --error \
                --title="Invalid Name" \
                --text="The column name must start with a letter or underscore, not a reserved keyword and follow MySQL naming conventions.\n\nTry again."
            colName=$(zenity --entry \
                --title="Specify Column Name" \
                --text="Enter a valid column name:" \
                --entry-text="")
        done

        # Check if column already exists
        while [[ $( grep -c $colName .$TableName-metadata ) -ne 0 ]]; do
            zenity --error \
                --title="Invalid Name" \
                --text="The column name already exists.\n\nTry again."

            colName=$(zenity --entry \
                --title="Specify Column Name" \
                --text="Enter a valid column name:" \
                --entry-text="")
        done

        line+=$colName:

        # Ask for column data type
        colDataType=$(zenity --list \
            --title="Specify Column Data Type" \
            --text="Choose the data type for column $colName:" \
            --column="Datatypes" \
            "int" \
            "varchar")
        
        while ! [[ $colDataType == "int" || $colDataType == "varchar" ]]; do
            zenity --error \
            --title="Invalid Data Type" \
            --text="The data type from the list must be chosen.\n\nTry again."

            colDataType=$(zenity --list \
            --title="Specify Column Data Type" \
            --text="Choose the data type for column $colName:" \
            --column="Datatypes" \
            "int" \
            "varchar")
        done

        line+=$colDataType:

        # Ask if column is primary key
        if [[ $mark -eq 0 ]]; then
            if zenity --question --text="Is column $colName a primary key?"; then
                line+=pk
                mark=1
            fi
        fi

        echo $line >> .$TableName-metadata
    done

    touch $TableName
    zenity --info \
        --title="Table Created" \
        --text="Table '$TableName' was created successfully!"


fi