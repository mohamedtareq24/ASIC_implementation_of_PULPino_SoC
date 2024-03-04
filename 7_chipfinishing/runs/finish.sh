#!/bin/bash

# Find the latest run folder and determine the next run number
latest_run=$(find . -maxdepth 1 -type d -name "run_*" | grep -oE '[0-9]+' | sort -n | tail -n 1)
if [ -z "$latest_run" ]; then
    next_run=1
else
    next_run=$((latest_run + 1))
fi

# Create the new run folder
new_run_folder="run_$next_run"

# Create necessary subdirectories inside the new run folder
mkdir -p ./$new_run_folder/reports
mkdir -p ./$new_run_folder/sdf
mkdir -p ./$new_run_folder/sdc
mkdir -p ./$new_run_folder/netlists
mkdir -p ./$new_run_folder/log
mkdir -p ./$new_run_folder/svf
mkdir -p ./$new_run_folder/WORK

# Change working directory to the new run folder
cd $new_run_folder/WORK

# Run dc_shell with the specified script and log to the new run folder
dc_shell -f ../../../scripts/syn_script.tcl | tee ../log/syn.log

