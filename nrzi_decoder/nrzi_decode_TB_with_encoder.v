
module nrzi_decoder_tb();

reg gclk; 
reg reset_l;
reg start_rxd; 
reg idle_or_sync; 
reg pid; 
reg dev_address; 
reg end_point_address; 
reg crc5;
reg frame_number; 
reg data_crc_eop;
reg eop; 
reg error;

reg start_txd;
reg tx_data_in; 

wire tx_data_out;
wire tx_data_valid;

wire rx_data_out; 
wire rx_data_valid;
wire idle_or_sync_n; 
wire pid_n; 
wire dev_address_n; 
wire end_point_address_n; 
wire crc5_n;
wire frame_number_n;
wire data_crc_eop_n; 
wire eop_n; 
wire error_n;
  

nrzi_decode_ap dut(
rx_data_out, 
gclk, 
reset_l, 
start_rxd, 
tx_data_out, 
rx_data_valid,
idle_or_sync_n, 
pid_n, dev_address_n, 
end_point_address_n, 
crc5_n,
frame_number_n, 
data_crc_eop_n, 
eop_n, 
error_n,
idle_or_sync, 
pid, 
dev_address, 
end_point_address, 
crc5,
frame_number, 
data_crc_eop, 
eop, 
error);

nrzi_encode_ap dut_en(
gclk,
reset_l,
start_txd,
tx_data_in, 
tx_data_out, 
tx_data_valid);

always
    #5 gclk = ~ gclk;


initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    gclk = 0;
    reset_l = 1;
    start_rxd = 0;
    #10;
    @(posedge gclk) start_rxd = 1;

    start_txd =0;
    #10;
    @(posedge gclk) start_txd =1;// start encoding

    @(posedge gclk) tx_data_in = 0; // check if it will flip at 0 input
    #50;
    @(posedge gclk) tx_data_in = 1;// check if it will not flip at 1 input
    #20;
    @(posedge gclk) tx_data_in = 0;// check if it will flip at 0 input
    @(posedge gclk) tx_data_in = 1;
    #50;
    @(posedge gclk) tx_data_in = 0;
    #50;
    reset_l = 0;//check the rest
    #10 reset_l = 1;
    @(posedge gclk) tx_data_in = 1;
    #50;
    @(posedge gclk) tx_data_in = 0;//keep it 0 and check if it keep changing 
    #200; $finish;
end    


endmodule
