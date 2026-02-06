#!/bin/bash
read -p "Table name: " table
meta="$table.meta"
data="$table.data"
read -p "Number of columns: " cols
> $meta
for ((i=1;i<=cols;i++))
do
    read -p "Column name: " cname
    read -p "Datatype (int/string): " dtype
    read -p "Primary key? (y/n): " pk
    echo "$cname:$dtype:$pk" >> $meta
done
touch $data
echo "Table created successfully"

