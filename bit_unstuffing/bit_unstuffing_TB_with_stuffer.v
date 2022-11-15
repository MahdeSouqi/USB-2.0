// Code your testbench here
// or browse Examples
module bit_unstuff_tb;
  
  
              	
           	
reg unstuff_din;		
reg  cs2_l;
 
wire cs2_out_l;
wire halt_rx_shift;		
wire unstuff_dout;		
wire [8:0]  qualify_out;

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

bit_unstuff uut(.gclk(gclk), .reset_l(reset_l), .unstuff_din(stuff_dout), .halt_rx_shift(halt_rx_shift),.unstuff_dout(unstuff_dout), .cs2_l(cs2_l),.cs2_out_l(cs2_out_l),.idle_or_sync(),.pid(),.dev_address(),.end_point_address(),.crc5(),.frame_number(),.data_crc_eop() ,.error(),.eop(),.qualify_out(qualify_out));
  


always #5 gclk = ~gclk;

  
initial 
begin
    $dumpfile("dump.vcd"); $dumpvars;
    cs2_l = 1;
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