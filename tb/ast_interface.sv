interface ast_interface #( 
  parameter DATA_W    = 1,
  parameter EMPTY_W   = 1,
  parameter CHANNEL_W = 1
 ) ( 
  input bit clk,
  ref   bit srst
);

  task set_reset;
  
    srst = 1'b0;
    @( posedge clk );
    srst = 1'b1;
    @( posedge clk );
    srst = 1'b0;

  endtask

  logic [DATA_W-1:0]    ast_data;
  logic                 ast_startofpacket;
  logic                 ast_endofpacket;
  logic                 ast_valid;
  logic [EMPTY_W-1:0]   ast_empty;
  logic [CHANNEL_W-1:0] ast_channel;
  logic                 ast_ready;  

endinterface