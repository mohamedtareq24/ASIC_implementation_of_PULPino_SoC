GENERATE_DIR := $(shell ./floor.sh)
all: floor

interactive:
	cd $(GENERATE_DIR)/WORK && icc2_shell
# Target to run the script
batch:
	cd $(GENERATE_DIR)/WORK && icc2_shell -f ../../../scripts/floor.tcl | tee ../log/floor.log

# Target to clean up the created folders
clean:
	rm -rf run_* log

