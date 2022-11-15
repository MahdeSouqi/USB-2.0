module tx_tb();

reg CRC_16;                   
reg clock; 			
reg reset;			
reg SYN_GEN_LD;	
reg TX_LOAD;
reg halt_tx_shift;

reg  [7:0] TX_DATA;
wire [7:0] tx_data;

reg TX_LAST_BYTE;             
                                
                                
wire shift_tx_crc16;
wire shift_tx_crc5;
wire T_lastbit;                                          
wire TDO;		
wire TCS;
wire TX_READY_LD;

assign tx_data = TX_DATA;

tx dut(
clock, 
reset, 
SYN_GEN_LD, 
halt_tx_shift, 
TX_LOAD, 
tx_data, 
CRC_16, 
TX_LAST_BYTE, 
TDO, 
TCS, 
TX_READY_LD, 
T_lastbit, 
shift_tx_crc16, 
shift_tx_crc5);

always
    #5 clock = ~ clock;

initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    clock = 0;
    reset = 1;
    SYN_GEN_LD = 0;
    TX_DATA = 0;
    TX_LAST_BYTE = 0;
    halt_tx_shift = 0;
    TX_LOAD = 0;

    #10;
    reset = 0;
    @(posedge clock)TX_LOAD = 1;// enable the trasnmission procces 
    
    @(posedge clock)TX_DATA = 8'hff;// check if it going to put the data in the second shifter or not
    
    @(posedge TX_READY_LD) TX_DATA = 8'b1010_1010;// check if it going to put the data in the first shifter or not
    #10 reset = 1;//check the rest and check at which shifter the data will be store first 
    #10 reset = 0;
    @(posedge TX_READY_LD) TX_DATA = 8'h11;

    @(posedge TX_READY_LD) TX_DATA = 8'h44;

    #15 halt_tx_shift = 1; // check the halt
    #30 @(posedge clock) halt_tx_shift = 0;

    @(posedge TX_READY_LD) SYN_GEN_LD = 1; // check the sync data 

    @(posedge TX_READY_LD) SYN_GEN_LD = 0;

    @(posedge TX_READY_LD) TX_LAST_BYTE = 1;// check the las byte flag

    TX_LOAD = 0;// after send the last byte the T_lastbit will go high
    #200 $finish;
end        
endmodule