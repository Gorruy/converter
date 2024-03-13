package tb_env;

  import usr_types_and_params::*;
  
  class Transaction;
  // Instance of this class will hold all info about single transaction in
  // a form of queues, where each element in queue represents values of 
  // dut signal during transaction

    in_data_t     data;
    int           len;
    channel_t     channel[$];
    empty_in_t    empty[$];
    queued_bits_t valid;
    queued_bits_t ready;
    queued_bits_t startofpacket;
    queued_bits_t endofpacket;
    bit           wait_dut_ready;
    
  endclass
  
  class Generator;
  // This class will generate random transactions

    mailbox #( Transaction ) generated_transactions;

    function new( mailbox #( Transaction ) gen_tr );

      generated_transactions = gen_tr;

    endfunction

    task run;

      Transaction tr;

      // Normal transaction
      tr     = new();
      tr.len = WORK_TR_LEN ;

      repeat(WORK_TR_LEN)
        begin
          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );

          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( '0 );
          tr.valid.push_back( 1'b1 );
          tr.ready.push_back( 1'b1 );
          tr.startofpacket.push_back( 1'b0 );
          tr.endofpacket.push_back( 1'b0 );
        end

      tr.startofpacket[$] = 1'b1;
      tr.endofpacket[0]   = 1'b1;
      tr.wait_dut_ready   = 1'b1;

      generated_transactions.put(tr);

      // Transactions of length one
      repeat ( NUMBER_OF_ONE_LENGHT_RUNS )
        begin
          tr     = new();
          tr.len = 1;

          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( '0 );
          tr.valid.push_back( 1'b1 );
          tr.ready.push_back( 1'b1 );
          tr.startofpacket.push_back( 1'b1 );
          tr.endofpacket.push_back( 1'b1 );

          tr.wait_dut_ready = 1'b1;

          generated_transactions.put(tr);
        end

      // Transaction without valid
      tr     = new();
      tr.len = WORK_TR_LEN ;

      repeat(WORK_TR_LEN)
        begin
          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );

          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( $urandom_range( 2**EMPTY_IN_W, 0 ) );
          tr.valid.push_back( 1'b0 );
          tr.ready.push_back( 1'b1 );
          tr.startofpacket.push_back( 1'b0 );
          tr.endofpacket.push_back( 1'b0 );
        end

      tr.startofpacket[$] = 1'b1;
      tr.endofpacket[0]   = 1'b1;
      tr.wait_dut_ready   = 1'b1;

      generated_transactions.put(tr);

      // Transactions of max length with random valid
      repeat (NUMBER_OF_TEST_RUNS)
        begin
          tr     = new();
          tr.len = WORK_TR_LEN ;

          repeat(WORK_TR_LEN)
            begin
              tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
    
              tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
              tr.empty.push_back( $urandom_range( 2**EMPTY_IN_W, 0 ) );
              tr.valid.push_back( $urandom_range( 1, 0 ) );
              tr.ready.push_back( 1'b1 );
              tr.startofpacket.push_back( 1'b0 );
              tr.endofpacket.push_back( 1'b0 );
            end

          tr.startofpacket[$] = 1'b1;
          tr.endofpacket[0]   = 1'b1;
          tr.valid[$]         = 1'b1;
          tr.valid[0]         = 1'b1;
          tr.wait_dut_ready   = 1'b1;

          generated_transactions.put(tr);
        end


      // Transactions of max length with empty's values progression
      for ( int i = 0; i < 2**EMPTY_IN_W; i++ )
        begin
          tr     = new();
          tr.len = WORK_TR_LEN ;

          repeat(WORK_TR_LEN)
            begin
              tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
    
              tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
              tr.empty.push_back( i );
              tr.valid.push_back( 1'b1 );
              tr.ready.push_back( 1'b1 );
              tr.startofpacket.push_back( 1'b0 );
              tr.endofpacket.push_back( 1'b0 );
            end

          tr.startofpacket[$] = 1'b1;
          tr.endofpacket[0]   = 1'b1;
          tr.ready[0]         = 1'b1;
          tr.wait_dut_ready   = 1'b1;

          generated_transactions.put(tr);
        end

      // Transaction with constant high value of startofpacket 
      tr     = new();
      tr.len = WORK_TR_LEN;

      repeat(WORK_TR_LEN)
        begin
          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( $urandom_range( 2**EMPTY_IN_W, 0 ) );
          tr.valid.push_back( 1'b0 );
          tr.ready.push_back( 1'b1 );
          tr.startofpacket.push_back( 1'b1 );
          tr.endofpacket.push_back( 1'b0 );
        end
      tr.endofpacket[0]   = 1'b1;
      tr.valid[$]         = 1'b1;
      tr.valid[0]         = 1'b1;
      tr.ready[0]         = 1'b1;
      tr.startofpacket[0] = 1'b0;
      tr.wait_dut_ready   = 1'b0;

      generated_transactions.put(tr);

      // Transactions of max length with random ready
      repeat (NUMBER_OF_TEST_RUNS)
        begin
          tr     = new();
          tr.len = WORK_TR_LEN ;

          repeat(WORK_TR_LEN)
            begin
              tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
    
              tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
              tr.empty.push_back( $urandom_range( 2**EMPTY_IN_W, 0 ) );
              tr.valid.push_back( 1'b1 );
              tr.ready.push_back( $urandom_range( 1, 0 ) );
              tr.startofpacket.push_back( 1'b0 );
              tr.endofpacket.push_back( 1'b0 );
            end

          tr.startofpacket[$] = 1'b1;
          tr.endofpacket[0]   = 1'b1;
          tr.valid[$]         = 1'b1;
          tr.valid[0]         = 1'b1;
          tr.wait_dut_ready   = 1'b0;

          generated_transactions.put(tr);
        end

      // Transactions of max length without ready
      repeat (NUMBER_OF_TEST_RUNS)
        begin
          tr     = new();
          tr.len = WORK_TR_LEN ;

          repeat(WORK_TR_LEN)
            begin
              tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
    
              tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
              tr.empty.push_back( $urandom_range( 2**EMPTY_IN_W, 0 ) );
              tr.valid.push_back( 1'b1 );
              tr.ready.push_back( 1'b0 );
              tr.startofpacket.push_back( 1'b0 );
              tr.endofpacket.push_back( 1'b0 );
            end

          tr.startofpacket[$] = 1'b1;
          tr.endofpacket[0]   = 1'b1;
          tr.valid[$]         = 1'b1;
          tr.valid[0]         = 1'b1;
          tr.wait_dut_ready   = 1'b1;

          generated_transactions.put(tr);
        end

      // transaction without startofpacket
      tr     = new();
      tr.len = WORK_TR_LEN;

      repeat(tr.len)
        begin
          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );

          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( '0 );
          tr.valid.push_back( 1'b1 );
          tr.ready.push_back( 1'b1 );
          tr.startofpacket.push_back( 1'b0 );
          tr.endofpacket.push_back( 1'b0 );
        end

      tr.endofpacket[0]   = 1'b1;
      tr.wait_dut_ready   = 1'b1;

      generated_transactions.put(tr);

      // Transactions with length progression
      for ( int i = 2; i < WORK_TR_LEN; i++ )
        begin
          tr     = new();
          tr.len = i ;

          repeat(i)
            begin
              tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );

              tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
              tr.empty.push_back( '0 );
              tr.valid.push_back( 1'b1 );
              tr.ready.push_back( 1'b1 );
              tr.startofpacket.push_back( 1'b0 );
              tr.endofpacket.push_back( 1'b0 );
            end

          tr.startofpacket[$] = 1'b1;
          tr.endofpacket[0]   = 1'b1;
          tr.wait_dut_ready   = 1'b1;

          generated_transactions.put(tr);
        end

      // Normal transaction of max length
      tr     = new();
      tr.len = MAX_TR_LEN - 1;

      repeat(tr.len)
        begin
          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );

          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( '0 );
          tr.valid.push_back( 1'b1 );
          tr.ready.push_back( 1'b1 );
          tr.startofpacket.push_back( 1'b0 );
          tr.endofpacket.push_back( 1'b0 );
        end

      tr.startofpacket[$] = 1'b1;
      tr.endofpacket[0]   = 1'b1;
      tr.wait_dut_ready   = 1'b1;

      generated_transactions.put(tr);

      // Transaction without valid at endofpacket
      tr     = new();
      tr.len = WORK_TR_LEN ;

      repeat(WORK_TR_LEN)
        begin
          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );

          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( 0 );
          tr.valid.push_back( 1'b1 );
          tr.ready.push_back( 1'b1 );
          tr.startofpacket.push_back( 1'b0 );
          tr.endofpacket.push_back( 1'b0 );
        end

      tr.valid[0]         = 1'b0;
      tr.startofpacket[$] = 1'b1;
      tr.endofpacket[0]   = 1'b1;
      tr.wait_dut_ready   = 1'b1;

      generated_transactions.put(tr);

      // Transactions with length and empty progression
      for ( int i = 2; i < WORK_TR_LEN*4; i++ )
        begin
          tr     = new();
          tr.len = i;

          repeat(i)
            begin
              tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );

              tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
              tr.empty.push_back( i );
              tr.valid.push_back( 1'b1 );
              tr.ready.push_back( 1'b1 );
              tr.startofpacket.push_back( 1'b0 );
              tr.endofpacket.push_back( 1'b0 );
            end

          tr.startofpacket[$] = 1'b1;
          tr.endofpacket[0]   = 1'b1;
          tr.wait_dut_ready   = 1'b1;

          generated_transactions.put(tr);
        end

    endtask 
    
  endclass

  class Driver #( DATA_W = 1, EMPTY_W = 1 );
  // This class will drive all dut input signals
  // according to transaction's parameters

    virtual ast_interface #( DATA_W, EMPTY_W, CHANNEL_W ) vif;

    function new( input virtual ast_interface #( DATA_W, EMPTY_W, CHANNEL_W ) dut_interface );

      vif = dut_interface;

    endfunction

    task drive_in( input Transaction tr );

      int wr_timeout;
      wr_timeout = 0;

      repeat(tr.len)
        begin
          while ( tr.wait_dut_ready && vif.ast_ready !== 1'b1 && wr_timeout++ < DR_TIMEOUT )
            begin
              @( posedge vif.clk );
            end

          @( posedge vif.clk );
          wr_timeout             = 0;

          vif.ast_channel       <= tr.channel.pop_back();      
          vif.ast_empty         <= tr.empty.pop_back();        
          vif.ast_valid         <= tr.valid.pop_back();              
          vif.ast_startofpacket <= tr.startofpacket.pop_back();
          vif.ast_endofpacket   <= tr.endofpacket.pop_back();  
          vif.ast_data          <= tr.data.pop_back();
        end

      // This loop will finish transaction if end of transaction and ready_o doesn't met
      while ( vif.ast_ready !== 1'b1 && wr_timeout++ < DR_TIMEOUT )
        begin
          @( posedge vif.clk );
        end

      flush_in();

    endtask

    task drive_out( input Transaction tr );

      repeat(tr.len)
        begin
          @( posedge vif.clk );
          vif.ast_ready <= tr.ready.pop_back();
        end

      vif.ast_ready <= 1'b1;

    endtask

    task flush_in;

      @( posedge vif.clk );
      vif.ast_channel       <= '0;
      vif.ast_empty         <= 1'b0;
      vif.ast_valid         <= 1'b0;
      vif.ast_startofpacket <= 1'b0;
      vif.ast_endofpacket   <= 1'b0;
      vif.ast_data          <= '0;

    endtask

    task flush_out;

      @( posedge vif.clk );
      vif.ast_ready <= 1'b0;

    endtask
  
  endclass
  
  class Monitor #( DATA_W = 1, EMPTY_W = 1 );
  // This class will gather both input and output data from dut
  // and send it to Scoreboard

     virtual ast_interface #( DATA_W, EMPTY_W, CHANNEL_W ) vif;
     mailbox #( byte_data_t )                              input_data;
     mailbox #( logic [CHANNEL_W - 1:0] )                  channel_mbx;

    function new ( input virtual ast_interface #( DATA_W, EMPTY_W, CHANNEL_W ) dut_interface,
                   mailbox #( byte_data_t )                                    mbx_data,
                   mailbox #( logic [CHANNEL_W - 1:0] )                        in_ch
                 );

      vif         = dut_interface;
      input_data  = mbx_data;
      channel_mbx = in_ch;

    endfunction

    task run;

      get_data();

    endtask

    task get_data;

      byte_data_t             data;
      int                     start_of_packet_flag;
      int                     timeout_ctr;
      logic [CHANNEL_W - 1:0] channel;

      start_of_packet_flag = 0;
      data                 = {}; 
      timeout_ctr          = 0;

      while ( timeout_ctr++ < TIMEOUT )
        begin
          @( posedge vif.clk );

          if ( vif.ast_startofpacket === 1'b1 && vif.ast_valid == 1'b1 && vif.ast_ready === 1'b1 )
            begin
              if ( start_of_packet_flag == 1 )
                data = {};
              else
                begin
                  channel = vif.ast_channel;
                  channel_mbx.put(channel);
                end
              start_of_packet_flag = 1;
            end
          if ( vif.srst === 1'b1 )
            break;
            
          if ( vif.ast_valid === 1'b1 && vif.ast_ready === 1'b1 && start_of_packet_flag )
            begin
              // Transaction without errors can be finished only when endofpacket raised
              if ( vif.ast_endofpacket === 1'b1 )
                begin
                  timeout_ctr = 0;

                  for ( int i = 0; i < 2**EMPTY_W - vif.ast_empty; i++ )
                    begin
                      data.push_back( vif.ast_data[i*8 +: 8] );
                    end

                  input_data.put(data);
                  return;
                end
              else
                begin
                  timeout_ctr = 0;

                  for ( int i = 0; i < 2**EMPTY_W; i++ )
                    begin
                      data.push_back( vif.ast_data[i*8 +: 8] );
                    end
                end
            end
        end
      
      data.push_back( 'x );
      input_data.put(data);

    endtask
  
  endclass
  
  class Scoreboard;
  // This class will compare read and written data

    mailbox #( byte_data_t )             input_data;
    mailbox #( byte_data_t )             output_data;
    mailbox #( logic [CHANNEL_W - 1:0] ) input_channel;
    mailbox #( logic [CHANNEL_W - 1:0] ) output_channel;

    function new ( mailbox #( byte_data_t )             in_data,
                   mailbox #( byte_data_t )             out_data,
                   mailbox #( logic [CHANNEL_W - 1:0] ) in_ch,
                   mailbox #( logic [CHANNEL_W - 1:0] ) out_ch
                 );

      input_data     = in_data;
      output_data    = out_data;
      input_channel  = in_ch;
      output_channel = out_ch;

    endfunction

    task run;

      byte_data_t             in_data;
      byte_data_t             out_data;
      logic [CHANNEL_W - 1:0] in_channel;
      logic [CHANNEL_W - 1:0] out_channel;

      if ( input_channel.num() != output_channel.num() )
        $error("Error in read channels amount:rd%d, wr%d", output_channel.num(), input_channel.num() );
      else 
        begin
          while ( input_channel.num() && output_channel.num() )
            begin
              input_channel.get(in_channel);
              output_channel.get(out_channel);

              if ( in_channel !== out_channel )
                $error("Read and written channels not equal:rd%d, wr%d", out_channel, in_channel);
            end
        end

      if ( input_data.num() !== output_data.num() )
        $error( "Number of read and written transactions doesn't equal, wr:%d, rd:%d", input_data.num(), output_data.num() );

      while ( input_data.num() && output_data.num() )
        begin
          input_data.get(in_data);
          output_data.get(out_data);
          
          if ( in_data.size() != out_data.size() )
            begin
              $error( "data sizes dont match!: wr size:%d, rd size:%d ", in_data.size(), out_data.size() );
              $displayh( "wr data:%p", in_data[$ -: WORK_TR_LEN] );
              $displayh( "rd data:%p", out_data[$ -: WORK_TR_LEN] );
            end
          else
            begin
              foreach( in_data[i] )
                begin
                  if ( in_data[i] === 'x || out_data[i] === 'x && in_data[i] !== out_data[i] )
                    begin
                      $error("Error during transaction!! Wrong control signals values");
                      $displayh( "wr data:%p", in_data[$ -: WORK_TR_LEN] );
                      $displayh( "rd data:%p", out_data[$ -: WORK_TR_LEN] );
                      $display( "Index: %d", i );
                      break;
                    end
                  if ( in_data[i] !== out_data[i] )
                    begin
                      $error( "wrong data!" );
                      $displayh( "wr data:%p", in_data[$ -: WORK_TR_LEN] );
                      $displayh( "rd data:%p", out_data[$ -: WORK_TR_LEN] );
                      $display( "Index: %d", i );
                      break;
                    end
                end
            end
        end

    endtask

  endclass

  class Environment;
  // This class will hold all tb elements together
    
    Driver #( DATA_IN_W, EMPTY_IN_W )                             in_driver;
    Driver #( DATA_OUT_W, EMPTY_OUT_W )                           out_driver;
    Monitor #( DATA_IN_W, EMPTY_IN_W )                            in_monitor;
    Monitor #( DATA_OUT_W, EMPTY_OUT_W )                          out_monitor;
    Scoreboard                                                    scoreboard;
    Generator                                                     generator;

    mailbox #( Transaction )                                      generated_transactions;
    mailbox #( byte_data_t )                                      input_data;
    mailbox #( byte_data_t )                                      output_data;

    mailbox #( logic [CHANNEL_W - 1:0] )                          in_channel;
    mailbox #( logic [CHANNEL_W - 1:0] )                          out_channel;

    virtual ast_interface #( DATA_IN_W, EMPTY_IN_W, CHANNEL_W )   i_vif;
    virtual ast_interface #( DATA_OUT_W, EMPTY_OUT_W, CHANNEL_W ) o_vif;

    function new( input virtual ast_interface #( DATA_IN_W, EMPTY_IN_W, CHANNEL_W )   in_dut_interface,
                  input virtual ast_interface #( DATA_OUT_W, EMPTY_OUT_W, CHANNEL_W ) out_dut_interface
                );

      generated_transactions = new();
      input_data             = new();
      output_data            = new();
      in_channel             = new();
      out_channel            = new();

      i_vif                  = in_dut_interface;
      o_vif                  = out_dut_interface;
      in_driver              = new( i_vif );
      out_driver             = new( o_vif );
      in_monitor             = new( i_vif, input_data, in_channel );
      out_monitor            = new( o_vif, output_data, out_channel );
      scoreboard             = new( input_data, output_data, in_channel, out_channel );
      generator              = new( generated_transactions );
      
    endfunction
    
    task run;

      Transaction tr;
    
      generator.run();

      in_driver.flush_in();
      out_driver.flush_out();
  
      @( posedge i_vif.clk );
      
      while ( generated_transactions.num() )
        begin
          generated_transactions.get(tr);

          fork 
            in_driver.drive_in(tr);
            out_driver.drive_out(tr);
            in_monitor.run();
            out_monitor.run();
          join

          scoreboard.run();
        end
        
    endtask
  
  endclass

endpackage