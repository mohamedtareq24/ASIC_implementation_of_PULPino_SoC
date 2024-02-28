set fast_corner "/mnt/hgfs/cv32e40p/2_floorplan/cons/saed14rvt_ff0p88v25c.tcl"
set slow_corner "/mnt/hgfs/cv32e40p/2_floorplan/cons/saed14rvt_ss0p6vm40c.tcl"

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

set_parasitic_parameters -corner slow -early_spec tlup_max -late_spec tlup_max

set_parasitic_parameters -corner fast -early_spec tlup_min -late_spec tlup_min
create_mode func

### FUNC_FAST
current_corner fast
source $fast_corner
create_scenario -mode func -corner fast -name func_fast
source /mnt/hgfs/cv32e40p/2_floorplan/cons/func_mode.tcl


### FUNC_SLOW
current_corner slow
puts "current_corner slow"
source $slow_corner


create_scenario -mode func -corner slow -name func_slow
source /mnt/hgfs/cv32e40p/2_floorplan/cons/func_mode.tcl


