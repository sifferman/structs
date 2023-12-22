
package cache_pkg;

parameter int NumSets = 64;
localparam int SetWidth = $clog2((NumSets<2) ? 2 : NumSets);
parameter int Associativity = 1;
localparam int WayWidth = $clog2((Associativity<2) ? 2 : Associativity);
parameter int TagWidth = 4;

parameter int DataWidth = 4;

// To be implemented as FFs
typedef struct packed {
    logic valid;
    logic [TagWidth-1:0] tag;
} block_info_t;
localparam int InfoWidth = $bits(block_info_t);

// To be implemented as SRAM
typedef logic [DataWidth-1:0] block_data_t;

endpackage
