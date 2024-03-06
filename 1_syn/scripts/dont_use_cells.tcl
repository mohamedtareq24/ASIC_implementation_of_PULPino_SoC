set BAD_CELLS "saed14rvt_ff0p88v25c/SAEDRVT14_ADDF_V1_2 saed14rvt_ff0p88v25c/SAEDRVT14_OA2BB2_V1_2 saed14rvt_ff0p88v25c/SAEDRVT14_INV_2 saed14rvt_ff0p88v25c/SAEDRVT14_AO222_2 saed14rvt_ff0p88v25c/SAEDRVT14_AOI22_2 saed14rvt_ff0p88v25c/SAEDRVT14_AO221_2 saed14rvt_ff0p88v25c/SAEDRVT14_AO2BB2_2 saed14rvt_ff0p88v25c/SAEDRVT14_EN2_2 saed14rvt_ff0p88v25c/SAEDRVT14_OR4_2 saed14rvt_ff0p88v25c/SAEDRVT14_AN3_2 saed14rvt_ff0p88v25c/SAEDRVT14_ND2_CDC_2 saed14rvt_ff0p88v25c/SAEDRVT14_NR4_2 saed14rvt_ff0p88v25c/SAEDRVT14_OR2B_PMM_2 saed14rvt_ff0p88v25c/SAEDRVT14_OA21B_2 saed14rvt_ff0p88v25c/SAEDRVT14_OAI32_2 saed14rvt_ff0p88v25c/SAEDRVT14_AN2_2 saed14rvt_ff0p88v25c/SAEDRVT14_INV_PS_2"

# Split the string into individual cell names
set cells [split $BAD_CELLS " "]

# Iterate over each cell, replace "saed14rvt_ff0p88v25c" with "*/", and set the dont_use flag
foreach cell $cells {
    set modified_cell [string map {"saed14rvt_ff0p88v25c/" "*/"} $cell]
    set_dont_use [get_lib_cell $modified_cell]
}


set_dont_use  [get_lib_cells */*_0P*]
set_dont_use  [get_lib_cells */*_1*]

