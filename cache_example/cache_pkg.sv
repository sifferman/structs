/*
 * File: cache_example/cache_pkg.sv
 * Author: Ethan Sifferman
 * Description: Package to describe and parameterize the cache structure
 */

package cache_pkg;

parameter int NumSets = 16;
parameter int TagWidth = 8;
parameter int Associativity = 1;
parameter int DataWidth = 16;

localparam int SetWidth = $clog2((NumSets<2) ? 2 : NumSets);
localparam int WayWidth = $clog2((Associativity<2) ? 2 : Associativity);

// To optionally be implemented as FFs
typedef struct packed {
    logic valid;
    logic [TagWidth-1:0] tag;
} block_info_t;
localparam int InfoWidth = $bits(block_info_t);

// To be implemented as SRAM
typedef logic [DataWidth-1:0] block_data_t;

endpackage
