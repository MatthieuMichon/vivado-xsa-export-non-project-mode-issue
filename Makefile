SYN ?= vivado
FLOW ?= non_project_mode
TIMESTAMP := $(shell date -u +%Y%m%d%H%M%S)

VIVADO_VERSION := $(shell which vivado | grep -oE '202[0-9]\.[0-9]')
BUILD_DIR = build--$(VIVADO_VERSION)--$(FLOW)--$(TIMESTAMP)

SYN_MODE ?= batch
SCRIPT = $(FLOW)_flow.tcl
SYN_FLAGS ?= -mode $(SYN_MODE) -nojournal -notrace -source ../$(SCRIPT)

.PHONY: all
all: fpga

.PHONY: fpga
fpga: $(BUILD_DIR)
	cd $(BUILD_DIR) && $(SYN) $(SYN_FLAGS)
	ln -snf $(BUILD_DIR) build--latest

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	$(RM) build--latest

distclean:
	$(RM) -r build--*
