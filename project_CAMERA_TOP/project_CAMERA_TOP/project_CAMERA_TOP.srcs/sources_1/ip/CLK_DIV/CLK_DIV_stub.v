// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Fri Jan 04 01:11:08 2019
// Host        : LAPTOP-F23IHCO6 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               F:/Project_Auway/project_CAMERA_TOP/project_CAMERA_TOP.srcs/sources_1/ip/CLK_DIV/CLK_DIV_stub.v
// Design      : CLK_DIV
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module CLK_DIV(CLK_100MHz, CLK_10MHz, CLK_24MHz, CLK_25MHz, RST_n)
/* synthesis syn_black_box black_box_pad_pin="CLK_100MHz,CLK_10MHz,CLK_24MHz,CLK_25MHz,RST_n" */;
  input CLK_100MHz;
  output CLK_10MHz;
  output CLK_24MHz;
  output CLK_25MHz;
  input RST_n;
endmodule
