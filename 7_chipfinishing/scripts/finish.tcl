####################################################################################
###################################  CHIP_FINISHING ################################
####################################################################################

############################################################
### get the last routing run 
puts "latest placment run will be used for input data"

set base_path "/home/ICer/GP/PULP/cv32e40p/routing/runs/"
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
##################################BEGIN CHIP FINISHING ########################
set pnr_std_fillers "SAEDRVT14_FILL*"
set std_fillers "saed14rvt_ss0p6v125c/SAEDRVT14_DCAP_PV1ECO_15 saed14rvt_tt0p8v25c/SAEDRVT14_DCAP_PV1ECO_15 saed14rvt_ff0p88v25c/SAEDRVT14_DCAP_PV1ECO_15  saed14rvt_ff0p88v25c/SAEDRVT14_DCAP_PV1ECO_12 saed14rvt_ff0p88v25c/SAEDRVT14_DCAP_PV3_3   saed14rvt_ff0p88v25c/SAEDRVT14_DCAP_PV1ECO_6"
#foreach filler $pnr_std_fillers { lappend std_fillers "*/${filler}" }
create_stdcell_filler -lib_cell $std_fillers

connect_pg_net -net $NDM_POWER_NET [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $NDM_GROUND_NET [get_pins -hierarchical "*/VSS"]

############################################################

write_verilog ../netlists/${DESIGN_NAME}.icc2.gate.v

report_qor > ../report/qor.rpt

report_utilization > ../reports/utilization.rpt
############################################################


save_block -as ${DESIGN_NAME}_finished


change_names -rules verilog -verbose
write_verilog \
	-include {pg_netlist unconnected_ports} \
	./output/${DESIGN}_pg.v

write_gds -design ${DESIGN}_4_finished \
	  -layer_map $GDS_MAP_FILE \
	  -keep_data_type \
	  -fill include \
	  -output_pin all \
	  -merge_files "$STD_CELL_GDS" \
	  -long_names \
	  ./output/${DESIGN}.gds

write_parasitics -output  {./results/core.spf}

close_block
close_lib

exit

}
