
sim:
	verilator --Mdir $@_dir -f verilator.f tb.sv
	./$@_dir/Vtb +verilator+rand+reset+2

clean:
	rm -rf sim_dir
