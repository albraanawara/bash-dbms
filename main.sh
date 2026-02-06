#!/bin/bash

DB_PATH="./databases"
mkdir -p $DB_PATH

while true
do
    echo "========== DBMS Main Menu =========="
    select choice in "Create Database" "List Databases" "Connect Database" "Drop Database" "Exit"
    do
        case $REPLY in
            1)
                read -p "Enter DB name: " db
                mkdir $DB_PATH/$db 2>/dev/null || echo "Database already exists"
                break
                ;;
            2)
                ls $DB_PATH
                break
                ;;
            3)
                read -p "Enter DB name: " db
                if [ -d "$DB_PATH/$db" ]; then
                    cd $DB_PATH/$db
                    source ../../table_menu.sh
                    cd ../../
                else
                    echo "Database not found"
                fi
                break
                ;;
            4)
                read -p "Enter DB name: " db
                rm -r $DB_PATH/$db 2>/dev/null || echo "Database not found"
                break
                ;;
            5)
                exit
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
done



