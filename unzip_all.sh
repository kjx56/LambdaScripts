#!/bin/bash

# Directory containing zip files (defaults to current directory)
SOURCE_DIR=${1:-.}

# Iterate through all .zip files in the directory
for zip_file in "$SOURCE_DIR"/*.zip; do
    # Check if there are no zip files
    if [ ! -e "$zip_file" ]; then
        echo "No zip files found in $SOURCE_DIR"
        exit 1
    fi

    # Get the base name of the zip file (without path and extension)
    base_name=$(basename "$zip_file" .zip)

    # Create a directory named after the zip file
    target_dir="$SOURCE_DIR/$base_name"
    mkdir -p "$target_dir"

    # Extract the zip file into the created directory
    unzip -q "$zip_file" -d "$target_dir"

    # Check if the unzip command succeeded
    if [ $? -eq 0 ]; then
        echo "Extracted $zip_file to $target_dir"
    else
        echo "Failed to extract $zip_file"
    fi
done
