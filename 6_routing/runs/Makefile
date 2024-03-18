GENERATE_DIR := $(shell ./routing.sh)
all: batch

interactive:
	cd $(GENERATE_DIR)/WORK && icc2_shell
# Target to run the script
batch:
	cd $(GENERATE_DIR)/WORK && icc2_shell -f ../../../scripts/routing.tcl | tee ../log/routing.log
# Target to clean up the created folders
clean:
	rm -rf run_* log

