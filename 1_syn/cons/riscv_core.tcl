
####################################################################################
# Constraints
# ----------------------------------------------------------------------------
#
# 0. Design Compiler variables
#
# 1. Master Clock Definitions
#
# 2. Generated Clock Definitions
#
# 3. Clock Uncertainties
#
# 4. Clock Latencies 
#
# 5. Clock Relationships
#
# 6. set input/output delay on ports
#
# 7. Driving cells
#
# 8. Output load
set top riscv_core
####################################################################################
           #########################################################
                  #### Section 0 : DC Variables ####
           #########################################################
#################################################################################### 

####################################################################################
           #########################################################
                  #### Section 1 : Clock Definition ####
           #########################################################
#################################################################################### 
# 1. Master Clock Definitions 
create_clock -name CLK_I -period 5 -waveform {0 2.5} [get_ports clk_i]
set_dont_touch_network [get_clocks CLK_I]

#2. SCAN CLOCK
set SCAN_CLK_NAME SCAN_CLK
set SCAN_CLK_PER 100
create_clock -name $SCAN_CLK_NAME -period $SCAN_CLK_PER -waveform "0 [expr $SCAN_CLK_PER/2]" [get_ports scan_clk]
set_dont_touch_network [get_clocks $SCAN_CLK_NAME]
set_clock_groups -asynchronous  -group [get_clocks CLK_I] \
                                -group [get_clocks SCAN_CLK] 

# 2. Generated Clock Definitions
#create_generated_clock -master_clock "CLK_I" -source [get_ports clk_i] -name  CLK_M -divide_by 1 [get_nets clk_m]
#set_dont_touch_network [get_clocks CLK_M]


# 3. Clock Latencies
# 4. Clock Uncertainties
set_clock_uncertainty 0.05 [get_clocks CLK_I]
# 5. Clock Transitions
set_clock_groups [get_clocks CLK_I]
puts "\t\t\t\t ###################reporting clocks#####################"
report_clocks 
####################################################################################

 

#set_false_path -hold -from [remove_from_collection [all_inputs] [get_ports clk_i]]
#set_false_path -hold -to [all_outputs]



####################################################################################
           #########################################################
             #### Section 2 : Clocks Relationship ####
           #########################################################
####################################################################################


####################################################################################
           #########################################################
             #### Section 3 : set input/output delay on ports ####
           #########################################################
####################################################################################
#set_input_delay -max 0 -clock [get_clocks CLK_I] [remove_from_collection [all_inputs] [get_ports clk_i]]
#set_output_delay -max 0 -clock [get_clocks CLK_I] [all_outputs]


####################################################################################
           #########################################################
                  #### Section 4 : Driving cells ####
           #########################################################
####################################################################################



####################################################################################
           #########################################################
                  #### Section 5 : Output load ####
           #########################################################
####################################################################################
#set_load  25000000   [all_outputs]
set_max_fanout	20 $top






