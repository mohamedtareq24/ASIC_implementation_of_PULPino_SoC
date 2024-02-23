create_clock -name CLK_I -period 5 -waveform {0 2.5} [get_ports clk_i]
set_dont_touch_network [get_clocks CLK_I]

# 2. Generated Clock Definitions
#create_generated_clock -master_clock "CLK_I" -source [get_ports clk_i] -name  CLK_GATED -divide_by 1 [get_ports core_clock_gate_i/clk_o]
#set_dont_touch_network [get_clocks CLK_GATED]


# 3. Clock Latencies
# 4. Clock Uncertainties
#set_clock_uncertainty 0.05 [get_clocks CLK_I]
# 5. Clock Transitions
set_clock_groups -asynchronous -name g1 -group CLK_I
