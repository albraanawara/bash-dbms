#!/bin/bash

read -p "Table name: " table

if [ -f "$table.data" ]; then
    (head -n 1 "$table.data" && tail -n +2 "$table.data") | column -t -s "|"
else
    echo "❌ Table not found"
fi
