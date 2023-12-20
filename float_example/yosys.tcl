
yosys -import

read_verilog sv2v.v

prep
write_verilog -noexpr -noattr -simple-lhs sv2v.yosys.v
write_json sv2v.yosys.json
