#!/bin/bash

while true; do

    if [ "$(ls)" ]; then
        insertInTB=$(ls | zenity --list \
            --title="Available Tables of $1 Database" \
            --text="Available Databases:" \
            --column="Tables")

        if [ -z "$insertInTB" ]; then
            break
        
        # if selected item is a table, insert data into it
        elif [ -f $insertInTB ]; then
            zenity --info \
                --title="Table Selected" \
                --text="The selected table is: $insertInTB"

            colSize=`wc -l .$insertInTB-metadata | cut -d" " -f1`
            rowData=""

            for (( i=1; i<=$colSize; i++ )); do
                line=`sed -n "$(echo $i)p" .$insertInTB-metadata`
                colName=`echo $line | cut -d: -f1`
				colType=`echo $line | cut -d: -f2`
				colPKCheck=`echo $line | cut -d: -f3`
                colData=$(zenity --entry \
                    --title="Insert Data into $insertInTB" \
                    --text="Enter data for $colName ($colType):\n(Note: empty values will be written as "NULL" in the table)" \
                    --entry-text="")
                
                if [[ $colType == "int" ]]; then
                    while ! [[ $colData =~ ^-?[0-9]*$ ]]; do
                        zenity --error \
                            --title="Invalid Value" \
                            --text="The value must be an integer.\n\nTry again."
                        colData=$(zenity --entry \
                            --title="Insert Data into $insertInTB" \
                            --text="Enter data for $colName ($colType):\n(Note: empty values will be written as "NULL" in the table)" \
                            --entry-text="")
                    done


                fi

                if [[ $colPKCheck = "pk" ]]; then

                    if [[ $colData == "" ]]; then
                        zenity --error \
                            --title="Empty Value" \
                            --text="The primary key column cannot be empty.\n\nPlease enter a value."
                            return  # Continue the outer loop
                    fi

                    allValues=($(awk -F: '{print $'"$i"'}' ./$insertInTB))
                    for val in "${allValues[@]}"; do
                        if [[ $val == $colData ]]; then
                            zenity --error \
                                --title="Duplicate Value" \
                                --text="The value $colData already exists in the table.\n\nPlease enter a unique value."
                            return  # Continue the outer loop
                        fi
                    done
                fi

                if [[ $colData == "" ]]; then
                    colData="NULL"
                fi

                rowData+=$colData:

            done
            echo $rowData >> $insertInTB
            
            
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