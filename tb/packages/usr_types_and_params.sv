package usr_types_and_params;
  
  parameter DATA_IN_W                 = 64;
  parameter DATA_OUT_W                = 256;
  parameter CHANNEL_W                 = 10;
  parameter EMPTY_IN_W                = $clog2(DATA_IN_W/8) ? $clog2(DATA_IN_W/8) : 1;
  parameter EMPTY_OUT_W               = $clog2(DATA_OUT_W/8) ? $clog2(DATA_OUT_W/8) : 1;

  parameter NUMBER_OF_TEST_RUNS       = 2;
  parameter MAX_TR_LEN                = 1024;
  parameter WORK_TR_LEN               = 10;
  parameter TIMEOUT                   = WORK_TR_LEN * 3;
  parameter DR_TIMEOUT                = WORK_TR_LEN;
  parameter MAX_DATA_VALUE            = 2**DATA_IN_W - 1;
  parameter NUMBER_OF_ONE_LENGHT_RUNS = 1;

  typedef logic [DATA_IN_W - 1:0]   in_data_t[$];
  typedef logic [DATA_OUT_W - 1:0]  out_data_t[$];
  typedef int                       delays_t[$];
  typedef logic [CHANNEL_W - 1:0]   channel_t;
  typedef logic [EMPTY_IN_W - 1:0]  empty_in_t;
  typedef logic [EMPTY_OUT_W - 1:0] empty_out_t;
  typedef logic [7:0]               byte_data_t[$];
  
  typedef bit                       queued_bits_t[$];

endpackage