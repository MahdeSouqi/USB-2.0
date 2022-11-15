`timescale 1ns / 10ps
// **********************************************************************
//
//      File:           crc_rx.v
//      Version:        1.0
//      Date:           Sept 28, 2009  
//      Instructor:     Dr. Yacoub Elziq
//
//      Module:         crc_rx
//
//      Children:       none
//
//      Function:       combination of 5 and 16 bit crc block
//                      the rx side of USB
//
//  Description of signals:
//
//  clk_c:  main clock. All of design runs on positive edge of this clock
//  reset:   active high reset. When active, all of internal logic is reset
//           The design MUST have a reset before data can be input to the
//           crc generator (internal registers must be cleared)
//  rcs:     active high 'chipselect' signal from bit stuffer. CRC block must
//           know when to not use incomming data for crc generation
//		this signal must be high, for data to be used for CRC
//		generation.
//  cwe_z:   check enable. When high, CRC is being generated over
//           data comming in. 
//           as provided on input (data_in). There is a 1 ns delay..
//           When cwe_z is low, incomming data is disregarded, and the
//           output(s) provide the internal CRC data (one bit per clock.
//		in the receiver (here), this signal should be high always..
//  data_in:  data input (from bit un-stuffer block of David)
//  chck_enbl:   active high enbl signal for the internal error checker
//		It is the responsibility of the receive S/M (andrew's
//		block to activate this signal at the right time, i.e.
//		provide the EOP detected signal).		
//  select16:   select signal to determine which crc to use (16 bit or 5 bit)
//		Set high for 16 bit, low for 5 bit.
//  error:   error output of crc block. Error signal is always low, unless
//		chck_enbl is activated. In that case, a check is made for
//		the internal data register to be all zero's. If not, the
//		error signal will go high. It will stay high, until
//		reset is activated.
//
//   Recommendations on usage:
//
//      sending data packet:
//
//      - set reset high (reset must be activated again and again for EACH packet)!!!
//		I recomment to use the sync_detect signal for this.
//      - set cwe_z high
//      - set reset low  data MUST now be provided on each pos edge of clk, unless
//                      rcs is not active (low)
//      - after last bit has been send, the eop should have been detected, and
//              that signal should activate the chck_enbl input, to see if there
//              are/were any errors.
//
// **********************************************************************

//
// **********************************************************************
 
module  crc_rx(clk_c,reset,rcs,cwe_z,chck_enbl,data_in,select16,
		error, rx16_int);

input   clk_c;                  // clock
input   reset;                  // active high reset
input   rcs;                	// active data chipselect (inv of halt tx)
input   cwe_z;                  // enable check data
input   chck_enbl;              // enable error check
input   data_in;                // 1 bit of data input
input	select16;		// high when crc16 is selected
				// low when crc5 selected
output  error;                  // high when error detected.
output	[15:0] rx16_int;


wire	error_5bit;
wire	error_16bit;

wire    [15:0] rx16_int;

assign	error	=	(select16) ? error_16bit : error_5bit;

// **************************************
// *** INSTANTIATION OF SUB MODULES   ***
// **************************************
crc_5 rx5(
        .clk_c(clk_c),
        .reset(reset),
        .halt_tx(~rcs),
        .cwe_z(cwe_z),
        .chck_enbl(chck_enbl),
        .data_in(data_in),
        .data_out(data_out_5bit),
        .error(error_5bit));

crc_16 rx16(
        .clk_c(clk_c),
        .reset(reset),
        .halt_tx(~rcs),
        .cwe_z(cwe_z),
        .chck_enbl(chck_enbl),
        .data_in(data_in),
        .data_out(data_out_16bit),
	.int_data(rx16_int),
        .error(error_16bit));

endmodule

