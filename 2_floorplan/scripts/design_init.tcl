####DESIGN INIT######
set_host_options -max_cores 1

set DESIGN_NAME           "riscv_core"
set DESIGN_TOP			  "riscv_core"
set DESIGN_REF_PATH 		/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/ndm
set DESIGN_REF_TECH_PATH 	/mnt/hgfs/ASIC_shared/LIBs/tech

set DB_PATH 	"/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/db_nldm"
set FFLIB 		"$DB_PATH/saed14rvt_ff0p88v25c.db"
set SSLIB 		"$DB_PATH/saed14rvt_ss0p6vm40c.db"

## getting the latest syn run 
puts "latest synthesis run will be used for input data"

set base_path "/mnt/hgfs/cv32e40p/1_syn/runs"
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

#/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/ndm/saed14rvt_frame_timing_ccs.ndm \


set SYN_PATH            $dir
set GATE_NET_PATH       ${SYN_PATH}/netlists
set SDC_PATH            ${SYN_PATH}/sdc

set TECH_FILE                     "${DESIGN_REF_TECH_PATH}/milkyway/saed14nm_1p9m_mw.tf"  ;#  Milkyway technology file
set MAP_FILE                      "${DESIGN_REF_TECH_PATH}/star_rc/saed14nm_tf_itf_tluplus.map"  ;#  Mapping file for TLUplus
set TLUPLUS_MAX_FILE              "${DESIGN_REF_TECH_PATH}/star_rc/max/saed14nm_1p9m_Cmax.tluplus"  ;#  Max TLUplus file
set TLUPLUS_MIN_FILE              "${DESIGN_REF_TECH_PATH}/star_rc/min/saed14nm_1p9m_Cmin.tluplus"  ;#  Min TLUplus file

set NDM_POWER_NET                "VDD" ;#
set NDM_POWER_PORT               "VDD" ;#
set NDM_GROUND_NET               "VSS" ;#
set NDM_GROUND_PORT              "VSS" ;#


set_app_var search_path  "${DESIGN_REF_PATH}/tech/milkyway/ $DESIGN_REF_PATH $DB_PATH $GATE_NET_PATH"
#set_app_var link_library "$FFLIB $SSLIB"

##### library creation
puts "############################### Library creation ######################################"

create_lib  $DESIGN_NAME \
-ref_libs {/mnt/hgfs/cv32e40p/CLIBs/saed14rvt_c.ndm /mnt/hgfs/cv32e40p/CLIBs/saed14rvt_c_physical_only.ndm} \
-technology $TECH_FILE



set_attribute [get_site_defs unit] is_default true
set_attribute [get_site_defs unit] symmetry Y

read_verilog  $GATE_NET_PATH/${DESIGN_NAME}.v -top $DESIGN_TOP

current_design $DESIGN_TOP
#read_sdc $SDC_PATH/${DESIGN_TOP}.sdc

#### MULTI MODE MULTI CORNER
puts "#####################MMMC#######################\
	  #####################MMMC########################\
	  #####################MMMC########################"
source ../../../scripts/mcmm.tcl

source /mnt/hgfs/cv32e40p/1_syn/scripts/dont_use_cells.tcl

report_corners
save_block -as ${DESIGN_NAME}_init







