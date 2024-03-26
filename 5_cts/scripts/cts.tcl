####################################################################################
###################################  CTS  ##########################################
####################################################################################

############################################################
### get the last placment run 
puts "latest placment run will be used for input data"

set base_path "/mnt/hgfs/cv32e40p/4_place/runs"
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
set_dont_touch_network -clear [get_clocks CLK_I]

set_lib_cell_purpose -include none */*_INV_S_10*

set_lib_cell_purpose -include none */*_INV_S_12*

set_lib_cell_purpose -include none */*_INV_S_14*

set_lib_cell_purpose -include none */*_INV_S_16*

set_lib_cell_purpose -include none */*_INV_S_20*

set_lib_cell_purpose -include none */*_INV_S_18*
set_lib_cell_purpose -include none */*_BUF*

set_lib_cell_purpose -exclude cts [get_lib_cells -of [get_cells *]]
#set_lib_cell_purpose -include cts */*AOBUF_IW*
#set_lib_cell_purpose -include cts */*BUF*
set_lib_cell_purpose -include cts */*_INV_S_2*
set_lib_cell_purpose -include cts */*_INV_S_3*
set_lib_cell_purpose -include cts */*_INV_S_4*
set_lib_cell_purpose -include cts */*_INV_S_6*
set_lib_cell_purpose -include cts */*_INV_S_8*

check_design -checks pre_clock_tree_stage

create_routing_rule ROUTE_RULES -multiplier_spacing 3 -multiplier_width 3
set_clock_routing_rules -rules ROUTE_RULES -min_routing_layer M3  -max_routing_layer M4
set_clock_tree_options -target_latency 0.000 -target_skew 0.000 
set cts_enable_drc_fixing_on_data true
set_app_options \-name cts.common.user_instance_name_prefix -value "CTS_"
clock_opt

# clock_opt -from final_opto               #optimization
check_pg_drc
write_verilog /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/results/${DESIGN}.cts.gate.v

set_propagated_clock [get_clocks CLK_I]


# clock_opt -from final_opto               #optimization

write_verilog ../netlists/${DESIGN_NAME}.cts.gate.v

report_qor > ../reports/${DESIGN_NAME}.clock_qor.rpt

report_clock_timing  -type skew > ../reports/${DESIGN_NAME}.clock_skew.rpt

set_propagated_clock [get_clocks CLK_I]


legalize_placement

save_block -as ${DESIGN_NAME}_ctsed
report_qor > ../reports/qor.rpt
report_utilization > ../reports/utilization.rpt


## SAEDRVT14_ISOFSDPQ_PECO_8
## SAEDRVT14_DCAP_PV1ECO_12

