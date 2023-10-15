# Makefile for Testing Each Repository

# List of source files
SRC = $(wildcard src/*.sv)

# List of testbench files
TESTBENCHES = $(wildcard tb/*.sv)

# Transformed testbench files into vvp targets
VVP_FILES = $(TESTBENCHES:tb/%.sv=$(OUT_DIR)/%.vvp)

# Output directory for simulation files
OUT_DIR = sim_out

# Create the output directory if it doesn't exist
$(shell mkdir -p $(OUT_DIR))

# Keep intermediate files
.SECONDARY:

# The default target
all: test

# The test target
test: $(VVP_FILES)
	@for test in $^ ; do \
		vvp $$test ; \
	done

# Rule to build .vvp files
$(OUT_DIR)/%.vvp: tb/%.sv $(SRC)
	iverilog -g2012 -o $@ $< $(SRC)

# Rule to clean the output directory
clean:
	@echo Cleaning up...
	rm -rf $(OUT_DIR)

# Declare phony targets
.PHONY: all test clean
