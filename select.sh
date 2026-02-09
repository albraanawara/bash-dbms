#!/bin/bash

read -p "Table name: " table

meta="$table.meta"
data="$table.data"
if [ ! -f "$meta" ] || [ ! -f "$data" ]; then
    echo " Table not found."
    exit 1
fi
header=$(awk -F: '{print $1}' "$meta" | tr '\n' '|')
header="${header%|}"  
echo "$header"
if [ -s "$data" ]; then
    column -t -s "|" "$data"
else
    echo " Table is empty."
fi

