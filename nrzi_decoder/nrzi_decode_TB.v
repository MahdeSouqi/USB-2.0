module nrzi_decoder_tb();

reg gclk; 
reg reset_l;
reg start_rxd; 
reg rx_data_in;
reg idle_or_sync; 
reg pid; 
reg dev_address; 
reg end_point_address; 
reg crc5;
reg frame_number; 
reg data_crc_eop;
reg eop; 
reg error;

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
rx_data_in, 
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

always
    #5 gclk = ~ gclk;


initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    gclk = 0;
    reset_l = 1;
    rx_data_in = 0;
    start_rxd = 0;
    #10;
    @(posedge gclk) start_rxd = 1; // start decoding

    @(posedge gclk) rx_data_in = 1; // check if it flip when it change from 0 to 1 
    #50;
    @(posedge gclk) rx_data_in = 0; // check if it flip when it change from 1 to 0
    #50;
    @(posedge gclk) rx_data_in = 1; // check if it flip when it change from 0 to 1
    #50;
    reset_l = 0; // check the reset
    #10 reset_l = 1; 
    repeat(20) // randome check
    @(posedge gclk) rx_data_in = ~rx_data_in;

    #200 $finish; 
end    


endmodule
