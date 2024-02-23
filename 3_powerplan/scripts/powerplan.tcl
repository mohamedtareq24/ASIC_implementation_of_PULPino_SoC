####################################################################################
###################################  POWER PLAN  ###################################
####################################################################################
### get the last floorplanning run 
puts "latest floorplanning run will be used for input data"

set base_path "/home/ICer/GP/PULP/cv32e40p/2_floorplan/runs/"

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

#####################OPEN FLOORPLANNED BLOCKED#####################
open_block -edit $DESIGN_NAME:${DESIGN_NAME}_floorplan

link

############################
########  PG RINGS  ########
############################

remove_pg_via_master_rules -all
remove_pg_patterns -all
remove_pg_strategies -all
remove_pg_strategy_via_rules -all

connect_pg_net -net "VDD" [get_pins -hierarchical "*/VDD"]
connect_pg_net -net "VSS" [get_pins -hierarchical "*/VSS"]

## Define Power Ring 
####################
create_pg_ring_pattern ring1 \
	    -nets VDD \
            -horizontal_layer {M9} -vertical_layer {MRDL} \
            -horizontal_width 5 -vertical_width 5 \
            -horizontal_spacing 0.8 -vertical_spacing 0.8 \
            -via_rule {{intersection: all}}

create_pg_ring_pattern ring2 \
	    -nets VSS \
            -horizontal_layer {M7} -vertical_layer {M8} \
            -horizontal_width 5 -vertical_width 5 \
            -horizontal_spacing 0.8 -vertical_spacing 0.8 \
            -via_rule {{intersection: all}}

set_pg_strategy ring1_s -core -pattern {{name: ring1} {nets: VDD VSS}} -extension {{stop: design_boundary}}
set_pg_strategy ring2_s -core -pattern {{name: ring2} {nets: VDD VSS}} -extension {{stop: design_boundary}}

compile_pg -strategies ring1_s
compile_pg -strategies ring2_s

compile_pg -strategies ring
####Connect P/G Pins and Create Power Rails#################
create_pg_mesh_pattern P_top_two \
	-layers { \
		{ {horizontal_layer: M7} {width: 0.2} {spacing: interleaving} {pitch: 30} {offset: 0.856} {trim : true} } \
		{ {vertical_layer: M6}   {width: 0.2} {spacing: interleaving} {pitch: 30} {offset: 6.08}  {trim : true} } \
		} 

set_pg_strategy S_default_vddvss \
	-core \
	-pattern   { {name: P_top_two} {nets:{VSS VDD}} } \
	-extension { {{stop:design_boundary_and_generate_pin}} }
	
compile_pg -strategies {S_default_vddvss} 


## Create std rail
#VDD VSS
create_pg_std_cell_conn_pattern std_rail_conn1 -rail_width 0.094 -layers M1

set_pg_strategy  std_rail_1 -pattern {{name : std_rail_conn1} {nets: "VDD VSS"}} -core

compile_pg -strategies std_rail_1

check_pg_drc

save_block -as ${DESIGN_NAME}_powerplan

report_qor > ../reports/qor.rpt


