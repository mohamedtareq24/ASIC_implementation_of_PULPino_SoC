##### TEST MODE
set SCAN_CLK_NAME SCAN_CLK
set SCAN_CLK_PER 100

create_clock -name $SCAN_CLK_NAME -period $SCAN_CLK_PER -waveform "0 [expr $SCAN_CLK_PER/2]" [get_ports scan_clk]
set_dont_touch_network [get_clocks $SCAN_CLK_NAME]

set_clock_groups -asynchronous  -name g2    -group [get_clocks $SCAN_CLK_NAME] 

