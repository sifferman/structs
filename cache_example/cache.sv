/*
 * File: cache_example/cache.sv
 * Author: Ethan Sifferman
 * Description: Basic cache that only supports read hits
 */

module cache import cache_pkg::*; (
    input   logic                   clk_i,

    input   logic [SetWidth-1:0]    read_set_i,
    input   logic [TagWidth-1:0]    read_tag_i,
    output  logic                   read_hit_o,
    output  logic [DataWidth-1:0]   read_data_o,

    // debug probes for initialization
    input   logic                               write_en_i,
    input   logic [SetWidth-1:0]                write_set_i,

    input   block_info_t [Associativity-1:0]    write_info_i,

    input   logic [WayWidth-1:0]                write_data_way_i,
    input   block_data_t                        write_data_i
);

// Cache Info: Optionally implemented as FFs
logic [Associativity*InfoWidth-1:0] block_info [NumSets];

// Cache Data: Implemented as SRAM
logic [DataWidth-1:0] block_data [NumSets*Associativity];

typedef logic [$clog2((NumSets*Associativity<2)?2:(NumSets*Associativity))-1:0] block_data_index_t;

function automatic block_data_index_t index_block_data(logic [SetWidth-1:0] set, logic [WayWidth-1:0] way);
    if (Associativity == 1)
        return block_data_index_t'(set);
    return block_data_index_t'({set, way});
endfunction

// Cache line at read_set_i
wire block_info_t [Associativity-1:0] read_cache_line_info = block_info[read_set_i];

// Index of way that is hit
logic [WayWidth-1:0] hit_way;

always_comb begin
    read_hit_o = 0;
    hit_way = 'x;
    for (integer i = 0; i < Associativity; i++) begin
        // check block_info for hit
        if (read_cache_line_info[i].valid && (read_cache_line_info[i].tag == read_tag_i)) begin
            read_hit_o = 1;
            hit_way = WayWidth'(i);
        end
    end
end

assign read_data_o = block_data[index_block_data(read_set_i, hit_way)];

always_ff @(posedge clk_i) begin
    if (write_en_i) begin
        block_info[write_set_i] <= write_info_i;
        block_data[index_block_data(write_set_i, write_data_way_i)] <= write_data_i;
    end
end

endmodule
