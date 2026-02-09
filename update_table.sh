#!/bin/bash

# Prompt for table name
read -p "Enter table name: " table

# Check if table exists
if [ ! -f "$table.data" ] || [ ! -f "$table.meta" ]; then
    echo "❌ Table not found"
    return
fi

# Read metadata
mapfile -t columns < <(cut -d':' -f1 "$table.meta")      # Column names
mapfile -t types   < <(cut -d':' -f2 "$table.meta")      # Data types
mapfile -t pks     < <(cut -d':' -f3 "$table.meta")      # Primary key flags

# Display table
echo "Current table data:"
(head -n 1 "$table.data" && tail -n +2 "$table.data") | column -t -s "|"

# Ask for row to update (by primary key)
pk_index=-1
for i in "${!pks[@]}"; do
    if [[ "${pks[i]}" == "y" ]]; then
        pk_index=$i
        break
    fi
done

if [[ $pk_index -eq -1 ]]; then
    echo "❌ No primary key defined. Cannot identify rows uniquely."
    return
fi

read -p "Enter primary key value of the row to update (${columns[pk_index]}): " pk_value

# Find the line number of the row
line_num=$(awk -F"|" -v val="$pk_value" -v col="$((pk_index+1))" 'NR>0 {if($col==val) print NR}' "$table.data")

if [[ -z "$line_num" ]]; then
    echo "❌ Row not found"
    return
fi

# Read current row values
current_row=$(sed -n "${line_num}p" "$table.data")
IFS='|' read -r -a row_values <<< "$current_row"

# Loop through columns to update
for i in "${!columns[@]}"; do
    col="${columns[i]}"
    type="${types[i]}"
    pk="${pks[i]}"
    old_val="${row_values[i]}"

    # Skip PK update
    if [[ "$pk" == "y" ]]; then
        echo "$col (Primary Key) = $old_val"
        continue
    fi

    while true; do
        read -p "Enter new value for '$col' ($type) [current: $old_val, Enter to keep]: " new_val
        # Keep old value if empty
        [[ -z "$new_val" ]] && new_val="$old_val"

        # Validate type
        if [[ "$type" == "int" ]] && ! [[ "$new_val" =~ ^-?[0-9]+$ ]]; then
            echo "⚠️ Invalid integer. Try again."
            continue
        fi

        row_values[i]="$new_val"
        break
    done
done

# Join row values and replace the line in the file
new_row=$(IFS='|'; echo "${row_values[*]}")
sed -i "${line_num}s/.*/$new_row/" "$table.data"

echo "✅ Row updated successfully!"
