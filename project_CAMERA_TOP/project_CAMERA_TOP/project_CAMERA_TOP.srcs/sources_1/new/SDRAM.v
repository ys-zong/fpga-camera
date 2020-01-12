`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/25 21:28:08
// Design Name: 
// Module Name: SDRAM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//SDRAM功能模块，对外只开放复位，读写时钟，读写数据口，开始读写控制信号。非法情况内部封装处理
module SDRAM(W_en, CLK_w, CLK_r, ADDR_in, ADDR_out, DAT_in, DAT_out);//, Write_en
    input W_en;//写使能，高电平有效
    input CLK_w;//写入数据时钟
    input CLK_r;//读取数据时钟  
    input [18:0]ADDR_in;//地址写入
    input [18:0]ADDR_out;//地址写出
    input [11:0]DAT_in;//12位像素写入
    output [11:0]DAT_out;//12位像素读出

    blk_mem_gen_0 sdram_inst (
        .clka(CLK_w),    // 写时钟
        .wea(W_en),      // 使能
        .addra(ADDR_in),  // 写地址  input wire [18 : 0] addra
        .dina(DAT_in),    // 写数据  input wire [11 : 0] dina
        .clkb(CLK_r),    // 读时钟  input wire clkb
        .addrb(ADDR_out),  // 读地址  input wire [18 : 0] addrb
        .doutb(DAT_out)  //  读数据  output wire [11 : 0] doutb
    );

endmodule
