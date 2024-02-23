####################################################################################
###################################  PLACEMENT  ###################################
####################################################################################

############################################################
### get the last powerplan run 
puts "latest powerplanning run will be used for input data"

set base_path "/home/ICer/GP/PULP/cv32e40p/powerplan/runs/"
set latest_run ""
set latest_run_number 0

# Get a list of directories in the base path
set directories [glob -type d "${base_path}/*"]

# Iterate through each directory
foreach dir $directories {
    # Extract the run number from the directory name
    set run_number [file tail $dir]

    # If the directory name matches the pattern "run_<number>", extract the number
    if {[regexp {run_(\d+)} $run_number - match run_number]} {
        # Check if the current run number is greater than the latest run number
        if {$run_number > $latest_run_number} {
            set latest_run_number $run_number
        }
    }
}

set DESIGN_NAME riscv_core

set DLIB_PATH $dir/WORK/${DESIGN_NAME}

sh cp -r $DLIB_PATH .

set DLIB_PATH ./${DESIGN_NAME} 
############OPEN DLIB###############
open_lib $DLIB_PATH

#####################OPEN POWERPLANNED BLOCKED#####################
open_block -edit $DESIGN_NAME:${DESIGN_NAME}_powerplan

link
###############################################################################
###############################################################################
##################################PLACMENT BEGINS##############################
set_app_options -name time.disable_recovery_removal_checks -value false
set_app_options -name time.disable_case_analysis -value false
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name opt.common.user_instance_name_prefix -value place

place_opt
legalize_placement
check_legality -verbos


save_block -as ${DESIGN_NAME}_placed


report_qor > ../reports/qor.rpt
report_utilization > ../reports/utilization.rpt

