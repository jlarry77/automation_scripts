#!/bin/bash

cd /home/$USER/automation_scripts/

find . -maxdepth 1 -type d ! -name '.' ! -name '.*' -printf "%f\n" | sort -k2,2 > temp.txt 


