set_app_options -name lib.workspace.group_libs_combine_physical_only -value false
set_app_options -name lib.workspace.use_workspace_tech -value true
set_app_options -name lib.workspace.fast_exploration -value true
set_app_options -name lib.workspace.reuse_lib -value true
set_app_options -name lib.workspace.create_cached_lib -value true
# workspace saed14rvt_c:
create_workspace saed14rvt_c
read_db /mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/db_nldm/saed14rvt_ff0p88v25c.db
read_db /mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/db_nldm/saed14rvt_ss0p6vm40c.db
read_ndm /mnt/hgfs/ASIC_shared/LIBs/stdcell_rvt/ndm/saed14rvt_frame_only.ndm
process_workspaces -check_options {-allow_missing} -output CLIBs/saed14rvt_c.ndm -force
remove_workspace


