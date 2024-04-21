source ../../../scripts/design_init.tcl

remove_ignored_layers -all

set_attribute [get_layers M1] routing_direction vertical
set_attribute [get_layers M2] routing_direction horizontal
set_attribute [get_layers M3] routing_direction vertical
set_attribute [get_layers M4] routing_direction horizontal
set_attribute [get_layers M5] routing_direction vertical
set_attribute [get_layers M6] routing_direction horizontal
set_attribute [get_layers M7] routing_direction vertical
set_attribute [get_layers M8] routing_direction horizontal
set_attribute [get_layers M9] routing_direction vertical
set_attribute [get_layers MRDL] routing_direction horizontal


initialize_floorplan \
  -core_utilization 0.25 \
  -flip_first_row true \
  -core_offset {11.25 11.25 11.25 11.25}
   # -boundary {{0 0} {700 700}} \
#create_tap_cells -lib_cell [get_lib_cells ] -distance 30 -pattern stagger
#PIN PLACMENT



set MIN_ROUTING_LAYER            "M1"   ;# Min routing layer
set MAX_ROUTING_LAYER            "M8"   ;# Max routing layer

set_ignored_layers \
    -min_routing_layer  $MIN_ROUTING_LAYER \
    -max_routing_layer  $MAX_ROUTING_LAYER

#set_wire_track_pattern -site_def unit -layer M1  -mode uniform -mask_constraint {mask_two mask_one} \
#-coord 0.037 -space 0.074 -direction vertical


set_block_pin_constraints -allowed_layers {M4 M5 M6} -pin_spacing  8 -self
place_pins -ports [get_ports *] -self


create_tap_cells -lib_cell [get_lib_cell saed14rvt_ss0p6vm40c/SAEDRVT14_TAPDS] -distance 40 -pattern stagger



create_net -power $NDM_POWER_NET
create_net -ground $NDM_GROUND_NET 

connect_pg_net -net $NDM_POWER_NET [get_pins -hierarchical "*/VDD*"]
connect_pg_net -net $NDM_GROUND_NET [get_pins -hierarchical "*/VSS"]

create_placement -floorplan -timing_driven
legalize_placement


### outputs 
report_qor > ../reports/qor.rpt
report_timing -delay_type max -max_paths 20 > ../reports/setupdelay.rpt
report_timing -scenarios func_slow -max_paths 20 > ../reports/setup.rpt
write_sdc  -output ../sdc/$DESIGN_TOP.sdc

save_block -as ${DESIGN_NAME}_floorplaned

