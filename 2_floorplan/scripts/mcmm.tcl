
set fast_corner "/home/ICer/GP/PULP/cv32e40p/2_floorplan/cons/saed14rvt_ff0p88v125c.tcl"
set slow_corner "/home/ICer/GP/PULP/cv32e40p/2_floorplan/cons/saed14rvt_ss0p6vm40c.tcl"

remove_corners -all
remove_modes -all
remove_scenarios -all

create_corner slow
create_corner fast

read_parasitic_tech \
	-tlup $TLUPLUS_MAX_FILE \
	-layermap $MAP_FILE \
	-name tlup_max

read_parasitic_tech \
	-tlup $TLUPLUS_MIN_FILE \
	-layermap $MAP_FILE \
	-name tlup_min


create_mode func
current_mode func

source /home/ICer/GP/PULP/cv32e40p/2_floorplan/cons/func_mode.tcl

create_scenario -mode func -corner fast -name func_fast
create_scenario -mode func -corner slow -name func_slow

current_scenario func_fast
source $fast_corner

current_scenario func_slow
source $slow_corner


