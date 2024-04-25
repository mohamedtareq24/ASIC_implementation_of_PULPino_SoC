####################################################################################
###################################  PLACEMENT  ###################################
####################################################################################

############################################################
### get the last powerplan run 
set design riscv_core
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

#####################OPEN POWERPLANNED BLOCK#######################
open_block -edit $DESIGN_NAME:${DESIGN_NAME}_powerplanned

link
##############################################
########### 4. Placement #####################
##############################################
puts "start_place"


set syn_path  "/mnt/hgfs/cv32e40p/1_syn/runs"
set directories [glob -type d "${syn_path}/*"]

# Iterate through each directory
foreach syn_dir $directories {
    # Extract the run number from the directory name
    set run_number [file tail $syn_dir]

    # If the directory name matches the pattern "run_<number>", extract the number
    if {[regexp {run_(\d+)} $run_number - match run_number]} {
        # Check if the current run number is greater than the latest run number
        if {$run_number > $latest_run_number} {
            set latest_run_number $run_number
        }
    }
}
set SCANDEF_FILE $syn_dir/icc2/${DESIGN_NAME}.scandef



###############################Pre place checks##########################
remove_corners estimated_corner
set_scenario_status func_slow -hold false 
set_scenario_status -setup false  func_fast

check_design -checks pre_placement_stage
check_design -checks physical_constraints 
##############################Design Requiremnts ########################
remove_ideal_network -all

set_app_options -name opt.power.mode -value total

read_def $SCANDEF_FILE
set_app_options -name place.coarse.continue_on_missing_scandef -value false

set_attribute -objects [get_lib_cells */*TAP*] -name dont_touch -value true

set_placement_spacing_label -name x  -side both -lib_cells [get_lib_cells]
#set_placement_spacing_rule -labels {x x} {0 1}

report_placement_spacing_rules
##############################Qor Setup ################################### 
set_app_options -name place.legalize.optimize_pin_access_using_cell_spacing -value false

 #### Congestion
#set_app_options -name place.opt.congestion_effort -value high
#set_app_options -name place.opt.final_place.effort -value high
#########################Placement Optimization ##########################
#create_placement
place_opt -to initial_place
report_qor > initial_place.txt
#route_global -congestion_map_only true -effort_level low

place_opt

legalize_placement



connect_pg_net -net "VDD" [get_pins -hierarchical "*/VDD"]
connect_pg_net -net "VSS" [get_pins -hierarchical "*/VSS"]

check_legality -verbose > ../reports/check_legality.rpt
report_utilization > ../reportsreport_utilization_after_place.rpt
report_timing -nosplit -delay_type max > ../reports/timing_max_place.rpt
report_timing -nosplit -delay_type min > ../reports/timing_min_place.rpt
report_qor > ../reports/report_qor_place.rpt
create_qor_snapshot -name placement


puts "finish_place"

save_block -as ${design}_placed


