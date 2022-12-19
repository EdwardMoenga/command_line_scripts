#!/bin/bash
computer="/path/to/txt/computers.txt"
while IFS= read -r line
do

  echo "$line"
  
  
done < "$computer"



#!/usr/bin/env bash
echo "RAM              : `free -h | awk  '/Mem:/{print $2}'`
Bash version     : `bash --version | head -1 | awk '{print $4}'`
Java version     : `java -version 2>&1 | head -1 | awk '{print $NF}' | sed 's/\"//g'`
Operating System : `uname -s`
OS version       : `uname -v`"


https://vitux.com/get-linux-system-and-hardware-details-on-the-command-line/