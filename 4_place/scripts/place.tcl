####################################################################################
###################################  PLACEMENT  ###################################
####################################################################################

############################################################
### get the last powerplan run 
puts "latest powerplanning run will be used for input data"

set base_path "/mnt/hgfs/cv32e40p/3_powerplan/runs"
set latest_run ""
set latest_run_number 0

# Get a list of directories in the base path
set directories [glob -type d "${base_path}/*"]

# Iterate through each directory
foreach dir $directories {
    # Extract the run number from the directory name
    set run_number [file tail $dir]

    # If the directory name matches the pattern "run_<number>", extract the number
    if {[regexp {run_(\d+)} $run_number - match run_number]} {
        # Check if the current run number is greater than the latest run number
        if {$run_number > $latest_run_number} {
            set latest_run_number $run_number
        }
    }
}

set DESIGN_NAME riscv_core

set DLIB_PATH $dir/WORK/${DESIGN_NAME}

sh cp -r $DLIB_PATH .

set DLIB_PATH ./${DESIGN_NAME} 
############OPEN DLIB###############
open_lib $DLIB_PATH

#####################OPEN POWERPLANNED BLOCKED#####################
open_block -edit $DESIGN_NAME:${DESIGN_NAME}_powerplanned

link
remove_corners estimated_corner
set_scenario_status -hold false func_slow
set_scenario_status -setup false  func_fast
##############################################
########### 4. Placement #####################
##############################################
puts "start_place"

set_app_options -name place.coarse.continue_on_missing_scandef -value true

set_attribute -objects [get_lib_cells */*TAP*] -name dont_touch -value true
#placement will add tie cells 
#create_placement
place_opt -to initial_drc
report_qor > initial_drc.txt
legalize_placement
connect_pg_net -net "VDD" [get_pins -hierarchical "*/VDD"]
connect_pg_net -net "VSS" [get_pins -hierarchical "*/VSS"]

check_legality -verbose > rpt/check_legality.rpt
report_utilization > rpt/report_utilization_after_place.rpt
report_timing -nosplit -delay_type max > rpt/timing_max_place.rpt
report_timing -nosplit -delay_type min > rpt/timing_min_place.rpt
report_qor > rpt/report_qor_place.rpt

puts "finish_place"

save_block -as ${design}_placed


