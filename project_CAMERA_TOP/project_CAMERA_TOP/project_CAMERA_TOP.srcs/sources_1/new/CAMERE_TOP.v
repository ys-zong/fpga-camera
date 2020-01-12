`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/01 15:26:15
// Design Name: 
// Module Name: CAMERE_TOP
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
//摄像头大作业顶层控制器模块
module CAMERE_TOP(OV_SIOC, OV_SIOD, OV_VSYNC, OV_HREF, OV_PCLK, OV_XCLK, OV_DATA, OV_RST, OV_PWDN, O_Data, Bit_ctrl, Vsync_s, Hsync_s, R_s, G_s, B_s, ACK_YES, PIX, RST_n, Pause, CLK_100MHz, Read_en, Write_en);//
    //摄像头接口
    output OV_SIOC;//SCCB时钟
    inout OV_SIOD;//SCCB数据，双向
    input OV_VSYNC;//场同步信号
    input OV_HREF;//行有效信号输出
    input OV_PCLK;//像素时钟
    output OV_XCLK;//输入主时钟
    input [7:0]OV_DATA;//8bit数据
    output OV_RST;//复位
    output OV_PWDN;//省电
    //7段数码管接口
    output [6:0]O_Data;//数码管显示
    output [7:0]Bit_ctrl;//位控
    //VGA接口
    output Vsync_s;//行同步信号
    output Hsync_s;//列同步信号
    output [3:0]R_s;//红颜色信号
    output [3:0]G_s;//绿颜色信号
    output [3:0]B_s;//蓝颜色信号
    //LED灯接口
    output ACK_YES;//摄像头应答反馈（低电平有效）
    output [7:0]PIX;
    output Write_en;//写入数据使能信号
    output Read_en;//用于仿真的三态门设计
    //模块全局接口
    input RST_n;//复位
    input Pause;//暂停键
    input CLK_100MHz;//开发板系统时钟，100MHz
    
    //内部模块接线
    //SDRAM接口
    wire [11 : 0]Frame_data; //output
    wire [18 : 0]Frame_addr; //output
    
    //内部接线
    wire [18:0]w_read_addr;//VGA读取地址
    wire [7:0]w_Read_ID;//读取摄像头的ID，检测摄像头的工作与代表写入配置完成
    wire [11:0]w_out_pix_data;//输出像素数据线
    wire w_clk_10MHz, w_clk_24MHz, w_clk_25MHz;//分频后的时钟线
    
    assign PIX = OV_DATA;//w_out_pix_data[15:8]
    //时钟分频器
    CLK_DIV div_inst(.CLK_100MHz(CLK_100MHz), .CLK_10MHz(w_clk_10MHz), .CLK_24MHz(w_clk_24MHz), .CLK_25MHz(w_clk_25MHz), .RST_n(RST_n));
    
    //实例化OV2640驱动模块
    OV2640_Driver ov2640_inst(
        .OV_SIOC(OV_SIOC), 
        .OV_SIOD(OV_SIOD), 
        .OV_VSYNC(OV_VSYNC), 
        .OV_HREF(OV_HREF),
        .OV_PCLK(OV_PCLK), 
        .OV_XCLK(OV_XCLK), 
        .OV_DATA(OV_DATA), 
        .OV_RST(OV_RST), 
        .OV_PWDN(OV_PWDN), 
        .Frame_data(Frame_data), 
        .Frame_addr(Frame_addr),
        .Output_en(Write_en),//可以开始写入数据
        .RST_n(RST_n), 
        .CLK_sioc_10MHz(w_clk_10MHz), 
        .CLK_xclk_24MHz(w_clk_24MHz),
        .ACK_YES(ACK_YES),
        .Read_en(Read_en), 
        .Read_ID(w_Read_ID)
    );
    
    //实例化简单双向RAM
    SDRAM sdram_inst(
        .W_en(Write_en & ~Pause), //按下暂停键会停止画面
        .CLK_w(OV_PCLK), //Frame_clken  CLK_100MHz
        .CLK_r(w_clk_25MHz), 
        .ADDR_in(Frame_addr), 
        .ADDR_out(w_read_addr), 
        .DAT_in(Frame_data), 
        .DAT_out(w_out_pix_data)
    );
    
    //实例化数码管显示模块
    DISPLAY_DATA dis_inst(.CLK_100MHz(CLK_100MHz), .I_Data(w_Read_ID), .O_Data(O_Data), .Bit_ctrl(Bit_ctrl));
    
    //实例化VGA显示模块
    VGA vga_inst(
        .CLK_25MH(w_clk_25MHz), 
        .RST_n(RST_n), 
        .Pix_Addr(w_read_addr),
        .Pix_Data(w_out_pix_data),// Frame_data w_out_pix_data
        .Vsync_s(Vsync_s), 
        .Hsync_s(Hsync_s), 
        .R_s(R_s), 
        .G_s(G_s), 
        .B_s(B_s)
    );
endmodule