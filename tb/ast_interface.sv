interface ast_interface #( 
  parameter DATA_W    = 1,
  parameter EMPTY_W   = 1,
  parameter CHANNEL_W = 1
 ) ( 
  input bit   clk,
  input logic srst
);

  logic [DATA_W-1:0]    ast_data;
  logic                 ast_startofpacket;
  logic                 ast_endofpacket;
  logic                 ast_valid;
  logic [EMPTY_W-1:0]   ast_empty;
  logic [CHANNEL_W-1:0] ast_channel;
  logic                 ast_ready;  

endinterface