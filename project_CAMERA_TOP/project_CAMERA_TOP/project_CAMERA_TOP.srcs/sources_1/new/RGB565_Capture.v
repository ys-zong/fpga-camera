`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 12:26:30
// Design Name: 
// Module Name: RGB565_Capture
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
//摄像头信号采集模块Out_frame_vsync, Out_frame_href, 
module RGB565_Capture(CLK, RST_n, CFG_done, OV_pclk, OV_xclk, OV_vsync, OV_href, OV_din, Out_frame_data, Out_data_en, Out_data_addr);
    //模块内部全局接口
    input CLK;//外部驱动时钟，24MHz
    input RST_n;//复位信号，低电平有效
    input CFG_done;//配置完成信号
    //摄像头接口
    input OV_pclk;//摄像头像素时钟
    output OV_xclk;//摄像头驱动时钟
    input OV_vsync;//摄像头场同步信号输出
    input OV_href;//摄像头行有效信号输出
    input [7:0]OV_din;//摄像头8bit数据接入
    //输出编码信号
    output reg[11:0]Out_frame_data;//摄像头采样后输出拼接的12bit数据，并与上对其
    output reg Out_data_en;//数据输出使能信号
    output [18:0]Out_data_addr;//写入RAM的地址    
    

    parameter p_max_addr = 19'd307200;//纵坐标实际最大边界
    parameter p_real_y = 11'd600;//纵坐标实际最大边界
    parameter p_real_x = 11'd800;//横坐标实际最大边界
    parameter p_true_y = 11'd480;//纵坐标有效最大边界
    parameter p_true_x = 11'd640;//横坐标有效最大边界
    //parameter p_true_y = 11'd600;//纵坐标有效最大边界
    //parameter p_true_x = 11'd800;//横坐标有效最大边界

    //地址与时钟的赋值
    reg [18:0]r_addr;//地址寄存器
    assign Out_data_addr = r_addr;
    assign OV_xclk = CLK;//外部时钟直接作为该驱动
    //检测VSYNC的上升与下降沿
    reg [1:0]r_OV_vsync;//边沿检测寄存器
    reg r_vysnc_valid;//帧有效信号
    wire w_vysnc_negedge;//下降沿
    wire w_vysnc_posedge;//上升沿
    always @ (posedge OV_pclk or negedge RST_n)
    begin
        if(!RST_n)
            r_OV_vsync <= 0;
        else if (CFG_done)
            r_OV_vsync <= {r_OV_vsync[0], OV_vsync};
    end
    assign w_vysnc_negedge = r_OV_vsync[1] && !r_OV_vsync[0] ;//下降沿
    assign w_vysnc_posedge = !r_OV_vsync[1] && r_OV_vsync[0] ;//上升沿
    

    
    always @(posedge OV_pclk or negedge RST_n)
    begin
        if (!RST_n) 
            begin 
            r_vysnc_valid <= 0;//复位，无效
            end
        else if (CFG_done)
            begin
            if(w_vysnc_posedge) //上升沿，代表一帧图像开始
                r_vysnc_valid <= 1; 
            else if(w_vysnc_negedge) //下降沿，代表一帧图像结束
                r_vysnc_valid <= 0;
            else 
                r_vysnc_valid <= r_vysnc_valid;
            end//of else if
    end//of always
    
    //拼接数据
    reg [11:0]r_herf_cnt;//横坐标计数
    //reg [11:0]camera_data_reg;
    reg [1:0]r_counter;//对像素拼接的高位与低位进行控制

    always @ (posedge OV_pclk or negedge RST_n)
    begin
        if (!RST_n) //复位
            begin 
            r_herf_cnt <= 0;
            r_counter <= 0;
            //camera_data_reg <= 0;
            Out_frame_data  <= 0;
            Out_data_en <= 1'b0;
            r_addr <= 0;
            end
        else if (CFG_done)//配置完成
            begin
            if (r_vysnc_valid)
                begin
                if ((OV_href == 1'b1) && (OV_vsync == 1'b1) && (r_herf_cnt < p_true_x)) //对一行帧进行处理
                    begin   
                    if (r_counter < 1'b1) 
                        begin                                    
                        r_counter <= r_counter + 1'b1;
                        Out_frame_data[11:5] = {OV_din[7:4], OV_din[2:0]};
                        //camera_data_reg <= {camera_data_reg[5:0], };
                        //camera_data_reg <= {camera_data_reg[7:0], OV_din};
                        Out_data_en <= 1'b0;
                        end
                    else 
                        begin                                                 
                        r_herf_cnt <= r_herf_cnt+ 1'b1;
                        r_counter <= 0;
                        Out_frame_data[4:0] <= {OV_din[7], OV_din[4:1]};
                        //Out_frame_data <={camera_data_reg[5:0], OV_din[7:6], OV_din[4:1]};
                        if (r_addr < p_max_addr) //防止写入RAM的总像素溢出
                            begin
                            r_addr <= r_addr + 1'b1;
                            Out_data_en <= 1'b1;
                            end    
                        //camera_data_reg <= 0;                  
                        end
                    end
                else if ((OV_href == 1'b0) && (OV_vsync == 1'b1)) //一行结束
                    begin   
                    r_herf_cnt <= 0;
                    r_counter <= 0;
                    Out_data_en <= 1'b0;
                    r_addr <= r_addr;
                    end
                else 
                    begin
                    r_herf_cnt <= r_herf_cnt;//截取一行后等待
                    r_counter <= 0;
                    Out_data_en <= 1'b0;
                    r_addr <= r_addr;
                    end
            end
        else 
            begin
            r_herf_cnt <= 0;
            r_counter <= 0;
            Out_data_en <= 1'b0;
            r_addr <= 0;
            end   
        end 
    end    
    
endmodule
