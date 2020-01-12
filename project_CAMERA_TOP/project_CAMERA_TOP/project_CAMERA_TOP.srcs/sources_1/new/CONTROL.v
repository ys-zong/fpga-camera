`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/12 22:01:24
// Design Name: 
// Module Name: CONTROL
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
//VGA控制模块
module CONTROL(CLK, RST_n, Ready_s, Col_s, Row_s, Rom_addr, Rom_data, R_s, G_s, B_s);//Rom_addr, 
    input CLK;//时钟信号，上升沿有效
    input RST_n;//复位信号，低电平有效
    input Ready_s;//有效区域信号
    input [10:0]Col_s;//横坐标信号
    input [10:0]Row_s;//纵坐标信号    
    output [18:0]Rom_addr;//对应图像的地址。19位
    input [11:0]Rom_data;//一个图像像素。12位
    output [3:0]R_s;//红颜色信号
    output [3:0]G_s;//绿颜色信号
    output [3:0]B_s;//蓝颜色信号
    
    //宏定义参数
    parameter p_rowmin = 11'd0;//纵坐标最小边界
    parameter p_rowmax = 11'd480 ;//纵坐标最大边界 480 
    parameter p_colmin = 11'd0;//横坐标最小边界
    parameter p_colmax = 11'd640;//横坐标最大边界640  
    
    reg r_pic_ready;//图片显示范围
    
    /*对有效区域信号进行赋值*/
    always @ (posedge CLK or negedge RST_n)
    begin
        if (!RST_n)
            r_pic_ready <= 1'b0;//复位
        else if ((Col_s >= p_colmin && Col_s < p_colmax) && (Row_s >= p_rowmin && Row_s < p_rowmax))
            //行列均在实际显示的范围内
            r_pic_ready <= 1'b1;//保持显示
        else //其他非显示区域
            r_pic_ready <= 1'b0;//保持不显示
    end
    
    /*对输出信号进行控制*/
    assign Rom_addr = Row_s*p_colmax + Col_s;//输出地址
    assign R_s[0] = (Ready_s && r_pic_ready) ? Rom_data[11] : 1'b0;//红
    assign R_s[1] = (Ready_s && r_pic_ready) ? Rom_data[10] : 1'b0;//红
    assign R_s[2] = (Ready_s && r_pic_ready) ? Rom_data[9] : 1'b0;//红
    assign R_s[3] = (Ready_s && r_pic_ready) ? Rom_data[8] : 1'b0;//红
    assign G_s[0] = (Ready_s && r_pic_ready) ? Rom_data[7] : 1'b0;//绿
    assign G_s[1] = (Ready_s && r_pic_ready) ? Rom_data[6] : 1'b0;//绿
    assign G_s[2] = (Ready_s && r_pic_ready) ? Rom_data[5] : 1'b0;//绿
    assign G_s[3] = (Ready_s && r_pic_ready) ? Rom_data[4] : 1'b0;//绿
    assign B_s[0] = (Ready_s && r_pic_ready) ? Rom_data[3] : 1'b0;//蓝
    assign B_s[1] = (Ready_s && r_pic_ready) ? Rom_data[2] : 1'b0;//蓝
    assign B_s[2] = (Ready_s && r_pic_ready) ? Rom_data[1] : 1'b0;//蓝
    assign B_s[3] = (Ready_s && r_pic_ready) ? Rom_data[0] : 1'b0;//蓝

endmodule