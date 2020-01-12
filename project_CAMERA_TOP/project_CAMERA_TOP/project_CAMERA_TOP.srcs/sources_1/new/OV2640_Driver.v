`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 22:41:04
// Design Name: 
// Module Name: OV2640_Driver
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
//OV2640摄像头驱动模块 
module OV2640_Driver(OV_SIOC, OV_SIOD, OV_VSYNC, OV_HREF, OV_PCLK, OV_XCLK, OV_DATA, OV_RST, OV_PWDN, Frame_data, Frame_addr, Output_en, RST_n, CLK_sioc_10MHz, CLK_xclk_24MHz, ACK_YES, Read_en, Read_ID);//clk_pll, , Capture_en
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
    //与FIFO接口
    output [11:0]Frame_data; 
    output [18:0]Frame_addr;
    output Output_en;//配置完成信号
    //本模块内部全局接口
    input RST_n;//复位
    input CLK_sioc_10MHz;//SCCB协议使用时钟，10MHz。
    input CLK_xclk_24MHz;//摄像头XCLK使用时钟，24MHz
    output ACK_YES;//摄像头车应答信号（低电平为有应答）
    output Read_en;//TBd 三态门读取信号控制
    output [7:0]Read_ID;//读取寄存器的数据
    
    //宏定义参数
    parameter p_rIDaddr = 8'h60;//写寄存器的ID地址
    //模块内部连线
    wire [7:0]w_cfg_size;
    wire [7:0]w_cfg_index;
    wire [15:0]write_data;//读取配置数据线
    wire w_xclk, w_sioc;//时钟连线
    wire w_cfg_done;//配置完成信号
    
    ////固定赋值
    assign OV_RST  = 1;//正常使用，拉高电平
    assign OV_PWDN = 0;//正常使用，拉低电平
    
    //SCCB时序读写控制
    SCCB_Timing_Control timing_inst(
        .CLK(CLK_sioc_10MHz), 
        .RST_n(RST_n), 
        .SCCB_CLK(OV_SIOC), 
        .SCCB_DATA(OV_SIOD), 
        .CFG_size(w_cfg_size), //w_cfg_size
        .CFG_index(w_cfg_index), //w_cfg_index
        .CFG_data({p_rIDaddr, write_data[15:0]}), //r_read_ID
        .CFG_done(w_cfg_done), //
        .CFG_rdata(Read_ID),
        .ACK(ACK_YES),
        .Read_en(Read_en)
    );
    
    //配置信息模块
    RGB565_Config config_inst(.LUT_INDEX(w_cfg_index), .LUT_DATA(write_data), .LUT_SIZE(w_cfg_size));
    
    //捕获输出数据模块
    RGB565_Capture capture_inst(
        .CLK(CLK_xclk_24MHz), 
        .RST_n(RST_n), 
        .CFG_done(w_cfg_done),
        .OV_pclk(OV_PCLK), 
        .OV_xclk(OV_XCLK), 
        .OV_vsync(OV_VSYNC), 
        .OV_href(OV_HREF), 
        .OV_din(OV_DATA), 
        .Out_frame_data(Frame_data), 
        .Out_data_en(Output_en), 
        .Out_data_addr(Frame_addr)
    );

endmodule
