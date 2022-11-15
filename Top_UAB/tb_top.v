
module tb_top();
 
reg gclk;               	
reg reset_l;              	
reg cs1_l;    
reg SYN_GEN_LD;
reg CRC_16;
reg TX_LOAD;
reg TX_LAST_BYTE;
reg RX_LOAD;
reg [7:0] DATA_tmp;  

wire TX_READY_LD;
wire T_lastbit;
wire [8:0] qualify_out;  
wire [7:0] DATA;
wire [7:0] TX_DATA;
wire RX_READY_LD;
wire RX_LAST_BYTE;
wire  error_crc_rx;  
  
assign  TX_DATA = DATA_tmp ;

usb_top usb_top_inst0  
                (
                 .gclk          (gclk),
                 .reset_l       (reset_l),
                 .cs1_l         (cs1_l),
                 .SYN_GEN_LD    (SYN_GEN_LD),
                 .CRC_16        (CRC_16),
                 .TX_LOAD       (TX_LOAD),
                 .TX_DATA       (TX_DATA),
                 .TX_LAST_BYTE  (TX_LAST_BYTE),
                  .RX_LOAD       (1'b1),

                 //o/p
                  .error_crc_rx( error_crc_rx),
                 .TX_READY_LD   (TX_READY_LD),
                 .T_lastbit     (T_lastbit),
                 .qualify_out   (qualify_out),
                 .DATA          (DATA),
                 .RX_READY_LD   (RX_READY_LD),
                 .RX_LAST_BYTE  (RX_LAST_BYTE)
                );


always
	#10 gclk = ~gclk;                


initial begin
	$dumpfile("dump.vcd"); $dumpvars;
	gclk = 0;
	reset_l = 1'b0;
	cs1_l   = 1'b0;
	SYN_GEN_LD = 1'b0;
  
    #20 reset_l = 1'b1;
    
			cs1_l   = 1'b1;
	   
			TX_LOAD = 1'b0;
			DATA_tmp = 8'h00;
			TX_LAST_BYTE =1'b0;
			CRC_16 = 1'b1;

            repeat (8) @ (posedge gclk);
	        DATA_tmp = 8'h80;
	        TX_LOAD = 1'b1;
	        repeat (1) @ (posedge gclk);
	        TX_LOAD = 1'b0;
        
	        repeat (7) @ (posedge gclk);
	        DATA_tmp = 8'hC3;
	        TX_LOAD = 1'b1;
	        repeat (1) @ (posedge gclk);
	        TX_LOAD = 1'b0;
        
	        repeat (7) @ (posedge gclk);
	        DATA_tmp = 8'h3F;
	        TX_LOAD = 1'b1;
	        repeat (1) @ (posedge gclk);
	        TX_LOAD = 1'b0;
        
	        repeat (7) @ (posedge gclk);
	        DATA_tmp = 8'hB4;
	        TX_LOAD = 1'b1;
	        repeat (1) @ (posedge gclk);
	        TX_LOAD = 1'b0;
        
	        repeat (7) @ (posedge gclk);
	        DATA_tmp = 8'h85;
	        TX_LOAD = 1'b1;
	        repeat (1) @ (posedge gclk);
	        TX_LOAD = 1'b0;
        
	        repeat (7) @ (posedge gclk);
	        DATA_tmp = 8'hd3;
	        TX_LOAD = 1'b1;
	        repeat (1) @ (posedge gclk);
	        TX_LOAD = 1'b0;
        
	        repeat (7) @ (posedge gclk);
	        DATA_tmp = 8'h33;
	        TX_LOAD = 1'b1;
	        repeat (1) @ (posedge gclk);
	        TX_LOAD = 1'b0;
        
	        repeat (7) @ (posedge gclk);
	        DATA_tmp = 8'h14;
	        TX_LOAD = 1'b1;
	        repeat (1) @ (posedge gclk);
	        TX_LOAD = 1'b0;
	        repeat (6) @ (posedge gclk);
	        TX_LAST_BYTE =1'b1;
	        repeat (1) @ (posedge gclk);
	        TX_LAST_BYTE =1'b0;
	     

    	#500;	
	$finish;

end

endmodule
