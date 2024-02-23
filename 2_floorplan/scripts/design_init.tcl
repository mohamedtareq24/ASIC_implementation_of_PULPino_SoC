####DESIGN INIT######
puts "design initialization"
set_host_options -max_cores 8
close_lib -force

set DESIGN_NAME           "riscv_core"
set DESIGN_TOP			  "riscv_core"
set DESIGN_REF_PATH 		/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/ndm
set DESIGN_REF_TECH_PATH 	/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/tfs/

set DB_PATH 	"/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/db_nldm"
set FFLIB 		"$DB_PATH/saed14rvt_ff0p88v125c.db"
set SSLIB 		"$DB_PATH/saed14rvt_ss0p6vm40c.db"


set TARGET_LIBRARY_FILES [list $SSLIB $FFLIB]
set LINK_LIBRARY_FILES [list * $SSLIB $FFLIB]  

set link_library   $LINK_LIBRARY_FILES
set target_library $TARGET_LIBRARY_FILES

## getting the latest syn run 
puts "latest synthesis run will be used for input data"

set base_path "/home/ICer/GP/PULP/cv32e40p/1_syn/runs"
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

set NDM_REFERENCE_LIB_DIRS  "/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/ndm/saed14rvt_frame_only.ndm"

#/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/ndm/saed14rvt_frame_timing_ccs.ndm \


set SYN_PATH $dir
set GATE_NET_PATH		${SYN_PATH}/netlists
set SDC_PATH			${SYN_PATH}/sdc

set TLUPLUS_MAX_FILE		/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/techfiles/saed14nm_1p9m_Cmax.tluplus
set TLUPLUS_MIN_FILE		/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/techfiles/saed14nm_1p9m_Cmin.tluplus		
set MAP_FILE				/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/techfiles/SAED14nm_PDK_12232018/starrc/saed14nm_1p9m_layer.map

set NDM_POWER_NET                "VDD" ;#
set NDM_POWER_PORT               "VDD" ;#
set NDM_GROUND_NET               "VSS" ;#
set NDM_GROUND_PORT              "VSS" ;#


lappend search_path "$DESIGN_REF_TECH_PATH $DESIGN_REF_PATH $NDM_REFERENCE_LIB_DIRS $DB_PATH"

##### library creation
puts "############################### Library creation ######################################"

set_app_var link_library $link_library
#set_app_var link_library "/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/db_nldm/saed14rvt_tt0p8v25c.db"
#create_lib  -ref_libs $NDM_REFERENCE_LIB_DIRS  -technology $TECH_FILE /home/ICer/cv32e40p_updated/work/${DESIGN}.dlib
create_lib -technology $DESIGN_REF_TECH_PATH/saed14nm_1p9m_mw.tf -ref_libs "/mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/ndm/saed14rvt_frame_only.ndm" $DESIGN_NAME


set_attribute [get_site_defs unit] is_default true
set_attribute [get_site_defs unit] symmetry Y

read_verilog  $GATE_NET_PATH/${DESIGN_NAME}.v -top $DESIGN_TOP

current_design $DESIGN_TOP
read_sdc $SDC_PATH/${DESIGN_TOP}.sdc

#### MULTI MODE MULTI CORNER
puts "#####################SOURCING MMCM#######################"
source /home/ICer/GP/PULP/cv32e40p/2_floorplan/scripts/mcmm.tcl


save_block -as ${DESIGN_NAME}_init







