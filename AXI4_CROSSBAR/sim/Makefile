OBJ_DIR   			= $(abspath ./build)
CSRC_DIR 			= $(abspath ./sim_csrc)
VSRC_DIR 			= $(abspath ./sim_vsrc)

VERILOG_TOP 		= $(VSRC_DIR)/SIM_TOP.sv
VFLAGS 				= --trace --cc --exe -O3 --threads-dpi all -I$(VSRC_DIR) -Mdir $(OBJ_DIR) -DDIFF
CINC_PATH 			= -CFLAGS -I$(CSRC_DIR)/include 
CSRC 				= $(shell find $(CSRC_DIR) -name "*.c*")
VSRC 				= $(shell find $(VSRC_DIR) -name "*.sv")
VBIN 				=  $(OBJ_DIR)/$(addprefix V, $(basename $(notdir $(VERILOG_TOP))))
REWRITE 			= $(abspath ./rewrite.mk)

COLOR_RED   		= \033[1;31m
COLOR_GREEN 		= \033[1;32m
COLOR_YELLOW 		= \033[33m
COLOR_NONE  		= \033[0m

.PHONY: run clean

$(VBIN): $(CSRC) $(VSRC)
	@echo "$(COLOR_YELLOW)[VERILATE]$(COLOR_NONE)"
	verilator $(VFLAGS) $(CSRC) $(CINC_PATH) $(VERILOG_TOP)
	@make -s -C $(OBJ_DIR) -f $(REWRITE)

run: $(VBIN)
	@echo "$(COLOR_YELLOW)[RUN]$(COLOR_NONE)"
	@$(VBIN)

clean:
	@echo "$(COLOR_YELLOW)[CLEAR]$(COLOR_NONE)"
	@rm -rf $(OBJ_DIR)
	@rm -rf *.vcd

