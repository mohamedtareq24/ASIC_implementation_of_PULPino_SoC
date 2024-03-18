GENERATE_DIR := $(shell ./cts.sh)
all: batch

interactive:
	cd $(GENERATE_DIR)/WORK && icc2_shell
# Target to run the script
batch:
	cd $(GENERATE_DIR)/WORK && icc2_shell -f ../../../scripts/cts.tcl | tee ../log/cts.log
# Target to clean up the created folders
clean:
	rm -rf run_* log

