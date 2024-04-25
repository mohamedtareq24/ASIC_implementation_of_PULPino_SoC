################################################################################
#
# Design name:  riscv_core
#
# Created by icc2 write_sdc on Tue Apr 23 14:08:58 2024
#
################################################################################

set sdc_version 2.1
set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA

################################################################################
#
# Units
# time_unit               : 1e-09
# resistance_unit         : 1000000
# capacitive_load_unit    : 1e-15
# voltage_unit            : 1
# current_unit            : 1e-06
# power_unit              : 1e-12
################################################################################


# Mode: func
# Corner: slow
# Scenario: func_slow

# /mnt/hgfs/cv32e40p/2_floorplan/cons/func_mode.tcl, line 1
create_clock -name CLK_I -period 5 -waveform {0 2.5} [get_ports {clk_i}]
# /mnt/hgfs/cv32e40p/2_floorplan/cons/func_mode.tcl, line 13
set_clock_groups -name g1 -asynchronous -group [get_clocks {CLK_I}]
# /mnt/hgfs/cv32e40p/2_floorplan/cons/saed14rvt_ss0p6vm40c.tcl, line 3
set_voltage 0.6 -object_list {VDD}
# /mnt/hgfs/cv32e40p/2_floorplan/cons/saed14rvt_ss0p6vm40c.tcl, line 4
set_voltage 0 -object_list {VSS}
