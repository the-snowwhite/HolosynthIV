// megafunction wizard: %LPM_DIVIDE%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_DIVIDE 

// ============================================================
// File Name: pitchdiv.v
// Megafunction Name(s):
// 			LPM_DIVIDE
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 13.1.4 Build 182 03/12/2014 SJ Full Version
// ************************************************************


//Copyright (C) 1991-2014 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module pitchdiv (
	denom,
	numer,
	quotient,
	remain);

	input	[7:0]  denom;
	input	[23:0]  numer;
	output	[23:0]  quotient;
	output	[7:0]  remain;

	wire [23:0] sub_wire0;
	wire [7:0] sub_wire1;
	wire [23:0] quotient = sub_wire0[23:0];
	wire [7:0] remain = sub_wire1[7:0];

	lpm_divide	LPM_DIVIDE_component (
				.denom (denom),
				.numer (numer),
				.quotient (sub_wire0),
				.remain (sub_wire1),
				.aclr (1'b0),
				.clken (1'b1),
				.clock (1'b0));
	defparam
		LPM_DIVIDE_component.lpm_drepresentation = "UNSIGNED",
		LPM_DIVIDE_component.lpm_hint = "MAXIMIZE_SPEED=6,LPM_REMAINDERPOSITIVE=TRUE",
		LPM_DIVIDE_component.lpm_nrepresentation = "UNSIGNED",
		LPM_DIVIDE_component.lpm_type = "LPM_DIVIDE",
		LPM_DIVIDE_component.lpm_widthd = 8,
		LPM_DIVIDE_component.lpm_widthn = 24;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: PRIVATE_LPM_REMAINDERPOSITIVE STRING "TRUE"
// Retrieval info: PRIVATE: PRIVATE_MAXIMIZE_SPEED NUMERIC "6"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: USING_PIPELINE NUMERIC "0"
// Retrieval info: PRIVATE: VERSION_NUMBER NUMERIC "2"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_DREPRESENTATION STRING "UNSIGNED"
// Retrieval info: CONSTANT: LPM_HINT STRING "MAXIMIZE_SPEED=6,LPM_REMAINDERPOSITIVE=TRUE"
// Retrieval info: CONSTANT: LPM_NREPRESENTATION STRING "UNSIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_DIVIDE"
// Retrieval info: CONSTANT: LPM_WIDTHD NUMERIC "8"
// Retrieval info: CONSTANT: LPM_WIDTHN NUMERIC "24"
// Retrieval info: USED_PORT: denom 0 0 8 0 INPUT NODEFVAL "denom[7..0]"
// Retrieval info: USED_PORT: numer 0 0 24 0 INPUT NODEFVAL "numer[23..0]"
// Retrieval info: USED_PORT: quotient 0 0 24 0 OUTPUT NODEFVAL "quotient[23..0]"
// Retrieval info: USED_PORT: remain 0 0 8 0 OUTPUT NODEFVAL "remain[7..0]"
// Retrieval info: CONNECT: @denom 0 0 8 0 denom 0 0 8 0
// Retrieval info: CONNECT: @numer 0 0 24 0 numer 0 0 24 0
// Retrieval info: CONNECT: quotient 0 0 24 0 @quotient 0 0 24 0
// Retrieval info: CONNECT: remain 0 0 8 0 @remain 0 0 8 0
// Retrieval info: GEN_FILE: TYPE_NORMAL pitchdiv.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL pitchdiv.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL pitchdiv.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL pitchdiv.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL pitchdiv_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL pitchdiv_bb.v FALSE
// Retrieval info: LIB_FILE: lpm
