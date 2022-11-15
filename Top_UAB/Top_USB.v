
`include "tx.v"
`include "bit_stuff.v"
`include "nrzi_encode_ap.v"
`include "nrzi_decode_ap.v"
`include "bit_unstuff.v"
`include "RX.v"
`include "tx_diff.v"
`include "rx_diff.v"
`include "crc_5.v"
`include "crc_16.v"
`include "crc_tx.v"
`include "crc_rx.v"


module usb_top  (gclk,
                 reset_l,
                 cs1_l,
                 SYN_GEN_LD,
                 CRC_16,
                 TX_LOAD,
                 TX_DATA,
                 TX_LAST_BYTE,
                 RX_LOAD,

                 error_crc_rx,
                 TX_READY_LD,
                 T_lastbit,
                 qualify_out,
                 DATA,
                 RX_READY_LD,
                 RX_LAST_BYTE 
                );
 
input gclk;
input reset_l;
input cs1_l;
input SYN_GEN_LD;
input CRC_16;
input TX_LOAD;
input [7:0] TX_DATA;
input TX_LAST_BYTE;
input RX_LOAD;


output TX_READY_LD;
output T_lastbit;
output [8:0] qualify_out;  
output [7:0] DATA;
output RX_READY_LD;
output RX_LAST_BYTE;
output error_crc_rx;

wire gclk;               	
wire reset_l;              	
wire cs1_l;    
wire SYN_GEN_LD;
wire TX_LOAD;
wire CRC_16;
wire [7:0] TX_DATA;
wire TX_LAST_BYTE;
	
wire            halt_rx_shift;
wire		    halt_tx_shift;
wire            unstuff_dout;
wire 	        stuff_dout;	
wire [8:0]      qualify_out;
wire            cs2_out_l;
wire            rx_data_out;
wire            rx_data_valid;
wire            TDO;
wire            TCS;
wire            tx_data_out ;
wire            tx_data_valid ;
wire            start_txd1;
wire            RX_LOAD;
wire            RX_READY_LD;
wire    [7:0]   DATA;
wire            RX_LAST_BYTE;
wire 			error_crc_rx;
wire            tx_crc5_out;
wire            tx_crc16_out;
wire            shift_tx_crc5;
wire            shift_tx_crc16;
wire 			txd_pos;
wire 			txd_neg;
wire  			rx_diff_valid;
wire 			rx_diff_out;
     	     
wire 			idle_or_sync_rx_d;           
wire 			pid_rx_d;  		   	    
wire 			dev_address_rx_d; 	    
wire 			end_point_address_rx_d;  
wire 			crc5_rx_d;  		   	    
wire 			frame_number_rx_d;  	     
wire 			data_crc_eop_rx_d;  	     
wire 			eop_rx_d;  		   	     
wire			error_rx_d;

wire idle_or_sync_n; 
wire pid_n; 
wire dev_address_n; 
wire end_point_address_n; 
wire crc5_n;
wire frame_number_n;
wire data_crc_eop_n; 
wire eop_n; 
wire error_n;
  

reg             default_value = 1'bx;

wire            default_assign1;
assign default_assign1 = default_value;


tx         t_x(.clock(gclk),
            .reset(~reset_l),
            .SYN_GEN_LD(SYN_GEN_LD),
            .halt_tx_shift(halt_tx_shift),  
            .CRC_16(CRC_16),			
            .TX_LOAD(TX_LOAD),
            .TX_DATA(TX_DATA),
            .TX_LAST_BYTE(TX_LAST_BYTE),
            .TDO(TDO),   
            .TCS(TCS),  
            .TX_READY_LD(TX_READY_LD),  
            .T_lastbit(T_lastbit), 
            .shift_tx_crc16(shift_tx_crc16), 
            .shift_tx_crc5(shift_tx_crc5)
       		);

			reg [15:0] cwe_z;
always @(posedge gclk or negedge reset_l)
begin
  if (~reset_l)
    cwe_z <= 16'h0000;
  else
    cwe_z <= {cwe_z[14:0],TCS}; // coming from tx not instantiated here
end
//TDO	 -- user logic

crc_tx c_t	(.clk_c(gclk),
		.reset(~reset_l),
		.halt_tx(halt_tx_shift), // receive from b_s
		.cwe_z((cwe_z[15]&TCS)),
                //.cwe_z(((cwe_z[15]&TCS)&CRC_16)|(cwe_z[15]&~shift_tx_crc5&~CRC_16)),
		.data_in(TDO),
		.data_out_5bit(tx_crc5_out), // output to b_s
		.data_out_16bit(tx_crc16_out)
		); // output to b_s



