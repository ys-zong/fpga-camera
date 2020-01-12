`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/12 19:13:31
// Design Name: 
// Module Name: VGA
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
//顶层VGA模块
module VGA(CLK_25MH, RST_n, Pix_Data, Pix_Addr, Vsync_s, Hsync_s, R_s, G_s, B_s);
    input CLK_25MH;//时钟信号。25MHz，上升沿有效
    input RST_n;//复位信号，低电平有效
    input [11:0]Pix_Data;//图片的像素数据，12位
    output [18:0]Pix_Addr;//像素地址
    output Vsync_s;//行同步信号
    output Hsync_s;//列同步信号
    output [3:0]R_s;//红颜色信号
    output [3:0]G_s;//绿颜色信号
    output [3:0]B_s;//蓝颜色信号
    
    //各个模块之间的连线
    wire ready_s;//有效区域显示线
    wire [10:0]row;//纵坐标
    wire [10:0]col;//横坐标

    //实例化同步控制模块
    SYNC sync_inst(
        .CLK(CLK_25MH), 
        .RST_n(RST_n), 
        .Vsync_s(Vsync_s), 
        .Hsync_s(Hsync_s), 
        .Ready_s(ready_s), 
        .Col_s(col), 
        .Row_s(row)
    );
    //实例化VGA控制模块
    CONTROL control_inst(
        .CLK(CLK_25MH), 
        .RST_n(RST_n), 
        .Ready_s(ready_s), 
        .Col_s(col), 
        .Row_s(row), 
        .Rom_addr(Pix_Addr),
        .Rom_data(Pix_Data), 
        .R_s(R_s), 
        .G_s(G_s), 
        .B_s(B_s)
    );

endmodule
