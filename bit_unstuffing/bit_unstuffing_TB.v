// Code your testbench here
// or browse Examples
module bit_unstuff_tb;
  
  
reg gclk;               	
reg reset_l;              	
reg unstuff_din;		
reg  cs2_l;
 
wire cs2_out_l;
wire halt_rx_shift;		
wire unstuff_dout;		
wire [8:0]  qualify_out;

  bit_unstuff uut(.gclk(gclk), .reset_l(reset_l), .unstuff_din(unstuff_din), .halt_rx_shift(halt_rx_shift),.unstuff_dout(unstuff_dout), .cs2_l(cs2_l),.cs2_out_l(cs2_out_l),.idle_or_sync(),.pid(),.dev_address(),.end_point_address(),.crc5(),.frame_number(),.data_crc_eop() ,.error(),.eop(),.qualify_out(qualify_out));
  
 always #5 gclk = ~gclk;

  
  initial 
    begin
    $dumpfile("dump.vcd"); $dumpvars;
    gclk = 0;
    reset_l = 1;
    cs2_l = 1;
    unstuff_din = 0; 
    repeat(6) begin//enter 6 ones 
        @(posedge gclk) unstuff_din = 1;
    end
    @(posedge gclk)unstuff_din = 0;// enter a zero to check if it going to raise the halt flag
    repeat(6) begin
        @(posedge gclk)unstuff_din = 1;
    end
    @(posedge gclk)unstuff_din = 0;
   repeat(3) begin// enter ones after 6 ones to check if it gonig to recount from zeor or not
        @(posedge gclk)unstuff_din = 1;
    end
    repeat(2) begin
        @(posedge gclk)unstuff_din = 0;
    end
    repeat(5) begin
        @(posedge gclk)unstuff_din = 1;
    end
    
    #10 reset_l = 0;// check reset
	#10 reset_l = 1;

    repeat(3) begin
        @(posedge gclk) unstuff_din = 0;
    end
    repeat(3) begin
        @(posedge gclk) unstuff_din = 1;
    end

    repeat(10) begin//random data
        @(posedge gclk) unstuff_din = ~ unstuff_din;
    end
    #10 cs2_l = 0; // check the clear
	#10 cs2_l = 1;
    repeat(6) begin
        @(posedge gclk) unstuff_din = 1;
    end
    @(posedge gclk)unstuff_din = 0;
    repeat(6) begin
        @(posedge gclk)unstuff_din = 1;
    end
    @(posedge gclk)unstuff_din = 0;

    #200;
    $finish;
    end
  
endmodule