module rx_tb();

reg clock;
reg reset;
reg halt_rx;                 
reg RCS;                     
reg RDI;                                                
reg RX_LOAD;

reg  [7:0] data;
wire [7:0] DATA; 

wire RX_READY_LD;            
wire RX_LAST_BYTE;

RX dut(
clock, 
reset, 
RCS, 
RDI, 
halt_rx, 
RX_LOAD, 
DATA, 
RX_READY_LD, 
RX_LAST_BYTE); 

always
    #5 clock = ~ clock;


initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    clock = 0;
    reset = 0;
    halt_rx = 0;
    data = 8'h00;
    RCS = 0;
    RDI = 0;
    RX_LOAD = 0;

    #10 reset = 1;
    #10 reset = 0;
    #10;
    @(posedge clock) RCS = 1;//enable s2p shifter reading 
    

    repeat(7) @(posedge clock) RDI = ~ RDI;//random data 
    RX_LOAD = 1;
    repeat(4) @(posedge clock) RDI = 0;

    @(posedge clock)halt_rx = 1;// check the halt signal 

    repeat(3) @(posedge clock) RDI = 1;

    @(posedge clock)halt_rx = 0;

    repeat(8) @(posedge clock) RDI = 0; 
    RCS = 0;// check the enable of the valid data 
    repeat(7) @(posedge clock) RDI = ~ RDI;
    RCS = 1;
    @(posedge clock) RDI = 1;

    #10 RX_LOAD = 0;//check the z data output
    #20 RX_LOAD = 1;

    #50 RCS = 0;// check the RX_LAST_BYTE
    #10 RX_LOAD = 0;

    #200 $finish;

end
    
endmodule