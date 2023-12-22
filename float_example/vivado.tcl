
create_project float ./vivado-build -part xc7a100tcsg324-1

add_files -norecurse float_pkg.sv float.sv
set_property top_file float.sv [current_fileset]

set nproc [exec nproc]
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1]
launch_runs synth_1 -jobs $nproc
wait_on_run synth_1
open_run synth_1 -name synth_1

write_verilog -force -include_xilinx_libs vivado.v

start_gui
show_schematic [get_nets]
write_schematic -format svg -scope current_page -verbose -force vivado.svg

exit
