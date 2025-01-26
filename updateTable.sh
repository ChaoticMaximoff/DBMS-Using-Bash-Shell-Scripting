#!/bin/bash

while true; do
    # choose table to update its data
    if [ "$(ls)" ]; then
        updateTB=$(ls | zenity --list \
            --title="Available Tables of $1 Database" \
            --text="Select a table to update its data:" \
            --column="Tables")
        
        if [ -z "$updateTB" ]; then
            break

        elif [ -f $updateTB ]; then
            # choose update all column values or with a condition
            withCondition=$(zenity --list \
                --title="Select Update Method" \
                --text="Choose an update method (Database: $1):" \
                --column="Methods" \
                "Update rows with a condition" \
                "Update all rows" \
                "Return To Previous Menu")

            case $withCondition in
                "Update rows with a condition")
                    # choose condition column
                    condCol=$(awk -F: '{print $1}' .$updateTB-metadata | zenity --list \
                        --text="Select the condition column:" \
                        --column="Columns")
                    
                    condColMetadata=$(grep $condCol .$updateTB-metadata)
                    condColType=$(echo $condColMetadata | awk -F: '{print $2}')
                    condColPKCheck=$(echo $condColMetadata | awk -F: '{print $3}')

                    condFID=$(awk -F: -v column="$condCol" 'BEGIN { found=0 }
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
                        }' .$updateTB-metadata)

                    if [[ $? -ne 0 ]]; then
                        return
                    fi

                    condValue=$(zenity --entry \
                        --title="Enter Condition Value" \
                        --text="Enter the condition value for $condCol ($condColType) in $updateTB:" \
                        --entry-text="")

                    if [[ $? -ne 0 ]]; then
                        return
                    fi

                    if [[ $condValue == "" ]]; then
                        zenity --error \
                        --title="Error" \
                        --text="Condition value cannot be empty.\n(Enter "NULL" for empty values)\n\nReturning to previous menu."
                        continue
                    fi

                    #check if condition value exists in the selected table
                    eflag=0 
                    allValues=($(awk -F: '{print $'"$condFID"'}' ./$updateTB))
                    # echo ${allValues[@]}
                    for val in "${allValues[@]}"; do
                        if [[ $val == $condValue ]]; then
                            eflag=1
                            break  # Continue the outer loop
                        fi
                    done

                    if [[ $eflag -ne 1 ]]; then
                        zenity --error \
                            --title="Error" \
                            --text="Condition value not found in the selected table.\n\nReturning to previous menu."
                        continue                   
                    fi
                    #----------
                    # choose column to update
                    updateCol=$(awk -F: '{print $1}' .$updateTB-metadata | zenity --list \
                        --text="Select a column to update:" \
                        --column="Columns")
                    
                    colMetadata=$(grep $updateCol .$updateTB-metadata)
                    colType=$(echo $colMetadata | awk -F: '{print $2}')
                    colPKCheck=$(echo $colMetadata | awk -F: '{print $3}')

                    if [[ $colPKCheck = "pk" ]]; then
                        zenity --error \
                            --title="Error" \
                            --text="Primary key columns cannot be updated.\n\nReturning to previous menu."
                        continue
                    fi

                    if [[ $? -ne 0 ]]; then
                        return
                    fi

                    updateColFID=$(awk -F: -v column="$updateCol" 'BEGIN { found=0 }
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
                        }' .$updateTB-metadata)

                    newValue=$(zenity --entry \
                        --title="Enter New Value" \
                        --text="Enter the new value for $updateCol ($colType) in $updateTB:\n(Note: empty values will be written as "NULL" in the table)" \
                        --entry-text="")

                    if [[ $colType == "int" ]]; then
                        while ! [[ $newValue =~ ^-?[0-9]*$ ]]; do
                            zenity --error \
                                --title="Invalid Value" \
                                --text="The value must be an integer.\n\nTry again."
                            newValue=$(zenity --entry \
                                --title="Enter New Value" \
                                --text="Enter the new value for $updateCol ($colType) in $updateTB:\n(Note: empty values will be written as "NULL" in the table)" \
                                --entry-text="")
                        done
                    fi

                    if [[ $newValue == "" ]]; then
                        newValue="NULL"
                    fi

                    awk -v nvalue="$newValue" -v i="$updateColFID" -v cvalue="$condValue" -v ci="$condFID" -F: '
                        BEGIN{
                            OFS=FS
                        }
                        {
                            if ($ci == cvalue) {
                                $i=nvalue
                            }
                            print $0
                        }
                        ' $updateTB 1> $updateTB.tmp

                    cat $updateTB.tmp > $updateTB
                    rm $updateTB.tmp

                    zenity --info \
                    --text="The data in $updateTB has been updated successfully."

                    
                    ;;

                "Update all rows")
                    # choose column to update
                    updateCol=$(awk -F: '{print $1}' .$updateTB-metadata | zenity --list \
                        --text="Select a column to update:" \
                        --column="Columns")
                    
                    colMetadata=$(grep $updateCol .$updateTB-metadata)
                    colType=$(echo $colMetadata | awk -F: '{print $2}')
                    colPKCheck=$(echo $colMetadata | awk -F: '{print $3}')

                    if [[ $colPKCheck = "pk" ]]; then
                        zenity --error \
                            --title="Error" \
                            --text="Primary key columns cannot be updated.\n\nReturning to previous menu."
                        continue
                    fi

                    if [[ $? -ne 0 ]]; then
                        return
                    fi

                    fieldNumber=$(awk -F: -v column="$updateCol" 'BEGIN { found=0 }
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
                        }' .$updateTB-metadata)

                    newValue=$(zenity --entry \
                        --title="Enter New Value" \
                        --text="Enter the new value for $updateCol ($colType) in $updateTB:\n(Note: empty values will be written as "NULL" in the table)" \
                        --entry-text="")

                    if [[ $colType == "int" ]]; then
                        while ! [[ $newValue =~ ^-?[0-9]*$ ]]; do
                            zenity --error \
                                --title="Invalid Value" \
                                --text="The value must be an integer.\n\nTry again."
                            newValue=$(zenity --entry \
                                --title="Enter New Value" \
                                --text="Enter the new value for $updateCol ($colType) in $updateTB:\n(Note: empty values will be written as "NULL" in the table)" \
                                --entry-text="")
                        done
                    fi

                    if [[ $newValue == "" ]]; then
                        newValue="NULL"
                    fi

                    awk -v value="$newValue" -v i="$fieldNumber" -F: 'BEGIN{OFS=FS}{$i=value; print $0;}' $updateTB 1> $updateTB.tmp
                    cat $updateTB.tmp > $updateTB
                    rm $updateTB.tmp

                    zenity --info \
                    --text="The data in $updateTB has been updated successfully."

                        
                    ;;

                "Return To Previous Menu")
                    continue
                    ;;
                *)
                    continue
                    ;;
            esac

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