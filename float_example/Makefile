
RTL := float_pkg.sv float.sv
YOSYS_DATDIR := $(shell yosys-config --datdir)

all: sv2v.v sv2v.yosys.v sv2v.yosys.netlistsvg.svg sim gls

.SECONDARY:

sim:
	verilator --Mdir $@_dir -f verilator.f float_pkg.sv float.sv tb.sv
	./$@_dir/Vtb +verilator+rand+reset+2

gls: sv2v.yosys.v
	verilator --Mdir $@_dir -I${YOSYS_DATDIR} -f verilator.f float_pkg.sv simlib.v sv2v.yosys.v tb.sv
	./$@_dir/Vtb +verilator+rand+reset+2

sv2v.yosys.netlistsvg.svg: sv2v.yosys.json
	netlistsvg $< -o $@
	sed -i -E 's@(<svg[^>]*>)@\1<rect width="100%" height="100%" fill="white"/>@g' "$@"

sv2v.yosys.v sv2v.yosys.json: yosys.tcl sv2v.v
	yosys -c yosys.tcl

sv2v.v: ${RTL}
	sv2v -D SYNTHESIS -w $@ ${RTL}

vivado.v vivado.svg: vivado.tcl float_pkg.sv float.sv
	rm -rf vivado-build .Xil vivado.svg vivado.v
	vivado -nolog -nojournal -mode tcl -source vivado.tcl

clean:
	rm -rf *sv2v.v *yosys.v *.json *.svg sim_dir gls_dir *.fst .Xil vivado-build *vivado.v
