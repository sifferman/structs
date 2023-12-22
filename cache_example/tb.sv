
module tb import cache_pkg::*;;

logic                   clk_i;

logic [SetWidth-1:0]    read_set_i;
logic [TagWidth-1:0]    read_tag_i;

// debug
logic                               write_en_i;
logic [SetWidth-1:0]                write_set_i;
block_info_t [Associativity-1:0]    write_set_info_i;
block_data_t [Associativity-1:0]    write_set_data_i;

cache cache (
    .clk_i,

    .read_set_i,
    .read_tag_i,

    // debug
    .write_en_i,
    .write_set_i,
    .write_set_info_i,
    .write_set_data_i
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

    // write to set 0
    write_en_i = 1;
    write_set_i = 0;
    for (integer i = 0; i < Associativity; i++) begin
        write_set_info_i[i].valid = 1;
        write_set_info_i[i].tag = TagWidth'(i);
        write_set_data_i[i] = DataWidth'($urandom());
    end
    @(posedge clk_i);

    // check for hits in set 0
    for (integer i = 0; i < Associativity; i++) begin
        read_set_i = 0;
        read_tag_i = TagWidth'(i);
        @(negedge clk_i);
        assert (cache.read_hit_o) else $display("Miss on set:%d tag:%d", read_set_i, read_tag_i);
    end

    // test miss in set 0
    read_set_i = 0;
    read_tag_i = TagWidth'(Associativity);
    @(negedge clk_i);
    assert (!cache.read_hit_o) else $display("Hit on set:%d tag:%d", read_set_i, read_tag_i);

    $finish;
end

endmodule
