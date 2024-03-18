####################################################################################
###################################  ROUTING ##########################################
####################################################################################

############################################################
### get the last CTS run 
puts "latest CTS run will be used for input data"

set DESIGN_NAME riscv_core
set base_path "/mnt/hgfs/cv32e40p/5_cts/runs"
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



set DLIB_PATH $dir/WORK/${DESIGN_NAME}

sh cp -r $DLIB_PATH .

set DLIB_PATH ./${DESIGN_NAME} 
############OPEN DLIB###############
open_lib $DLIB_PATH

#####################OPEN CTSed BLOCKED#####################
open_block -edit $DESIGN_NAME:${DESIGN_NAME}_placed

link
###############################################################################
###############################################################################
##################################ROUTING BEGINS###################################

set MIN_ROUTING_LAYER            "M2"   ;# Min routing layer
set MAX_ROUTING_LAYER            "M7"   ;# Max routing layer


remove_ignored_layers -all
set_ignored_layers \
    -min_routing_layer  $MIN_ROUTING_LAYER \
    -max_routing_layer  $MAX_ROUTING_LAYER
connect_pg_net -net "VDD" [get_pins -hierarchical "*/VDD"]
connect_pg_net -net "VSS" [get_pins -hierarchical "*/VSS"]

route_auto
route_opt



save_block -as ${DESIGN_NAME}_routed
report_qor > ../reports/qor.rpt
check_lvs -max 5000 > ../reports/lvs.rpt
report_utilization > ../reports/utilization.rpt

