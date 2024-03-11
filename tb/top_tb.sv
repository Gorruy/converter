module top_tb;

  import usr_types_and_params::*;
  import tb_env::Environment;

  bit clk;
  bit srst_done;

  initial forever #5 clk = !clk;

  ast_interface ast_if ( clk );

  ast_width_extender #(
  .DATA_IN_W           ( DATA_IN_W                  ),
  .EMPTY_IN_W          ( EMPTY_IN_W                 ),
  .CHANNEL_W           ( CHANNEL_W                  ),
  .DATA_OUT_W          ( DATA_OUT_W                 ),
  .EMPTY_OUT_W         ( EMPTY_OUT_W                )
  ) ast_inst (
  .clk_i               ( clk                        ),
  .srst_i              ( ast_if.srst_i              ),

  .ast_data_i          ( ast_if.ast_data_i          ),
  .ast_startofpacket_i ( ast_if.ast_startofpacket_i ),
  .ast_endofpacket_i   ( ast_if.ast_endofpacket_i   ),
  .ast_valid_i         ( ast_if.ast_valid_i         ),
  .ast_empty_i         ( ast_if.ast_empty_i         ),
  .ast_channel_i       ( ast_if.ast_channel_i       ),

  .ast_ready_o         ( ast_if.ast_ready_o         ),

  .ast_data_o          ( ast_if.ast_data_o          ),
  .ast_startofpacket_o ( ast_if.ast_startofpacket_o ),
  .ast_endofpacket_o   ( ast_if.ast_endofpacket_o   ),
  .ast_valid_o         ( ast_if.ast_valid_o         ),
  .ast_empty_o         ( ast_if.ast_empty_o         ),
  .ast_channel_o       ( ast_if.ast_channel_o       ),
  .ast_ready_i         ( ast_if.ast_ready_i         )
  );

  initial 
    begin
      ast_if.srst_i <= 1'b0;
      @( posedge ast_if.clk );
      ast_if.srst_i <= 1'b1;
      @( posedge ast_if.clk );
      ast_if.srst_i <= 1'b0;
      srst_done     <= 1'b1;
    end 

  initial 
    begin
      Environment env;
      env = new( ast_if );

      wait(srst_done);
      ast_if.ast_data_i          = '0;         
      ast_if.ast_startofpacket_i = 1'b0;
      ast_if.ast_endofpacket_i   = 1'b0;  
      ast_if.ast_valid_i         = 1'b0;        
      ast_if.ast_empty_i         = '0;        
      ast_if.ast_channel_i       = '0;      
      @( posedge ast_if.clk );

      env.run();

      $stop();

    end


endmodule