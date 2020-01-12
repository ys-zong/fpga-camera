`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/12 19:13:57
// Design Name: 
// Module Name: SYNC
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
/*行列同步控制模块*/
module SYNC(CLK, RST_n, Vsync_s, Hsync_s, Ready_s, Col_s, Row_s);
    input CLK;//时钟信号，上升沿有效
    input RST_n;//复位信号，低电平有效
    output Vsync_s;//行同步信号
    output Hsync_s;//列同步信号
    output Ready_s;//有效区域信号
    output [10:0]Col_s;//横坐标信号
    output [10:0]Row_s;//纵坐标信号
    
    /*分辨率：640*480*/
    parameter p_Hmaxsize = 11'd800;//行实际最大像素
    parameter p_Vmaxsize = 11'd525;//列实际最大像素
    parameter p_Hreal_minsize = 11'd144;//实际显示行像素最低处
    parameter p_Hreal_maxsize = 11'd785;//实际显示行像素最高处
    parameter p_Vreal_minsize = 11'd35;//实际显示列像素最低处
    parameter p_Vreal_maxsize = 11'd515;//实际显示列像素最高处
    parameter p_Hsyncsize = 11'd96;//行同步像素时序范围
    parameter p_Vsyncsize = 11'd2;//列同步像素时序范围
    /*分辨率：800*600*/
    /*parameter p_Hmaxsize = 11'd1040;//行实际最大像素
    parameter p_Vmaxsize = 11'd666;//列实际最大像素
    parameter p_Hreal_minsize = 11'd184;//实际显示行像素最低处
    parameter p_Hreal_maxsize = 11'd985;//实际显示行像素最高处
    parameter p_Vreal_minsize = 11'd29;//实际显示列像素最低处
    parameter p_Vreal_maxsize = 11'd629;//实际显示列像素最高处
    parameter p_Hsyncsize = 11'd120;//行同步像素时序范围
    parameter p_Vsyncsize = 11'd6;//列同步像素时序范围*/
    
    reg [10:0]r_countH;//记录实时行数
    reg [10:0]r_countV;//记录实时列数
    reg r_is_ready;//显示准备就绪标志位，此时为真正显示的内容
    
    /*对行进行扫描*/
    always @ (posedge CLK or negedge RST_n)
    begin
        if (!RST_n)
            r_countH <= 11'b0;//复位
        else if (r_countH == p_Hmaxsize)//到达最右边时
            r_countH <= 11'b0;//返回最左边
        else
            r_countH <= r_countH + 1'b1;//扫描递增到下一行
    end
    
    /*对列进行扫描*/
    always @ (posedge CLK or negedge RST_n)
    begin
        if (!RST_n)
            r_countV <= 11'b0;//复位
        else if (r_countV == p_Vmaxsize)//到达最下边时
            r_countV <= 11'b0;//返回最上边
        else if (r_countH == p_Hmaxsize)//当每一行扫描完毕后
            r_countV <= r_countV + 1'b1;//扫描递增到下一列
    end
    
    /*对有效区域信号进行判定*/
    always @ (posedge CLK or negedge RST_n)
    begin
        if (!RST_n)
            r_is_ready <= 1'b0;//复位
        else if ((r_countH > p_Hreal_minsize && r_countH < p_Hreal_maxsize) && (r_countV > p_Vreal_minsize && r_countV < p_Vreal_maxsize))
            //行列均在实际显示的范围内
            r_is_ready <= 1'b1;//保持显示
        else //其他非显示区域
            r_is_ready <= 1'b0;//保持不显示
    end
    
    /*对输出的信号进行赋值*/
    //行列同步信号，以及是否显示内容的信号
    assign Vsync_s = (r_countV <= p_Vsyncsize) ? 1'b0 : 1'b1;//同步时为低电平
    assign Hsync_s = (r_countH <= p_Hsyncsize) ? 1'b0 : 1'b1;//同步时为低电平
    assign Ready_s = r_is_ready;//到达显示像素时对应真值
    //行列坐标值
    assign Col_s = r_is_ready ? (r_countH - p_Hreal_minsize - 1'b1) : 11'd0;//横坐标
    assign Row_s = r_is_ready ? (r_countV - p_Vreal_minsize - 1'b1) : 11'd0;//纵坐标
    
endmodule
