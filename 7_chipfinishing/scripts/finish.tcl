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
remove_placement_spacing_rules -all
connect_pg_net -automatic

set pnr_std_fillers "SAEDRVT14_FILL*"
set GDS_MAP_FILE          	  "/mnt/hgfs/ASIC_shared/LIBs/tech/milkyway/saed14nm_1p9m_gdsout_mw.map"
set STD_CELL_GDS		  "/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/gds/saed14rvt.gds"
set std_fillers ""
foreach filler $pnr_std_fillers { lappend std_fillers "*/${filler}" }
create_stdcell_filler -lib_cell $std_fillers

connect_pg_net -automatic
remove_stdcell_fillers_with_violation

############################################################
write_verilog ../netlists/riscv_core.icc2.gate.v

report_qor > ../reports/qor.rpt

report_utilization > ../reports/utilization.rpt
############################################################
save_block -as ${DESIGN_NAME}_finished_all_clean


change_names -rules verilog -verbose
write_verilog \
	-include {pg_netlist unconnected_ports} \
	../output/${DESIGN}_finish.v

write_gds  -layer_map $GDS_MAP_FILE \
	  -keep_data_type \
	  -fill include \
	  -output_pin all \
	  -lib_cell_view frame \
	  -long_names \
	  ../output/${DESIGN_NAME}.gds

write_parasitics -output  {./results/core.spf}

close_block
close_lib

exit

}
