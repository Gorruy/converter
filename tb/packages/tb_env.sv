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

      // Transactions of max length with random valid
      repeat (NUMBER_OF_TEST_RUNS)
        begin
          tr     = new();
          tr.len = MAX_TR_LEN ;

          repeat(MAX_TR_LEN)
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
          tr.len = MAX_TR_LEN ;

          repeat(MAX_TR_LEN)
            begin
              tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
    
              tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
              tr.empty.push_back( $urandom_range( 2**EMPTY_IN_W, 0 ) );
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

      // Transaction with random values of startofpacket 
      tr     = new();
      tr.len = MAX_TR_LEN;

      repeat(MAX_TR_LEN)
        begin
          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( $urandom_range( 2**EMPTY_IN_W, 0 ) );
          tr.valid.push_back( $urandom_range( 1, 0 ) );
          tr.ready.push_back( $urandom_range( 1, 0 ) );
          tr.startofpacket.push_back( $urandom_range( 1, 0 ) );
          tr.endofpacket.push_back( 1'b0 );
        end
      tr.startofpacket[$] = 1'b1;
      tr.endofpacket[0]   = 1'b1;
      tr.valid[$]         = 1'b1;
      tr.valid[0]         = 1'b1;
      tr.ready[0]         = 1'b1;
      tr.wait_dut_ready   = 1'b0;

      generated_transactions.put(tr);

      // Transaction with random values of endofpacket 
      tr     = new();
      tr.len = MAX_TR_LEN;

      repeat(MAX_TR_LEN)
        begin
          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
    
          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( $urandom_range( 2**EMPTY_IN_W, 0 ) );
          tr.valid.push_back( $urandom_range( 1, 0 ) );
          tr.ready.push_back( $urandom_range( 1, 0 ) );
          tr.startofpacket.push_back( 0 );
          tr.endofpacket.push_back( $urandom_range( 1, 0 ) );
        end
      tr.startofpacket[$] = 1'b1;
      tr.endofpacket[0]   = 1'b1;
      tr.valid[$]         = 1'b1;
      tr.valid[0]         = 1'b1;
      tr.ready[0]         = 1'b1;
      tr.wait_dut_ready   = 1'b0;

      generated_transactions.put(tr);

      // Transactions of max length with random ready
      repeat (NUMBER_OF_TEST_RUNS)
        begin
          tr     = new();
          tr.len = MAX_TR_LEN ;

          repeat(MAX_TR_LEN)
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
          tr.ready[0]         = 1'b1;
          tr.wait_dut_ready   = 1'b0;

          generated_transactions.put(tr);
        end

      // Trancastions of length one
      repeat ( NUMBER_OF_ONE_LENGHT_RUNS )
        begin
          tr     = new();
          tr.len = 1;

          tr.data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
          tr.channel.push_back( $urandom_range( 2**CHANNEL_W, 0 ) );
          tr.empty.push_back( $urandom_range( 2**EMPTY_IN_W, 0 ) );
          tr.valid.push_back( 1'b1 );
          tr.ready.push_back( 1'b1 );
          tr.startofpacket.push_back( 1'b1 );
          tr.endofpacket.push_back( 1'b1 );

          tr.wait_dut_ready = 1'b0;

          generated_transactions.put(tr);
        end

    endtask 
    
  endclass

  class Driver;
  // This class will drive all dut input signals
  // according to transaction's parameters

    virtual ast_interface    vif;
    mailbox #( Transaction ) generated_transactions;

    function new( input virtual ast_interface dut_interface,
                  mailbox #( Transaction )    gen_tr 
                );

      vif                    = dut_interface;
      generated_transactions = gen_tr;

    endfunction

    task run;

      Transaction tr;

      while ( generated_transactions.num() )
        begin
          generated_transactions.get(tr);

          write(tr);
        end

      fin();

    endtask

    task write ( input Transaction tr );

      int wr_timeout;
      wr_timeout = 0;

      repeat(tr.len)
        begin
          while ( tr.wait_dut_ready && vif.ast_ready_o !== 1'b1 && wr_timeout++ < DR_TIMEOUT )
            begin
              @( posedge vif.clk );
            end

          @( posedge vif.clk );
          wr_timeout               = 0;

          vif.ast_channel_i       <= tr.channel.pop_back();      
          vif.ast_empty_i         <= tr.empty.pop_back();        
          vif.ast_valid_i         <= tr.valid.pop_back();        
          vif.ast_ready_i         <= tr.ready.pop_back();        
          vif.ast_startofpacket_i <= tr.startofpacket.pop_back();
          vif.ast_endofpacket_i   <= tr.endofpacket.pop_back();  
          vif.ast_data_i          <= tr.data.pop_back();
        end

      // This loop will finish transaction if end of transaction and ready_o doesn't met
      while ( vif.ast_ready_o !== 1'b1 && wr_timeout++ < DR_TIMEOUT )
        @( posedge vif.clk );

    endtask

    task fin;
    // Transactions from write task doesn't imply completing of reading
    // This task will hold ready_i signal to finish transactions

      int finishing_timeout;

      finishing_timeout = 0;

      @( posedge vif.clk );
      vif.ast_ready_i = 1'b1;
      @( posedge vif.clk );

      while ( vif.ast_valid_o === 1'b1 && finishing_timeout++ < DR_TIMEOUT )
        begin
          @( posedge vif.clk );
        end

      vif.ast_channel_i       <= '0;
      vif.ast_empty_i         <= '0;
      vif.ast_valid_i         <= 1'b0;
      vif.ast_ready_i         <= 1'b0;
      vif.ast_startofpacket_i <= 1'b0;
      vif.ast_endofpacket_i   <= 1'b0;
      vif.ast_data_i          <= '0;

    endtask

    task reset;
      @( posedge vif.clk );
      vif.srst_i <= 1'b1;
      @( posedge vif.clk );
      vif.srst_i <= 1'b0;
    endtask
  
  endclass
  
  class Monitor;
  // This class will gather both input and output data from dut
  // and send it to Scoreboard

    virtual ast_interface    vif;

    mailbox #( symb_data_t ) input_data;
    mailbox #( symb_data_t ) output_data;

    int                      timeout_ctr;

    function new ( input virtual ast_interface dut_interface,
                   mailbox #( symb_data_t )    in_data,
                   mailbox #( symb_data_t )    out_data 
                 );

      vif         = dut_interface;
      input_data  = in_data;
      output_data = out_data;
      timeout_ctr = 0;

    endfunction

    task run;
      
      fork
        get_input_data();
        get_output_data();
      join

    endtask

    task get_input_data;

      symb_data_t data;
      int         start_of_packet_flag;

      start_of_packet_flag = 0;
      data                 = {}; 

      while ( timeout_ctr++ < TIMEOUT )
        begin
          @( posedge vif.clk );

          if ( vif.ast_startofpacket_i === 1'b1 && vif.ast_valid_i == 1'b1 && vif.ast_ready_o === 1'b1 )
            start_of_packet_flag = 1;
          if ( vif.srst_i === 1'b1 )
            begin
              timeout_ctr = 0;
              continue;
            end
            
          if ( vif.ast_valid_i === 1'b1 && vif.ast_ready_o === 1'b1 && start_of_packet_flag )
            begin
              // Transaction without errors can be finished only with endofpacket raised
              if ( vif.ast_endofpacket_i === 1'b1 )
                begin
                  timeout_ctr = 0;

                  for ( int i = 0; i < 2**EMPTY_IN_W - vif.ast_empty_i; i++ )
                    begin
                      data.push_back( vif.ast_data_i[i*8 +: 8] );
                    end

                  input_data.put(data);
                  start_of_packet_flag = 0;
                  data                 = {}; 
                  continue;
                end
              else
                begin
                  timeout_ctr = 0;

                  for ( int i = 0; i < 2**EMPTY_IN_W; i++ )
                    begin
                      data.push_back( vif.ast_data_i[i*8 +: 8] );
                    end
                end
            end
        end


    endtask

    task get_output_data;

      symb_data_t data;
      int         start_of_packet_flag;

      start_of_packet_flag = 0;
      data                 = {};

      while ( timeout_ctr++ < TIMEOUT )
        begin
          @( posedge vif.clk );

          if ( vif.ast_startofpacket_o === 1'b1 && vif.ast_valid_o == 1'b1 && vif.ast_ready_i === 1'b1 )
            start_of_packet_flag = 1;
          if ( vif.srst_i === 1'b1 )
            begin
              timeout_ctr = 0;
              continue;
            end

          if ( vif.ast_valid_o === 1'b1 && vif.ast_ready_i === 1'b1 && start_of_packet_flag )
            begin
              // Valid transaction without errors can be finished only with endofpacket raised
              if ( vif.ast_endofpacket_o === 1'b1 )
                begin
                  timeout_ctr = 0;

                  for ( int i = 0; i < 2**EMPTY_OUT_W - vif.ast_empty_o; i++ )
                    begin
                      data.push_back( vif.ast_data_o[i*8 +: 8] );
                    end

                  output_data.put(data);
                  start_of_packet_flag = 0;
                  data                 = {};
                  continue;
                end
              else
                begin
                  timeout_ctr = 0;

                  for ( int i = 0; i < 2**EMPTY_OUT_W; i++ )
                    begin
                      data.push_back( vif.ast_data_o[i*8 +: 8] );
                    end
                end  
            end
        end

    endtask
  
  endclass
  
  class Scoreboard;
  // This class will compare read and written data

    mailbox #( symb_data_t ) input_data;
    mailbox #( symb_data_t ) output_data;

    function new ( mailbox #( symb_data_t ) in_data,
                   mailbox #( symb_data_t ) out_data
                 );

      input_data  = in_data;
      output_data = out_data;

    endfunction

    task run;

      symb_data_t in_data;
      symb_data_t out_data;

      if ( input_data.num() !== output_data.num() )
        $error( "Number of read and written transactions doesn't equal, wr:%d, rd:%d", input_data.num(), output_data.num() );

      while ( input_data.num() && output_data.num() )
        begin
          input_data.get(in_data);
          output_data.get(out_data);

          if ( in_data.size() != out_data.size() )
            begin
              $error( "data sizes dont match!: wr size:%d, rd size:%d ",in_data.size(), out_data.size() );
              $displayh( "wr data:%p", in_data );
              $displayh( "rd data:%p", out_data );
            end
          else
            begin
              foreach( in_data[i] )
                begin
                  if ( in_data[i] != out_data[i] )
                    begin
                      $error( "wrong data!" );
                      $displayh( "wr data:%p", in_data );
                      $displayh( "rd data:%p", out_data );
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
    
    Driver     driver;
    Monitor    monitor;
    Scoreboard scoreboard;
    Generator  generator;

    mailbox #( Transaction ) generated_transactions;
    mailbox #( symb_data_t ) input_data;
    mailbox #( symb_data_t ) output_data;

    virtual ast_interface    vif;

    function new( input virtual ast_interface dut_interface );

      generated_transactions = new();
      input_data             = new();
      output_data            = new();

      vif                    = dut_interface;
      driver                 = new( vif, generated_transactions );
      monitor                = new( vif, input_data, output_data );
      scoreboard             = new( input_data, output_data );
      generator              = new( generated_transactions );
      
    endfunction
    
    task run;
    
      generator.run();
  
      @( posedge vif.clk );
      fork 
        driver.run();
        monitor.run();
      join

      scoreboard.run();
        
    endtask
  
  endclass

endpackage