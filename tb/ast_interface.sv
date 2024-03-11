interface ast_interface ( input bit clk );

  import usr_types_and_params::*;

  logic                   srst_i;
  logic [DATA_IN_W-1:0]   ast_data_i;
  logic                   ast_startofpacket_i;
  logic                   ast_endofpacket_i;
  logic                   ast_valid_i;
  logic [EMPTY_IN_W-1:0]  ast_empty_i;
  logic [CHANNEL_W-1:0]   ast_channel_i;
 
  logic                   ast_ready_o;
  logic [DATA_OUT_W-1:0]  ast_data_o;
  logic                   ast_startofpacket_o;
  logic                   ast_endofpacket_o;
  logic                   ast_valid_o;
  logic [EMPTY_OUT_W-1:0] ast_empty_o;
  logic [CHANNEL_W-1:0]   ast_channel_o;
  logic                   ast_ready_i;  

  default clocking cb @( posedge clk );
  endclocking

endinterface