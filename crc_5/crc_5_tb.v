`timescale 1ns / 1ns

module crc_5_tb (
);


   


  reg clk_c,reset,halt_tx,cwe_z,chck_enbl,data_in;
    
  wire data_out,error;

  crc_5 crc_5_inst(clk_c,reset,halt_tx,cwe_z,chck_enbl,data_in,data_out,error);

    
  always begin
        #5 clk_c <= ~clk_c;
  end    

    
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;

    clk_c <= 1'b0;
    reset <= 1'b0;
    data_in <= 1'b0;
    halt_tx <= 1'b0;
    chck_enbl <= 1'b0;
    cwe_z <= 1'b1;
    

    reset <= 1;
    #10;
    reset <= 0;
    cwe_z <= 0;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b1;

    @(posedge clk_c) cwe_z <= 1;

    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b1;

    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b1;

    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b0;

    #10;
    cwe_z <= 0;
   
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b1;

    @(posedge clk_c) cwe_z <= 1;

    chck_enbl <= 1'b1;
    #30  chck_enbl <= 1'b0;

    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b1;
    halt_tx = 1;
    

    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c) data_in <= 1'b0;
    @(posedge clk_c)halt_tx = 0;
    @(posedge clk_c) data_in <= 1'b0;

    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b1;
    @(posedge clk_c) data_in <= 1'b1;


    #10;
    cwe_z <= 0;

    #200;
    $finish;
  end
    
    
    

endmodule
