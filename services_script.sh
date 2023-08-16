#!/bin/bash

# Ensure a parameter is provided for avahi-browse
if [ $# -eq 0 ]; then
    echo "Usage: $0 <service>"
    exit 1
fi

# Capture the output of avahi-browse with grep and save to file.txt
avahi-browse -vrtp "$1" | grep -o '".*"' > file.txt


# Read the content of a file and replace spaces with newlines
file_content=$(<file.txt)
new_content=$(echo "$file_content" | tr ' ' '\n')

# Save the modified content to a new file
echo "$new_content" > file.txt

echo "File 'newfile.txt' created."

# Read the content of the file into an array
mapfile -t lines < file.txt

# Convert the array content into a JSON-formatted object
json_string="["
for line in "${lines[@]}"; do
    # Remove double quotes and split key and value using '=' as delimiter
    IFS='=' read -r key value <<< "$(echo "$line" | sed 's/"//g')"
    json_string+="\"$key\":\"$value\", "
done
json_string="${json_string%, }"
json_string+="]"

# Save the JSON string to a file
echo "$json_string" > output.json

echo "JSON file 'output.json' created."

echo "$(cat output.json)"

