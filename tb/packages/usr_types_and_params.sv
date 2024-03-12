package usr_types_and_params;
  
  parameter DATA_IN_W                 = 64;
  parameter DATA_OUT_W                = 128;
  parameter CHANNEL_W                 = 10;
  parameter EMPTY_IN_W                = $clog2(DATA_IN_W/8) ? $clog2(DATA_IN_W/8) : 1;
  parameter EMPTY_OUT_W               = $clog2(DATA_OUT_W/8) ? $clog2(DATA_OUT_W/8) : 1;

  parameter NUMBER_OF_TEST_RUNS       = 10;
  parameter MAX_DELAY                 = 10;
  parameter MIN_DELAY                 = 0;
  parameter MAX_TR_LEN                = 10;
  parameter TIMEOUT                   = MAX_TR_LEN * MAX_DELAY * 3;
  parameter DR_TIMEOUT                = MAX_TR_LEN * MAX_DELAY;
  parameter MAX_DATA_VALUE            = 2**DATA_IN_W - 1;
  parameter NUMBER_OF_ONE_LENGHT_RUNS = 5;

  typedef logic [DATA_IN_W - 1:0]   in_data_t[$];
  typedef logic [DATA_OUT_W - 1:0]  out_data_t[$];
  typedef int                       delays_t[$];
  typedef logic [CHANNEL_W - 1:0]   channel_t;
  typedef logic [EMPTY_IN_W - 1:0]  empty_in_t;
  typedef logic [EMPTY_OUT_W - 1:0] empty_out_t;
  typedef logic [7:0]               symb_data_t[$];
  
  typedef bit                       queued_bits_t[$];

endpackage