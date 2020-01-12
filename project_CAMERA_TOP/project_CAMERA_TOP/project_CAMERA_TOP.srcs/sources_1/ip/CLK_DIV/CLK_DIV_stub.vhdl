-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
-- Date        : Fri Jan 04 01:11:08 2019
-- Host        : LAPTOP-F23IHCO6 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               F:/Project_Auway/project_CAMERA_TOP/project_CAMERA_TOP.srcs/sources_1/ip/CLK_DIV/CLK_DIV_stub.vhdl
-- Design      : CLK_DIV
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLK_DIV is
  Port ( 
    CLK_100MHz : in STD_LOGIC;
    CLK_10MHz : out STD_LOGIC;
    CLK_24MHz : out STD_LOGIC;
    CLK_25MHz : out STD_LOGIC;
    RST_n : in STD_LOGIC
  );

end CLK_DIV;

architecture stub of CLK_DIV is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK_100MHz,CLK_10MHz,CLK_24MHz,CLK_25MHz,RST_n";
begin
end;
