#!/bin/bash

while true
do
    echo "======= Table Menu ======="
    select choice in "Create Table" "List Tables" "Drop Table" "Insert" "Select" "Delete" "Update" "Back"
    do
        case $REPLY in
            1)
                source ../../create_table.sh
                ;;
            2)
                echo "Available Tables:"
                ls *.data 2>/dev/null | sed 's/.data//'
                ;;
            3)
                read -p "Table name to drop: " t
                if [[ -f $t.data ]]; then
                    read -p "Are you sure? (y/n): " c
                    [[ $c == "y" ]] && rm $t.data $t.meta && echo "Table dropped"
                else
                    echo "Table not found"
                fi
                ;;
            4)
                source ../../insert_into_table.sh
                ;;
            5)
                source ../../select_from_table.sh
                ;;
            6)
                source ../../delete_from_table.sh
                ;;
            7)
                source ../../update_table.sh
                ;;
            8)
                return
                ;;
            *)
                echo "Invalid choice"
                ;;
        esac
        break
    done
done

