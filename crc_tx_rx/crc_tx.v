`timescale 1ns / 10ps
// **********************************************************************
//
//      File:           crc_tx.v
//      Version:        1.0
//      Date:           Sept 28, 2009  
//      Instructor:     Dr. Yacoub Elziq
//
//      Module:         crc_tx
//
//      Children:       none
//
//      Function:       combination of 5 and 16 bit crc block for
//			the tx side of USB
//
//  Description of signals:
//                                                                       
//  clk_c:  main clock. All of design runs on positive edge of this clock
//  reset:   active high reset. When active, all of internal logic is reset
//           The design MUST have a reset before data can be input to the
//           crc generator (internal registers must be cleared)         
//  halt_tx: active high 'halt' signal from bit stuffer. CRC block must                  
//           know when to not use incomming data for crc generation      
//  cwe_z:   check enable. When high, CRC is being generated over        
//           data comming in. The data output provides data EXACTLY      
//           as provided on input (data_in). There is a 1 ns delay..      
//	     When cwe_z is low, incomming data is disregarded, and the
//	     output(s) provide the internal CRC data (one bit per clock.	
//  data_in:  data input (from P2S block of quy)	
//  data_out_5bit:   data output of 5bit crc block.
//  data_out_16bit:   data output of 16bit crc block.
//                                                                       
//   Recommendations on usage:
//
//	sending data packet:
//
//	- set reset high (reset must be activated again and again for EACH packet)!!!
//	- set cwe_z high
//	- set reset low   data MUST now be provided on each pos edge of clk, unless
//			halt_tx is active 
//	- after last bit has been send, pull cew_z low for 16 or 5 clock
//		(depending on which CRC block is used)
//		during these clocks, the crc data is shifted out, the bit
//		stuffer should take these bits and stuff them in.
//                                                                       
// **********************************************************************
 
module  crc_tx(clk_c,reset,halt_tx,cwe_z,data_in,data_out_5bit,
			data_out_16bit);

input   clk_c;                  // clock
input   reset;                  // active high reset
input   halt_tx;                // active high clk disable signal
input   cwe_z;                  // enable check data
input   data_in;                // 1 bit of data input
output  data_out_5bit;          // 1 bit of data output
output  data_out_16bit;         // 1 bit of data output

wire error_5bit;
wire error_16bit;
wire	[15:0] tx16_int;

// **************************************
// *** INSTANTIATION OF SUB MODULES   ***
// **************************************
crc_5 tx5(
        .clk_c(clk_c),
        .reset(reset),
        .halt_tx(halt_tx),
        .cwe_z(cwe_z),
        .chck_enbl(1'b0),
        .data_in(data_in),
        .data_out(data_out_5bit),
        .error(error_5bit));

crc_16 tx16(
        .clk_c(clk_c),
        .reset(reset),
        .halt_tx(halt_tx),
        .cwe_z(cwe_z),
        .chck_enbl(1'b0),
        .data_in(data_in),
        .data_out(data_out_16bit),
        .int_data(tx16_int),	
        .error(error_16bit));

endmodule

