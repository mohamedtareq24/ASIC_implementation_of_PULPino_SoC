# Read error messages from file
set file_path "drcs.txt"
set error_messages [split [string trim [exec cat $file_path]] "\n\n"]

# Iterate over each error message and extract the Metal island b-box locations
foreach message $error_messages {
    # Remove the "Metal island b-box: " prefix from the line
    set clean_message [string map {"box: " ""} $message]
    
    # Extract the start and end locations from the clean message
    if {[regexp {\{([\d.]+ [\d.]+)\} \{([\d.]+ [\d.]+)\}} $clean_message -> start_location end_location]} {
        puts "$start_location\n$end_location"
    }
		get_lib_cells -of_objects [get_cells -at  $start_location] > BADCELLS.txt
		get_lib_cells -of_objects [get_cells -at  $end_location] > BADCELLS.txt
}

