TOP ?= top

all: synth pnr gen

synth:
	yosys -p "read_verilog -sv src/*.sv; synth_gowin -top $(TOP) -json build/synth.json -family gw2a;"
pnr:
	nextpnr-himbaechel --json build/synth.json --write build/routed.json --device GW2AR-LV18QN88C8/I7 --vopt family=GW2A-18C --vopt cst=src/tangnano20k.cst
gen:
	gowin_pack -d GW2AR-LV18QN88C8/I7 -o build/pack.fs build/routed.json