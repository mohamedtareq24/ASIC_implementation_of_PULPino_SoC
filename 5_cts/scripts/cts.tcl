####################################################################################
###################################  CTS  ##########################################
####################################################################################

############################################################
### get the last placment run 
puts "latest placment run will be used for input data"

set base_path "/home/ICer/GP/PULP/cv32e40p/place/runs/"
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

#####################OPEN PLACED BLOCKED#####################
open_block -edit $DESIGN_NAME:${DESIGN_NAME}_placed

link
###############################################################################
###############################################################################
##################################CTS BEGINS###################################
create_routing_rule ROUTE_RULES_1 \
  -widths {M3 0.2 M4 0.2 } \
  -spacings {M3 0.42 M4 0.63 }

set_clock_routing_rules -rules ROUTE_RULES_1 -min_routing_layer M2 -max_routing_layer M4
set_clock_tree_options -target_latency 0.000 -target_skew 0.000 
set cts_enable_drc_fixing_on_data true

clock_opt

# clock_opt -from final_opto               #optimization

write_verilog ../netlists/${DESIGN_NAME}.cts.gate.v

report_qor > ../reports/${DESIGN_NAME}.clock_qor.rpt

report_clock_timing  -type skew > ../reports/${DESIGN_NAME}.clock_skew.rpt

set_propagated_clock [get_clocks CLK_GATED]

########### TAP CELLS INSERTION
create_tap_cells -lib_cell saed14rvt_frame_timing_ccs/SAEDRVT14_TAPDS -pattern stagger -distance 15

legalize_placement

save_block -as ${DESIGN_NAME}_cts
report_qor > ../reports/qor.rpt
report_utilization > ../reports/utilization.rpt

