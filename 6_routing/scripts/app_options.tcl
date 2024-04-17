############################################ ROUTING_APP_OPTIONS #############################################
set_app_option -name route.detail.generate_extra_off_grid_pin_tracks                    -value false

#set_app_option -name route.common.wire_on_grid_by_layer_name                           -value {{M2 false}}
#set_app_option -name route.common.via_on_grid_by_layer_name			       -value {{V2 false}}

#set_app_option -name route.common.global_min_layer_mode                                 -value allow_pin_connection

#set_app_option -name route.common.global_max_layer_mode                                 -value soft

#set_app_options -name route.common.connect_within_pins_by_layer_name                   -value {{M1 via_wire_standard_cell_pins} {M2 via_wire_standard_cell_pins}}
#set_app_option   -name route.common.connect_within_pins_by_layer_name  	        -value {{M1 via_wire_all_pins } {M2 via_wire_all_pins }}
#set_app_options -name route.common.connect_within_pins_by_layer_name  			-value {{M1 via_all_pins } {M2 via_all_pins }}
set_app_options -name route.common.connect_within_pins_by_layer_name  			-value {{M2 off} {M1 off}}

set_app_options    -block [current_block] -list {route.detail.save_after_iterations { 0 1 2 3 4 5 6 7 8 9 10} }

#set_app_options -name route.detail.var_spacing_to_same_net   				-value true  

set_app_options -name route.global.effort_level	            				-value high
