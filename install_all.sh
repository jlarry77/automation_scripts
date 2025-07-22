#!/bin/bash

# Determine the absolute path of the directory where the current script resides.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Searching for installable scripts in each subdirectory..."

# Find all direct, non-hidden subdirectories within SCRIPT_DIR,
# sort their names, and iterate through each one.
find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -printf "%f\n" | sort | while read -r subdir; do

    full_path="$SCRIPT_DIR/$subdir"

    # Search for the first .sh script directly within the current subdirectory.
    script_file=$(find "$full_path" -maxdepth 1 -type f -name "*.sh" | head -n 1)

    # Check if a script was found.
    if [[ -n "$script_file" ]]; then
        # Extract just the script's filename for display.
        script_name="$(basename "$script_file")"
        echo "---"
        echo "Found script '$script_name' in '$subdir'."
        read -p "Would you like to execute this script? [Y/n] " answer < /dev/tty
        answer="${answer,,}" # Convert user input to lowercase

        if [[ "$answer" == "y" || "$answer" == "" ]]; then
            echo "Running $script_name..."
            bash "$script_file"
        else
            echo "Skipping $script_name."
        fi

    else
        echo "---"
        echo "No script found in '$subdir'. Skipping..."
    fi
done

echo "---"
echo "No more scripts to install."
