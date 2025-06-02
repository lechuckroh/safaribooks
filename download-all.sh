#!/bin/bash

# Check if links.txt exists
if [ ! -f "links.txt" ]; then
    echo "Error: links.txt file not found"
    exit 1
fi

# Read links.txt line by line and execute download.sh for each line
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines
    if [ -z "$line" ]; then
        continue
    fi
    
    # Skip lines starting with # (comments)
    if [[ $line =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    echo "Processing: $line"
    ./download.sh "$line"
    
    # Check if download.sh was successful
    if [ $? -ne 0 ]; then
        echo "Error: download.sh failed for line: $line"
        echo "Continuing with next line..."
    fi
    
    # Add a small delay between downloads to avoid overwhelming the server
    sleep 2
done < "links.txt"

echo "All downloads completed!" 
