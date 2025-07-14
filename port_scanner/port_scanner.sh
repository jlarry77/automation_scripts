#!/bin/bash

## SCRIPT NAME:  port_scanner.sh
## DESCRIPTION: This Script scans a user-defined IP address range for a specified
##		open TCP port using namp.  It prompts the user for the starting
##		IP, the last octet of the ending IP, and the port number.
##		Results are saved to timestamped files and displayed in the terminal.

## Set Variable for Time
now=$(date +%m-%d-%Y_%H:%M:%S)

## Set Variables for FileNames
file1="MySQLScan-"
file2="MySQLScan2-"

filename1="$file1-$now"
filename2="$file2-$now"

## Prompt User for input for IP Address
echo "Enter the starting IP address:  "
read FirstIP

## Prompt User for Input for Last Octet
echo "Enter the last octet of the last IP Address:  "
read LastOctetIP

## Prompt user to input a port Number
echo "Enter the Port Number you want to scan for:  "
read port

##  Run nmap Scanning tool on IP Address through last Octet
##	-sT - TCP Scan
##  	-p port to scan
##  	/dev/null -> Discard Output
##	-oG <filename> -> Outputs results in 'grepable' format to filename1 to parse and search
nmap -sT $FirstIP-$LastOctetIP -p $port > /dev/null -oG /home/vader/MySQLScans/$filename1

##  Pipe initial output to grep to search for 'open' and write results of search to filename2
echo -e "\nOpen Ports:"
cat /home/vader/MySQLScans/$filename1 | grep open > /home/vader/MySQLScans/$filename2

## Output results of Pipe/Search above to the screen
cat /home/vader/MySQLScans/$filename2
echo -e "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "

echo -e "File one is:  $filename1 \nFile two is:  $filename2"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "

