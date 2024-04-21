####################################################################################
###################################  CTS  ##########################################
####################################################################################

############################################################
### get the last placment run 
puts "latest placment run will be used for input data"

set base_path "/mnt/hgfs/cv32e40p/4_place/runs"
set latest_run ""
set latest_run_number 0
set DESIGN riscv_core
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
#remove_tracks -all 

#create_track -layer M1 -coord 0.037 -space 0.074
#create_track -layer M2 -coord 0.037 -space 0.074
#create_track -layer M3 -coord 0.037 -space 0.074
#create_track -layer M4 -coord 0.037 -space 0.074
#create_track -layer M5 -coord 0.037 -space 0.148
#create_track -layer M6 -coord 0.037 -space 0.148
#create_track -layer M7 -coord 0.037 -space 0.148
#create_track -layer M8 -coord 0.037 -space 0.148
#create_track -layer M9 -coord 0.037 -space 0.148

set_dont_touch_network -clear [get_clocks CLK_I]

set_dont_use [get_lib_cells */*_INV_S_10*]

set_dont_use [get_lib_cells */*_INV_S_12*]

set_dont_use [get_lib_cells */*_INV_S_16*]

set_dont_use [get_lib_cells */*_INV_S_20*]

set_dont_use [get_lib_cells */*_BUF*]
############################################################
create_routing_rule CTS_routing_rule -widths {M3 0.3 M4 0.25} -spacings {M3 0.42 M4 0.63}

#########################  include buffers to cts  ########################
set_lib_cell_purpose -exclude cts [get_lib_cells]
set_lib_cell_purpose -include cts */*_INV_S_2*
set_lib_cell_purpose -include cts */*_INV_S_3*
set_lib_cell_purpose -include cts */*_INV_S_4*
set_lib_cell_purpose -include cts */*_INV_S_6*
set_lib_cell_purpose -include cts */*_INV_S_8*
check_design -checks pre_clock_tree_stage

set_lib_cell_purpose -exclude cts */*_INV_S_20*

#set_placement_spacing_label -name x  -side both -lib_cells [get_lib_cells */*_INV_S_*]
#set_placement_spacing_label -name x  -side both -lib_cells [get_lib_cells */*_FDPRB*]
#set_placement_spacing_label -name x  -side both -lib_cells [get_lib_cells */*_FP*]
#set_placement_spacing_rule  -labels {x x} {0 20}

## APP OPTIONS
#source ../../../scripts/app_options.tcl
#set_app_options -name route.common.connect_within_pins_by_layer_name  -value {{M1 off} {M2 off}}

remove_ignored_layers -all
set_ignored_layers -min_routing_layer  M1 -max_routing_layer  M6
set_clock_routing_rules -default_rule -min_routing_layer M1  -max_routing_layer M6
set_clock_tree_options -target_latency 0.00 -target_skew 0.00 
set cts_enable_drc_fixing_on_data true

clock_opt
legalize_placement

write_verilog ../netlists/${DESIGN_NAME}.cts.gate.v
report_clock_timing  -type skew > ../reports/${DESIGN_NAME}.clock_skew.rpt

set_propagated_clock [get_clocks CLK_I]

save_block -as ${DESIGN_NAME}_ctsed
report_qor > ../reports/qor.rpt
report_clock_qor -type area > ../reports/clock_area.rpt
report_utilization > ../reports/utilization.rpt

