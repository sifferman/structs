
module cache import cache_pkg::*; (
    input   logic                   clk_i,

    input   logic [SetWidth-1:0]    read_set_i,
    input   logic [TagWidth-1:0]    read_tag_i,
    output  logic                   read_hit_o,
    output  logic [DataWidth-1:0]   read_data_o,

    // debug
    input   logic                               write_en_i,
    input   logic [SetWidth-1:0]                write_set_i,
    input   block_info_t [Associativity-1:0]    write_set_info_i,
    input   block_data_t [Associativity-1:0]    write_set_data_i
);

// This basic example only supports read hits

// Implemented as FFs
logic [Associativity*InfoWidth-1:0] block_info [NumSets];

// Implemented as SRAM
logic [Associativity*DataWidth-1:0] block_data [NumSets];

always_ff @(posedge clk_i) begin
    if (write_en_i) begin
        block_info[write_set_i] <= write_set_info_i; // FFs
        block_data[write_set_i] <= write_set_data_i; // SRAM
    end
end

// cache line at read_set_i
block_info_t [Associativity-1:0] read_cache_line_info;
assign read_cache_line_info = block_info[read_set_i];
block_data_t [Associativity-1:0] read_cache_line_data;
assign read_cache_line_data = block_data[read_set_i];

// index of way that is hit
logic [WayWidth-1:0] hit_way;
assign read_data_o = read_cache_line_data[hit_way];

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

endmodule
