module bit_stuffing_TB();

reg gclk;
reg reset_l; 
reg start_bit_stuff;
reg stuff_din;
reg shift_tx_crc5 = 0; 
reg shift_tx_crc16 = 0; 
reg tx_crc5_out = 0; 
reg tx_crc16_out = 0; 
reg cs1_l; 
wire halt_tx_shift; 
wire stuff_dout; 
wire start_txd;


bit_stuff dut(
gclk,
reset_l, 
start_bit_stuff,
stuff_din,
shift_tx_crc5, 
shift_tx_crc16, 
tx_crc5_out, 
tx_crc16_out, 
halt_tx_shift, 
stuff_dout, 
cs1_l, 
start_txd);


always
    #5 gclk = ~ gclk;

initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    gclk = 0;
    reset_l = 1;
    cs1_l = 1;
    start_bit_stuff = 1;
    stuff_din = 0;

    repeat(8)// to check if the dut will add a "0" after 6 ones
    @(posedge gclk)stuff_din = 1;

    @(posedge gclk)stuff_din = 0;// space purposes 

    repeat(8)// to check if the dut will add a "0" after 6 ones
    @(posedge gclk)stuff_din = 1;

    #10 reset_l = 0;// check the reset
    #10 reset_l = 1;

    #30 cs1_l = 0;//check the clear signal
    #10 cs1_l = 1;

    #30 start_bit_stuff = 0;// check the the enable stuffer signal
    #10 start_bit_stuff = 1;
    #20;
    repeat(8)// check if all inputs are zeros
    @(posedge gclk)stuff_din = 0;

    repeat(20)// some random data
    @(posedge gclk)stuff_din = ~ stuff_din;

    @(posedge gclk)stuff_din = 1;// keep it one and check the stuffing 

    #200 $finish;
end

endmodule