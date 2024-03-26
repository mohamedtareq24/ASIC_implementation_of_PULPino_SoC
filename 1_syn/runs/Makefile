GENERATE_DIR := $(shell ./syn.sh)
all: batch

interactive:
	cd $(GENERATE_DIR)/WORK && dc_shell | tee ../log/syn.log

# Target to run the script
batch:
	cd $(GENERATE_DIR)/WORK && dc_shell -f ../../../scripts/syn_script.tcl | tee ../log/syn.log
# Target to clean up the created folders
clean:
	rm -rf run_* log

