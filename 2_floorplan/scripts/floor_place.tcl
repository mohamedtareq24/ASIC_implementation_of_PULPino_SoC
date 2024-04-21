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


####################################################################################
###################################  POWER PLAN  ###################################
####################################################################################

## Defining Logical POWER/GROUND Connections
############################################
connect_pg_net -net "VDD" [get_pins -hierarchical "*/VDD*"]
connect_pg_net -net "VSS" [get_pins -hierarchical "*/VSS"]

## Master VIA Rules
set_pg_via_master_rule PG_VIA_3x1 -cut_spacing 0.25 -via_array_dimension {3 1}
set_app_options -name plan.pgroute.merge_shapes_for_via_creation -value false  
## Define Power Ring 
####################
#create_pg_ring_pattern ring1 \
#     -nets {VDD VSS} \
#            -horizontal_layer {M7} \
#			-horizontal_width 5 \
#			-vertical_layer {M6} \
#            -vertical_width 5 \
#           -via_rule {{intersection: all}via_master PG_VIA4x4}



#set_pg_strategy ring1_s -core -pattern {{name: ring1} {nets: VDD VSS}} -extension {{stop: design_boundary}}
#set_pg_strategy ring2_s -core -pattern {{name: ring2} {nets: VDD VSS}} -extension {{stop: design_boundary}}

#compile_pg -strategies ring1_s
#compile_pg -strategies ring2_s

######### Create rail strategy #########################
create_pg_std_cell_conn_pattern rail_pattern -layers {M1} -rail_width {0.094 0.094}
set_pg_strategy rail_strat -pattern {{pattern: rail_pattern} {nets: VDD VSS}} -core
compile_pg -strategies rail_strat 



## Define Power Mesh 
####################
#create_pg_mesh_pattern m6_mesh -layers {{{vertical_layer: M6} {width: 1} {spacing: 4} {pitch: 10} {offset: 2}}}
#set_pg_strategy m6_s -core -extension {{direction: T B L R} {stop: core_boundary }} -pattern {{name: m6_mesh} {nets: VDD VSS}} 
#compile_pg -strategies m6_s
create_pg_mesh_pattern m7_mesh -layers {{{vertical_layer: M7} {width: 1} {spacing: 4} {pitch: 10} {offset: 2}}}
set_pg_strategy m7_s -core -extension {{direction: T B L R} {stop: core_boundary}} -pattern {{name: m7_mesh} {nets: VDD VSS}} 
compile_pg -strategies m7_s

#### CREATE PG VIAS
create_pg_vias -to_layers M7 -from_layers M1 -via_masters PG_VIA_3x1 -nets VDD
create_pg_vias -to_layers M7 -from_layers M1 -via_masters PG_VIA_3x1 -nets VSS
set_attribute -objects [get_vias -design riscv_core -filter upper_layer_name=="M2"] -name via_def -value [get_via_defs -library [current_lib] VIA12BAR1]

## Define Power Mesh 
####################


create_pg_mesh_pattern m8_mesh -layers {{{horizontal_layer: M8} {width: 5} {spacing: 20} {pitch: 50} {offset: -8}}}
set_pg_strategy m8_s -core -extension {{direction: T B L R} {stop: core_boundary }} -pattern {{name: m8_mesh} {nets: VDD VSS}} 
compile_pg -strategies m8_s

create_pg_mesh_pattern m9_mesh -layers {{{vertical_layer: M9} {width: 5} {spacing: 20} {pitch: 50} {offset: -8}}}
set_pg_strategy m9_s -core -extension {{direction: T B L R} {stop: core_boundary}} -pattern {{name: m9_mesh} {nets: VDD VSS}} 
compile_pg -strategies m9_s


connect_pg_net -net "VDD" [get_pins -hierarchical "*/VDD"]
connect_pg_net -net "VSS" [get_pins -hierarchical "*/VSS"]

check_pg_drc
check_pg_missing_vias
check_pg_connectivity -check_std_cell_pins none

check_pg_connectivity > ../reports/check_pg_connectivity.rpt
check_pg_missing_vias > ../reports/check_pg_missing_vias.rpt
check_pg_drc > ../reports/check_pg_drc.rpt

save_block -as ${DESIGN_NAME}_powerplanned




##############################################
########### 4. Placement #####################
##############################################
puts "start_place"


###############################Pre place checks##########################
remove_corners estimated_corner
set_scenario_status func_slow -hold false 
set_scenario_status -setup false  func_fast

check_design -checks pre_placement_stage
check_design -checks physical_constraints 
##############################Design Requiremnts ########################
remove_ideal_network -all

set_app_options -name opt.power.mode -value total

set_app_options -name place.coarse.continue_on_missing_scandef -value true

set_attribute -objects [get_lib_cells */*TAP*] -name dont_touch -value true

set_placement_spacing_label -name x  -side both -lib_cells [get_lib_cells]
set_placement_spacing_rule -labels {x x} {0 1}

report_placement_spacing_rules
##############################Qor Setup ################################### 
set_app_options -name place.legalize.optimize_pin_access_using_cell_spacing -value true

 #### Congestion
#set_app_options -name place.opt.congestion_effort -value high
#set_app_options -name place.opt.final_place.effort -value high
#########################Placement Optimization ##########################
#create_placement
place_opt

legalize_placement



connect_pg_net -net "VDD" [get_pins -hierarchical "*/VDD"]
connect_pg_net -net "VSS" [get_pins -hierarchical "*/VSS"]

check_legality -verbose > ../reports/check_legality.rpt
report_utilization > ../reportsreport_utilization_after_place.rpt
report_timing -nosplit -delay_type max > ../reports/timing_max_place.rpt
report_timing -nosplit -delay_type min > ../reports/timing_min_place.rpt
report_qor > ../reports/report_qor_place.rpt
create_qor_snapshot -name placement


puts "finish_place"

save_block -as ${DESIGN_NAME}_placed

check_routability -connect_standard_cells_within_pins true


