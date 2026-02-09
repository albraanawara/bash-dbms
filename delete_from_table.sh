#!/bin/bash

# Prompt for table name
read -p "Enter table name: " table

# Check if table exists
if [ ! -f "$table.data" ] || [ ! -f "$table.meta" ]; then
    echo "❌ Table not found"
    return
fi

# Read metadata
mapfile -t columns < <(cut -d':' -f1 "$table.meta")  # Column names
mapfile -t pks     < <(cut -d':' -f3 "$table.meta")  # Primary key flags

# Display table
echo "Current table data:"
(head -n 1 "$table.data" && tail -n +2 "$table.data") | column -t -s "|"

# Detect primary key column
pk_index=-1
for i in "${!pks[@]}"; do
    if [[ "${pks[i]}" == "y" ]]; then
        pk_index=$i
        break
    fi
done

if [[ $pk_index -eq -1 ]]; then
    echo "❌ No primary key defined. Cannot delete rows uniquely."
    return
fi

# Ask for primary key value to delete
read -p "Enter primary key value of the row to delete (${columns[pk_index]}): " pk_value

# Find the line number of the row
line_num=$(awk -F"|" -v val="$pk_value" -v col="$((pk_index+1))" 'NR>0 {if($col==val) print NR}' "$table.data")

if [[ -z "$line_num" ]]; then
    echo "❌ Row not found"
    return
fi

# Confirm deletion
read -p "Are you sure you want to delete this row? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "Deletion canceled."
    return
fi

# Delete the row
sed -i "${line_num}d" "$table.data"

echo "✅ Row deleted successfully!"

