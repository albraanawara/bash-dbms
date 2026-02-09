#!/bin/bash

read -p "Table name: " table

meta="$table.meta"
data="$table.data"

if [ ! -f "$meta" ] || [ ! -f "$data" ]; then
    echo "⚠ Table does not exist."
    exit 1
fi

line=""
cols=()
pks=()

while IFS=":" read -r cname dtype pk; do
    cols+=("$cname:$dtype:$pk")
done < "$meta"
for col in "${cols[@]}"; do
    IFS=":" read -r cname dtype pk <<< "$col"

    while true; do
        read -p "Enter $cname ($dtype): " value
if [ "$dtype" == "int" ]; then
            if ! [[ $value =~ ^[0-9]+$ ]]; then
                echo "⚠ Invalid integer. Try again."
                continue
            fi
        fi
if [ "$pk" == "y" ]; then
 index=$(echo "${cols[@]}" | tr ' ' '\n' | grep -n "^$col\$" | cut -d: -f1)
 if cut -d"|" -f"$index" "$data" | grep -qx "$value"; then
                echo "⚠ Primary key already exists. Enter a unique value."
                continue
            fi
        fi

        break
    done

    line+="$value|"
done
echo "${line%|}" >> "$data"
echo "✅ Inserted successfully!"
