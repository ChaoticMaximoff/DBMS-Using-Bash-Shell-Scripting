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

            colSize=`wc -l .$1-metadata | cut -d" " -f1`
            rowData=""

            for (( i=1; i<=$colSize; i++ )); do
                line=`sed -n "$(echo $i)p" .$1-metadata`
                colName=`echo $line | cut -d: -f1`
				colType=`echo $line | cut -d: -f2`
				colPKCheck=`echo $line | cut -d: -f3`
                colData=$(zenity --entry \
                    --title="Insert Data into $insertInTB" \
                    --text="Enter data for $colName ($colType):" \
                    --entry-text="")
                
                
            done
            
            
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