TOP ?= top

all: synth pnr gen load

synth:
	yosys -D LEDS_NR=6 -p "read_verilog src/*.v; synth_gowin -top $(TOP) -json build/synth.json -family gw2a; show -format svg -prefix build/graph"
pnr:
	nextpnr-himbaechel --json build/synth.json --write build/routed.json --device GW2AR-LV18QN88C8/I7 --vopt family=GW2A-18C --vopt cst=src/tangnano20k.cst --placed-svg build/place.svg --routed-svg build/routed.svg
gen:
	gowin_pack -d GW2AR-LV18QN88C8/I7 -o build/pack.fs build/routed.json
load:
	@read -p "Program FPGA? [y/N]: " ans;\
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then\
		openFPGALoader -b tangnano20k build/pack.fs; \
	else \
		echo "Skipping FPGA Programming."; \
	fi