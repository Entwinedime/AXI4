OBJ_DIR             = $(abspath ./build)
CSRC_DIR            = $(abspath ./csrc)
VSRC_DIR            = $(abspath ../vsrc)

TOP_MODULE          = SIM_TOP

VFLAGS              =   --trace --cc --exe --build \
						+define+_AXI4_CROSSBAR_SIM_ \
						+define+MASTER_NUM=4 \
						+define+SLAVE_NUM=4 \
						+define+W_ID_LEN=4 \
						+define+R_ID_LEN=4 \
						+define+ADDR_WIDTH=32 \
						+define+DATA_WIDTH=64 \
						--top-module $(TOP_MODULE) -Mdir $(OBJ_DIR)

VINCLUDE            = -I$(VSRC_DIR)/include
CINCLUDE            = -CFLAGS -I$(CSRC_DIR)/include 

CSRC                = $(shell find $(CSRC_DIR) -name "*.c*")
VSRC                = $(shell find $(VSRC_DIR) -name "*.sv")

VBIN                = $(OBJ_DIR)/$(addprefix V, $(basename $(notdir $(TOP_MODULE))))
REWRITE             = $(abspath ./rewrite.mk)

COLOR_NONE          = \033[0m
COLOR_YELLOW        = \033[33m

.PHONY: run clean

$(VBIN): $(CSRC) $(VSRC)
	@echo "$(COLOR_YELLOW)[VERILATE]$(COLOR_NONE)"
	verilator $(VFLAGS) $(VSRC) $(VINCLUDE) $(CSRC) $(CINCLUDE)
	@make -s -C $(OBJ_DIR) -f $(REWRITE)

run: $(VBIN)
	@echo "$(COLOR_YELLOW)[RUN]$(COLOR_NONE)"
	@$(VBIN)

clean:
	@echo "$(COLOR_YELLOW)[CLEAR]$(COLOR_NONE)"
	@rm -rf $(OBJ_DIR)
	@rm -rf *.vcd

