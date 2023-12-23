/*
 * File: cache_example/tb.sv
 * Author: Ethan Sifferman
 * Description: Testbench for the cache
 */

module tb import cache_pkg::*;;

logic                   clk_i;

logic [SetWidth-1:0]    read_set_i;
logic [TagWidth-1:0]    read_tag_i;

// debug probes for initialization
logic                               write_en_i;
logic [SetWidth-1:0]                write_set_i;
block_info_t [Associativity-1:0]    write_info_i;
logic [WayWidth-1:0]                write_data_way_i;
block_data_t                        write_data_i;

cache cache (
    .clk_i,

    .read_set_i,
    .read_tag_i,

    // debug probes for initialization
    .write_en_i,
    .write_set_i,
    .write_info_i,
    .write_data_way_i,
    .write_data_i
);

initial begin
    clk_i = 1;
    forever begin
        #1;
        clk_i = ~clk_i;
    end
end

initial begin
    $dumpfile("dump.fst");
    $dumpvars;

    // check parameters
    assert (TagWidth >= $clog2(Associativity));

    // write info to set 0
    write_en_i = 1;
    write_set_i = 0;
    for (integer i = 0; i < Associativity; i++) begin
        write_info_i[i].valid = 1;
        write_info_i[i].tag = TagWidth'(i);
    end
    @(posedge clk_i);

    // write data to set 0
    for (integer i = 0; i < Associativity; i++) begin
        write_data_way_i = WayWidth'(i);
        write_data_i = DataWidth'($random);
        @(posedge clk_i);
    end

    // check for hits in set 0
    for (integer i = 0; i < Associativity; i++) begin
        read_set_i = 0;
        read_tag_i = TagWidth'(i);
        @(negedge clk_i);
        assert (cache.read_hit_o) else $display("Miss on set:%d tag:%d", read_set_i, read_tag_i);
    end

    if (TagWidth > $clog2(Associativity)) begin
        // test miss in set 0
        read_set_i = 0;
        read_tag_i = TagWidth'(Associativity);
        @(negedge clk_i);
        assert (!cache.read_hit_o) else $display("Hit on set:%d tag:%d", read_set_i, read_tag_i);
    end

    $finish;
end

endmodule
