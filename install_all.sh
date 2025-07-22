#!/bin/bash

## Determine the Absolute Path of the directory where the current script resides, and 
##	store the results in the variable: SCRIPT_DIR

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]")" && pwd)"

echo "Searching for installable scripts in each subdirectory..."

## -- Step 1 and 2:  Loop over sorted directories --

## Start search from script\'s own directory, and use only immediate subdirectories (not the script\'s directory, looking only in directories
##	excluding hidden directories.  Print and sort base directory name and pipe into a while loop one-by-one, assigning each iteration to
## 	the 'subdir' variable

find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -printf "%f\n" | sort | while read -r subdir; do 
	full_path="$SCRIPT_DIR/$subdir"

## -- Step 3:  Look for .sh scripts in each subdirectory

	# Search for the first .sh script directly within the current subdirectory.
	script_file=$(find "$full_path" -maxdepth 1 -type f -name "*.sh" | head -n 1)

	# Check to see if script was found
	if [[ -n "$script_file" ]]; then
		#Extract just the script's filename for display
		script_name="$(basename "$script_file")"
		echo "--- "
		echo "Found script '$script_name' in '$subdir'."
		read -p "Would you like to execute this script?  [Y/n] " answer
		answer="${answer,,}"	#Convert user input to lowercase

		if [[ "$answer" == "y" || "$answer" == "" || "$answer" == "yes" ]]; then
			echo "Running $script_name..."
			bash "$script_file"
		else
			echo "Skipping $script_name."
		fi

	else
		echo "---"
		echo "No script found in '$subdir'.  Skipping..."
	fi
done

echo "---"
echo "No more scripts to install"
