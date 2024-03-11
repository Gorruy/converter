package tb_env;

  import usr_types_and_params::*;
  
  class Transaction;

    in_data_t   in_data;
    int         len;
    delays_t    ready_i_delays;
    delays_t    valid_i_delays;
    channel_t   channel;
    string      message;
    int         time_of_start;
    empty_in_t  empty_in;
    
  endclass
  
  class Generator;

    mailbox #( Transaction ) generated_transactions;

    function new( mailbox #( Transaction ) gen_tr );

      generated_transactions = gen_tr;

    endfunction

    task run;

      Transaction tr;
      
      // tr = new;
      // // Random transactions without empty symbols
      // repeat (NUMBER_OF_TEST_RUNS)
      //   begin
      //     tr.message = "Transaction with random parameters";
      //     tr.len     = $urandom_range( MAX_TR_LEN, 1 );
      //     tr.channel = $urandom_range( 2**CHANNEL_W, 0 );
      //     repeat(tr.len)
      //       begin
      //         tr.ready_i_delays.push_back( $urandom_range( MAX_DELAY, MIN_DELAY ) );
      //         tr.valid_i_delays.push_back( $urandom_range( MAX_DELAY, MIN_DELAY ) );
      //         tr.in_data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
      //       end

      //     generated_transactions.put(tr);
      //   end

      tr         = new();
      tr.message = "Transactions of length one started";
      // Many transactions of length one
      repeat (NUMBER_OF_ONE_LENGHT_RUNS)
        begin
          tr.len      = 1;
          tr.channel  = $urandom_range( 2**CHANNEL_W, 0 );
          tr.empty_in = '0;
          tr.ready_i_delays.push_back(0);
          tr.valid_i_delays.push_back(0);
          tr.in_data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );

          generated_transactions.put(tr);
          tr         = new();
          tr.message = "another one length transaction";
        end

      // generates configurations with ones or witout any delays without empty symbols
      for ( int wr_delay = 0; wr_delay <= 1; wr_delay++ )
        begin
          for ( int rd_delay = 0; rd_delay <= 1; rd_delay++ )
            begin
              tr          = new();
              tr.len      = MAX_TR_LEN;
              tr.channel  = '0;
              tr.empty_in = '0;
              repeat(tr.len)
                begin
                  tr.valid_i_delays.push_back(wr_delay);
                  tr.ready_i_delays.push_back(rd_delay);
                  tr.in_data.push_back( $urandom_range( MAX_DATA_VALUE, 0 ) );
                end
              
              tr.message = { wr_delay == 0 ? "Write without delay and ": "Writing with delay of one clk cycle ",
                             rd_delay == 0 ? "read without delay": "reading with delay of one clk cycle"  };
              generated_transactions.put(tr);
            end
        end

    endtask 
    
  endclass

  class Driver;

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
          tr.time_of_start = $time();
          $display(tr.message);

          if (tr.len != 1)
            reset();

          fork
            write(tr);
            read(tr);
          join

        end

    endtask

    task write ( input Transaction tr );

      repeat( tr.valid_i_delays.pop_back() )
        begin
          @( posedge vif.clk );
        end

      vif.ast_data_i          = tr.in_data.pop_back();
      vif.ast_startofpacket_i = 1'b1;
      vif.ast_valid_i         = 1'b1;

      while ( tr.in_data.size() > 0 )
        begin
          @( posedge vif.clk );

          if ( vif.ast_ready_o !== 1'b1 )
            continue;
          else
            begin
              vif.ast_startofpacket_i = 1'b0;
              repeat( tr.valid_i_delays.pop_back() )
                begin
                  @( posedge vif.clk );
                end
              vif.ast_data_i  = tr.in_data.pop_back();
              vif.ast_valid_i = 1'b1;
            end
        end
      
      vif.ast_endofpacket_i = 1'b1;
      vif.ast_empty_i       = tr.empty_in;
      @( posedge vif.clk );
      vif.ast_endofpacket_i = 1'b0;
      vif.ast_valid_i       = 1'b0;

    endtask

    task read ( input Transaction tr );

      int start_of_packet_flag;
      int read_timeout;

      read_timeout         = 0;
      start_of_packet_flag = 0;
      
      vif.ast_ready_i = 1'b1;

      while (1)
        begin
          if ( read_timeout == READ_TIMEOUT )
            return;
          if ( vif.ast_startofpacket_o === 1'b1 )
            begin
              start_of_packet_flag = 1;
            end
          @( posedge vif.clk );

          if ( vif.ast_valid_o === 1'b1 && start_of_packet_flag )
            begin
              vif.ast_ready_i = 1'b0;
              repeat(tr.ready_i_delays.pop_back())
                begin
                  @( posedge vif.clk );
                end
              vif.ast_ready_i = 1'b1;
            end

          if ( vif.ast_endofpacket_o === 1'b1 )
            return;
          else
            read_timeout += 1;

        end

    endtask

    task reset;
      @( posedge vif.clk );
      vif.srst_i = 1'b1;
      @( posedge vif.clk );
      vif.srst_i = 1'b0;
    endtask
  
  endclass
  
  class Monitor;

    virtual ast_interface    vif;

    mailbox #( symb_data_t ) input_data;
    mailbox #( symb_data_t ) output_data;

    int                      timeout;

    function new ( input virtual ast_interface dut_interface,
                   mailbox #( symb_data_t )    in_data,
                   mailbox #( symb_data_t )    out_data 
                 );

      vif         = dut_interface;
      input_data  = in_data;
      output_data = out_data;
      timeout     = 0;

    endfunction

    task run;

    int c;

      while ( timeout < TIMEOUT )
        begin
          fork
            get_input_data();
            get_output_data();
          join
        end

    endtask

    task get_input_data;

      symb_data_t data;
      data = {}; 

      while ( ( vif.ast_startofpacket_i !== 1'b1 || vif.srst_i === 1'b1 ) &&
                timeout++ < TIMEOUT )
        @( posedge vif.clk );

      while ( vif.srst_i !== 1'b1 && timeout++ < TIMEOUT )
        begin
          @( posedge vif.clk );

          if ( vif.ast_endofpacket_i === 1'b1 )
            begin
              timeout = 0;

              for ( int i = 0; i <= 2**EMPTY_IN_W - vif.ast_empty_i; i++ )
                begin
                  data.push_back( vif.ast_data_i[i*8 +: 8] );
                end

              input_data.put(data);
              return;
            end
          else if ( vif.ast_valid_o === 1'b1 && vif.ast_ready_i === 1'b1 )
            begin
              timeout = 0;

              for ( int i = 0; i < 2**EMPTY_IN_W; i++ )
                begin
                  data.push_back( vif.ast_data_i[i*8 +: 8] );
                end
            end
        end

    endtask

    task get_output_data;

      symb_data_t data;
      data = {};

      while ( ( vif.ast_startofpacket_o !== 1'b1 || vif.srst_i === 1'b1 ) &&
                timeout++ < TIMEOUT )
        @( posedge vif.clk );

      while ( vif.srst_i !== 1'b1 && timeout++ < TIMEOUT )
        begin
          @( posedge vif.clk );

          if ( vif.ast_endofpacket_o === 1'b1 )
            begin
              timeout = 0;

              for ( int i = 0; i <= 2**EMPTY_OUT_W - vif.ast_empty_o; i++ )
                begin
                  data.push_back( vif.ast_data_o[i*8 +: 8] );
                end

              output_data.put(data);
              return;
            end
          else if ( vif.ast_valid_i === 1'b1 && vif.ast_ready_o === 1'b1 )
            begin
              timeout = 0;

              for ( int i = 0; i < 2**EMPTY_OUT_W; i++ )
                begin
                  data.push_back( vif.ast_data_o[i*8 +: 8] );
                end
            end  
        end

    endtask
  
  endclass
  
  class Scoreboard;

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

      while ( input_data.num() )
        begin
          input_data.get(in_data);
          output_data.get(out_data);

          if ( in_data.size() != out_data.size() )
            begin
              $error("data sizes dont match!: wr size:%d, rd size:%d ",in_data.size(), out_data.size() );
              $displayh("wr data:%p, rd data:%p", in_data, out_data );
            end
          else
            begin
              while ( in_data.size() )
                begin
                  if ( in_data.pop_back() != out_data.pop_back() )
                    $error("wrong data");
                end
            end
        end

    endtask

  endclass

  class Environment;
    
    Driver     driver;
    Monitor    monitor;
    Scoreboard scoreboard;
    Generator  generator;

    mailbox #( Transaction ) generated_transactions;
    mailbox #( symb_data_t ) input_data;
    mailbox #( symb_data_t ) output_data;

    virtual ast_interface    vif;

    function new( input virtual ast_interface dut_interface );

      generated_transactions = new;
      input_data             = new;
      output_data            = new;

      vif                    = dut_interface;
      driver                 = new( vif, generated_transactions );
      monitor                = new( vif, input_data, output_data );
      scoreboard             = new( input_data, output_data );
      generator              = new( generated_transactions );
      
    endfunction
    
    task run;
    
      generator.run();
  
      fork 
        driver.run();
        monitor.run();
      join

      scoreboard.run();
        
    endtask
  
  endclass

endpackage