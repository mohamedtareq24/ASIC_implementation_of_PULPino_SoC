################################################################### 
# Setting DFT Timing Variables
################################################################### 

# Preclock Measure Protocol (default protocol)
set test_default_period 100
set test_default_delay 0
set test_default_bidir_delay 0
set test_default_strobe 20
set test_default_strobe_width 0

########################## Define DFT Signals ##########################

set_dft_signal -port [get_ports scan_clk]       -type ScanClock   -view existing_dft  -timing {40 60}
set_dft_signal -port [get_ports scan_set_rst]   -type Reset       -view existing_dft  -active_state 0

set_dft_signal -port [get_ports test_mode] -type Constant    -view existing_dft  -active_state 1 
set_dft_signal -port [get_ports test_mode] -type TestMode    -view spec          -active_state 1 

set_dft_signal -port [get_ports scan_shift]     -type ScanEnable    -view spec              -active_state 1   -usage scan
set_dft_signal -port [get_ports test_en_i]      -type ScanEnable    -view existing_dft      -active_state 1 

set_dft_signal -port [get_ports scan_in	]        -type ScanDataIn  -view spec 
set_dft_signal -port [get_ports scan_out]        -type ScanDataOut -view spec  


############################# Create Test Protocol #####################
create_test_protocol
###################### Pre-DFT Design Rule Checking ####################
dft_drc 
############################# Preview DFT ##############################
preview_dft -show scan_summary
############################# Insert DFT ###############################
insert_dft
######################## Optimize Logic post DFT #######################

compile -scan -incremental

###################### Design Rule Checking post DFT ###################

dft_drc -verbose -coverage_estimate > > ../reports/dft.rpt