bit_stuff bit_stuff_inst0(
			//Inputs
			.gclk 			(gclk),
	       	.reset_l		(reset_l),
	       	.start_bit_stuff	(TCS|shift_tx_crc16|shift_tx_crc5),
	       	.stuff_din		(TDO),
	       	.shift_tx_crc5		(1'b0), 
			.shift_tx_crc16		(1'b0),
	       	.tx_crc5_out		(tx_crc5_out),
	       	.tx_crc16_out		(tx_crc16_out),
	       	.cs1_l			(cs1_l),
			//Outputs
	       	.halt_tx_shift		(halt_tx_shift),
	       	.stuff_dout		(stuff_dout),
	       	.start_txd		(start_txd1)
			);

nrzi_encode_ap nrzi_encode_ap_inst0(
			.gclk			(gclk),
			.reset_l		(reset_l), 
			.start_txd		(start_txd1), 
			.tx_data_in		(stuff_dout), 
			.tx_data_out		(tx_data_out),
			.tx_data_valid		(tx_data_valid)
			);

tx_diff    	tx_d_inst0(
					.gclk			(gclk),
               		.reset_l		(reset_l),
               		.txd_pos		(txd_pos),   		// output to rx_d
                	.txd_neg		(txd_neg),   		// output to rx_d
               		.tx_data_valid		(tx_data_valid),        // receive from n_e
               		.nrzi_data		(tx_data_out)
			);

rx_diff 	rx_d_inst0(
			.gclk(gclk),
                	.reset_l(reset_l),
                	.rxd_pos(txd_pos),  		   	     // receive from tx_d
                	.rxd_neg(txd_neg),  		   	     // receive from tx_d
                	.rx_diff_out(rx_diff_out),  	   	     // output to n_d
               		.rx_diff_valid(rx_diff_valid),     	     // output to n_d
                	.idle_or_sync(idle_or_sync_rx_d),            // output to n_d
                	.pid(pid_rx_d),  		   	     // output to n_d
                	.dev_address(dev_address_rx_d),    	     // output to n_d
                	.end_point_address(end_point_address_rx_d),  // output to n_d
                	.crc5(crc5_rx_d),  		   	     // output to n_d
                	.frame_number(frame_number_rx_d),  	     // output to n_d
                	.data_crc_eop(data_crc_eop_rx_d),  	     // output to n_d
                	.eop(eop_rx_d),  		   	     // output to n_d
                	.error(error_rx_d)
			);  				   // output to n_d			


nrzi_decode_ap nrzi_decode_ap_inst0(
			.gclk			(gclk),
			.reset_l		(reset_l),
			.rx_data_out		(rx_data_out),
			.start_rxd		(rx_diff_valid),
			.rx_data_in		(rx_diff_out),
			.rx_data_valid		(rx_data_valid),
        	.idle_or_sync_n		(idle_or_sync_n),
			.pid_n			(pid_n),
			.dev_address_n		(dev_address_n),
			.end_point_address_n	(end_point_address_n),
			.crc5_n			(crc5_n),
			.frame_number_n 	(frame_number_n),
			.data_crc_eop_n		(data_crc_eop_n), 
			.eop_n			(eop_n),
			.error_n		(error_n),
        	.idle_or_sync		(idle_or_sync_rx_d),
			.pid			(pid_rx_d),
			.dev_address		(dev_address_rx_d),
			.end_point_address	(end_point_address_rx_d),
			.crc5			(crc5_rx_d),
		    .frame_number		(frame_number_rx_d),
			.data_crc_eop		(data_crc_eop_rx_d),
			.eop			(eop_rx_d),
			.error			(error_rx_d)
			 );

bit_unstuff bit_unstuff_inst0(
		        //Inputs
			.gclk			(gclk),
       		.reset_l		(reset_l),
		    .unstuff_din		(rx_data_out),
		    .cs2_l			(rx_data_valid),
			.idle_or_sync		(idle_or_sync_n),
			.pid			(pid_n),
			.dev_address		(dev_address_n),
			.end_point_address	(end_point_address_n),
			.crc5			(crc5_n),
			.frame_number		(frame_number_n),
			.data_crc_eop		(data_crc_eop_n),
			.error			(error_n),
			.eop			(eop_n),
			//Outputs
			.cs2_out_l		(cs2_out_l),
		    .halt_rx_shift		(halt_rx_shift), 
        	.unstuff_dout		(unstuff_dout),
			.qualify_out		(qualify_out)
		         ); 

reg [7:0] rx_cwe_z;
always @(posedge gclk or negedge reset_l)
begin
  if (~reset_l)
    rx_cwe_z <= 8'b0;
  else
    rx_cwe_z <= {rx_cwe_z[6:0],cs2_out_l};
end

crc_rx c_r	(.clk_c(gclk),
		.reset(~reset_l),
		.rcs(~halt_rx_shift),
		.cwe_z((rx_cwe_z[7]&cs2_out_l)),
		.chck_enbl(qualify_out[0]),
		.data_in(unstuff_dout),
		.select16(qualify_out[2]),
		.error(error_crc_rx),
		.rx16_int()
		);


RX        r_x(.clock(gclk),
              .reset(~reset_l),
              .RCS(cs2_out_l),
              .RDI(unstuff_dout),
              .halt_rx(halt_rx_shift),
              .RX_LOAD(RX_LOAD),
              .DATA(DATA),
              .RX_READY_LD(RX_READY_LD),
              .RX_LAST_BYTE(RX_LAST_BYTE)
             );                  



                         
endmodule
