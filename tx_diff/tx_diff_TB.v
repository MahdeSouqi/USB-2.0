module tx_diff_tb();

reg gclk;			
reg reset_l;			
reg nrzi_data;		
reg tx_data_valid;		

wire txd_pos;			
wire txd_neg;		    

tx_diff dut(
gclk, 
reset_l, 
txd_pos, 
txd_neg, 
tx_data_valid, 
nrzi_data);

always
    #5 gclk = ~gclk;

initial begin
    $dumpfile("dump.vcd");$dumpvars;
    gclk = 0;
    reset_l = 0;
    nrzi_data = 0;
    tx_data_valid = 0;

    #10 reset_l = 1;

    @(posedge gclk) tx_data_valid = 1;

    @(posedge gclk) nrzi_data = 1;
    #30;
    @(posedge gclk) nrzi_data = 0;
    #20;
    repeat(8)
    @(posedge gclk) nrzi_data = ~ nrzi_data;
    #20;
    @(posedge gclk) tx_data_valid = 0;
    #50;
    @(posedge gclk) tx_data_valid = 1;
    
    #20 $finish;
end    


endmodule