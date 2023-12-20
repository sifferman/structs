
RTL := float_pkg.sv float.sv

all: sv2v.v sv2v.yosys.v sv2v.yosys.netlistsvg.svg

.SECONDARY:

sv2v.v: ${RTL}
	sv2v ${RTL} -w $@

sv2v.yosys.v sv2v.yosys.json: sv2v.v
	yosys -c yosys.tcl

sv2v.yosys.netlistsvg.svg: sv2v.yosys.json
	netlistsvg $< -o $@
	sed -i '2i<rect width="100%" height="100%" fill="white"/>' $@

clean:
	rm -rf *sv2v.v *yosys.v *.json *.svg
