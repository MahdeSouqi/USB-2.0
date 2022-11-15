module nrzi_encoder_TB();

reg gclk;
reg reset_l;
reg start_txd;
reg tx_data_in; 
wire tx_data_out;
wire tx_data_valid;

nrzi_encode_ap dut(
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
