module top_tb;

  import usr_types_and_params::*;
  import tb_env::Environment;

  bit clk;
  bit srst_done;

  initial forever #5 clk = !clk;

  ast_interface #(
    .DATA_W    ( DATA_IN_W  ), 
    .EMPTY_W   ( EMPTY_IN_W ),
    .CHANNEL_W ( CHANNEL_W  ) 
  ) ast_if_in ( 
    .clk(clk) 
  );

  ast_interface #(
    .DATA_W    ( DATA_OUT_W  ), 
    .EMPTY_W   ( EMPTY_OUT_W ),
    .CHANNEL_W ( CHANNEL_W   ) 
  ) ast_if_out ( 
    .clk(clk) 
  );

  ast_width_extender #(
  .DATA_IN_W           ( DATA_IN_W                    ),
  .CHANNEL_W           ( CHANNEL_W                    ),
  .DATA_OUT_W          ( DATA_OUT_W                   )
  ) ast_inst (
  .clk_i               ( clk                          ),
  .srst_i              ( ast_if_in.srst               ),

  .ast_data_i          ( ast_if_in.ast_data           ),
  .ast_startofpacket_i ( ast_if_in.ast_startofpacket  ),
  .ast_endofpacket_i   ( ast_if_in.ast_endofpacket    ),
  .ast_valid_i         ( ast_if_in.ast_valid          ),
  .ast_empty_i         ( ast_if_in.ast_empty          ),
  .ast_channel_i       ( ast_if_in.ast_channel        ),

  .ast_ready_o         ( ast_if_in.ast_ready          ),

  .ast_data_o          ( ast_if_out.ast_data          ),
  .ast_startofpacket_o ( ast_if_out.ast_startofpacket ),
  .ast_endofpacket_o   ( ast_if_out.ast_endofpacket   ),
  .ast_valid_o         ( ast_if_out.ast_valid         ),
  .ast_empty_o         ( ast_if_out.ast_empty         ),
  .ast_channel_o       ( ast_if_out.ast_channel       ),
  .ast_ready_i         ( ast_if_out.ast_ready         )
  );

  initial 
    begin
      ast_if_in.srst <= 1'b0;
      @( posedge ast_if_in.clk );
      ast_if_in.srst <= 1'b1;
      @( posedge ast_if_in.clk );
      ast_if_in.srst <= 1'b0;
      srst_done     <= 1'b1;
    end 

  initial 
    begin
      Environment env;
      env = new( ast_if_in, ast_if_out );

      wait(srst_done);
      ast_if_in.ast_data          <= '0;         
      ast_if_in.ast_startofpacket <= 1'b0;
      ast_if_in.ast_endofpacket   <= 1'b0;  
      ast_if_in.ast_valid         <= 1'b0;        
      ast_if_in.ast_empty         <= '0;        
      ast_if_in.ast_channel       <= '0;      
      @( posedge ast_if_in.clk );

      env.run();

      $stop();

    end


endmodule