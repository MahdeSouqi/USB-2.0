module crc_16_tb();

reg	    clk_c;			
reg	    reset;			
reg	    halt_tx;		
reg	    cwe_z;			
reg	    chck_enbl;		
reg	    data_in;		
wire	data_out;		
wire	error;			
wire	[15:0] int_data;	

crc_16 dut(clk_c,reset,halt_tx,cwe_z,chck_enbl,data_in,data_out,error,int_data);

always
    #5 clk_c = ~ clk_c;

initial begin
    $dumpfile("dump.vcd");$dumpvars;
    clk_c = 0;
    reset = 1;
    halt_tx = 0;
    cwe_z = 0;
    chck_enbl = 0;
    data_in = 0;

    #10 reset = 0;

    repeat(16)
    @(posedge clk_c) data_in = ~ data_in;

    cwe_z = 1;
    repeat(16)
    @(posedge clk_c) data_in = 0;

    repeat(16)
    @(posedge clk_c) data_in = 1;

    chck_enbl = 1;
    #30;
    chck_enbl = 0;

    repeat(8)
    @(posedge clk_c) data_in = 0;
    halt_tx = 1;
    #30 halt_tx = 0;
    repeat(8)
    @(posedge clk_c) data_in = 1;

    #10;
    cwe_z <= 0;

    #200 $finish;
end

endmodule