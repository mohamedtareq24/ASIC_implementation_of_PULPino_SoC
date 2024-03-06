## "Elaborating RISCY"
#----------------------
#------------------------
#---------------------------
set RTL_PATH            "/mnt/hgfs/cv32e40p/rtl"
set DEFINES_PATH 	"/mnt/hgfs/cv32e40p/defines"
set top riscv_core
#Add the path of the libraries and RTL files to the search_path variable
lappend search_path $DB_PATH $RTL_PATH

### listing includes & packages
set include_files [glob -directory $DEFINES_PATH *.*]

## analyzing listing includes & packages
analyze -autoread $include_files			

####listing RTL files
set files [glob -nocomplain -directory $RTL_PATH *.{sv,v,vhd}]
set filtered_files {}

foreach file $files {
    if {[string match -nocase *define* $file] != 1 || [string match -nocase *package* $file] != 1} {
        lappend RTL_files $file
    }
}

# Now, RTL_files contains the list of files with .sv, .v, or .vhd extension
# and do not contain *define* or *package* in their names


# Analyzing RTL files 
analyze -autoread  $RTL_files

## elaborate
elaborate $top

### checking unresolved stuff
link

