GENERATE_DIR := $(shell ./place.sh)
all: batch

interactive:
	cd $(GENERATE_DIR)/WORK && icc2_shell
# Target to run the script
batch:
	cd $(GENERATE_DIR)/WORK && icc2_shell -f ../../../scripts/place.tcl | tee ../log/place.log
# Target to clean up the created folders
clean:
	rm -rf run_* log

