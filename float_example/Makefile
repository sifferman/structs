
RTL := float_pkg.sv float.sv
YOSYS_DATDIR := $(shell yosys-config --datdir)

all: sv2v.v sv2v.yosys.v sv2v.yosys.netlistsvg.svg sim gls

.SECONDARY:

sv2v.v: ${RTL}
	sv2v ${RTL} -w $@

sv2v.yosys.v sv2v.yosys.json: sv2v.v
	yosys -c yosys.tcl

sv2v.yosys.netlistsvg.svg: sv2v.yosys.json
	netlistsvg $< -o $@
	sed -i '2i<rect width="100%" height="100%" fill="white"/>' $@

sim:
	verilator --Mdir $@_dir -f verilator.f float_pkg.sv float.sv tb.sv
	./$@_dir/Vtb +verilator+rand+reset+2

gls:
	verilator --Mdir $@_dir -I${YOSYS_DATDIR} -f verilator.f float_pkg.sv simlib.v sv2v.yosys.v tb.sv
	./$@_dir/Vtb +verilator+rand+reset+2

clean:
	rm -rf *sv2v.v *yosys.v *.json *.svg sim_dir gls_dir *.fst
