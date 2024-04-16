# Read error messages from file
set file_path "badcells.txt"
set error_messages [split [string trim [exec cat $file_path]] "\n\n"]

# Regular expression to match the lines containing 'net' values
set pattern {net = .+}

# Variable to store all 'net' values
set all_nets {}

# Iterate over each error message and extract 'net' values
foreach message $error_messages {
    set lines [split $message \n]
    foreach line $lines {
        if {[regexp $pattern $line]} {
            # Extract the 'net' value from the line
            set net [string range $line [expr {[string first "=" $line] + 2}] end]
            # Append the 'net' value to the list if it is not "VSS" or "VDD"
            if {$net ni {"VSS" "VDD"}} {
                lappend all_nets $net
            }
        }
    }
}

# Print the filtered 'net' values
puts "Filtered nets:"
foreach net $all_nets {
    puts $net
}
get_lib_cells -of_objects [get_cells -of_objects $all_nets] > dont_use_cells.txt

