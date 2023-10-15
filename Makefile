# Makefile for testing with iverilog and vvp

# Define the compiler and simulator
IVL = iverilog -g2012
VVP = vvp

# Output directory for simulation files
OUT_DIR = sim_out

# Create the output directory if it doesn't exist
$(shell mkdir -p $(OUT_DIR))

# All source files (excluding testbenches)
SOURCES = src/bcd_binary.sv \
          src/blinking_display.sv \
          src/clock_divider.sv \
          src/debounce.sv \
          src/debounce_wrapper.sv \
          src/display_driver.sv \
          src/double_dabble.sv \
          src/pwm_module.sv \
          src/segment_mux.sv \
          src/sevenseg4ddriver.sv \
          src/time_counter.sv \
          src/timer.sv \
          src/top_level.sv \
          src/tt_um_devinatkin_stopwatch.v

# Phony targets
.PHONY: all clean

all: tb_bcd_binary tb_blinking_display tb_double_dabble tb_time_counter tb_timer tb_top_level tb_sevenseg4ddriver tb_segment_mux tb_pwm_module tb_display_driver tb_clock_divider tb_debounce tb_debounce_wrapper

tb_bcd_binary: 
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/bcd_binary_tb.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_blinking_display:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/tb_blinking_display.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_clock_divider:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/tb_clock_divider.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_debounce:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/tb_debounce.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_debounce_wrapper:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/debounce_wrapper_tb.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_display_driver:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/display_driver_tb.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_double_dabble:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/double_dabble_tb.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_pwm_module:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/tb_pwm_module.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_segment_mux:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/tb_segment_mux.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_sevenseg4ddriver:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/sevenseg4ddriver_tb.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_time_counter:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/time_counter_tb.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_timer:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/timer_tb.sv
	$(VVP) $(OUT_DIR)/$@.vvp

tb_top_level:
	$(IVL) -o $(OUT_DIR)/$@.vvp $(SOURCES) tb/top_level_tb.sv
	$(VVP) $(OUT_DIR)/$@.vvp

clean:
	@echo Cleaning up...
	rm -rf $(OUT_DIR)