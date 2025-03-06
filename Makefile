SHELL := bash

ROOT := $(shell pwd)

COMPONENT_DOCS_REPO := https://github.com/bytecodealliance/component-docs
COMPONENT_DOCS := /tmp/component-docs

WASMTIME_VERSION := v30.0.2

ifneq (,$(findstring darwin,$(shell /bin/bash -c 'echo $$OSTYPE')))
WASMTIME_DIR := wasmtime-$(WASMTIME_VERSION)-aarch64-musl
WAC_BINARY := wac-cli-aarch64-apple-darwin
else
WASMTIME_DIR := wasmtime-$(WASMTIME_VERSION)-x86_64-linux
WAC_BINARY := wac-cli-x86_64-unknown-linux-musl
endif

WASMTIME_TAR := $(WASMTIME_DIR).tar.xz
WASMTIME_URL := https://github.com/bytecodealliance/wasmtime/releases/download/$(WASMTIME_VERSION)/$(WASMTIME_TAR)
WAC_URL := https://github.com/bytecodealliance/wac/releases/download/v0.6.1/$(WAC_BINARY)

CALCULATOR_WASM := calculator/target/wasm32-wasip1/release/calculator.wasm
ADDER_WASM := adder/target/wasm32-wasip1/release/adder.wasm
COMMAND_WASM := command/target/wasm32-wasip1/release/command.wasm

export PATH := $(ROOT)/bin:$(PATH)


default:

test: final.wasm bin/wasmtime
	@echo
	wasmtime run $< 1 2 add
	@echo

clean:
	$(RM) composed.wasm final.wasm
	$(RM) /tmp/$(WAC_BINARY) /tmp/$(WASMTIME_TAR)
	$(RM) -r adder calculator command wit bin
	$(RM) -r /tmp/$(WASMTIME_DIR)

realclean: clean
	$(RM) -r $(COMPONENT_DOCS)

final.wasm: $(COMMAND_WASM) composed.wasm bin/wac
	$(call heading,Building $@)
	wac plug $< --plug composed.wasm -o $@

composed.wasm: $(CALCULATOR_WASM) $(ADDER_WASM) bin/wac
	$(call heading,Building $@)
	wac plug $< --plug $(ADDER_WASM) -o $@

$(CALCULATOR_WASM): calculator
	$(call heading,Building $@)
	(cd $< && cargo component build --release)

$(ADDER_WASM): adder
	$(call heading,Building $@)
	(cd $< && cargo component build --release)

$(COMMAND_WASM): command wit
	$(call heading,Building $@)
	(cd $< && cargo component build --release)

adder calculator command wit: $(COMPONENT_DOCS)
	$(call heading,Fetching $@)
	cp -r $</component-model/examples/tutorial/$@ $@

$(COMPONENT_DOCS):
	$(call heading,Cloning $(COMPONENT_DOCS_REPO) to $@)
	git clone -q $(COMPONENT_DOCS_REPO) $@

bin/wasmtime: /tmp/$(WASMTIME_DIR)
	$(call heading,Installing $@)
	cp $</wasmtime $@

/tmp/$(WASMTIME_DIR):
	( cd /tmp && \
	  wget -q $(WASMTIME_URL) && \
	  tar xf $(WASMTIME_TAR) \
	)

bin/wac:
	$(call heading,Installing $@)
	mkdir -p bin
	( cd /tmp && \
	  wget -q $(WAC_URL) \
	) && \
	cp /tmp/$(WAC_BINARY) $@ && \
	chmod +x $@

define heading
	@echo
	### $1
	@echo
endef
