#!/bin/bash

# - - - Error Handling Fucntion - - - #

check_command(){
	if [ $? -ne 0 ]; then
		echo "ERROR: $1 failed.  Exiting."
		exit 1
	fi
}


