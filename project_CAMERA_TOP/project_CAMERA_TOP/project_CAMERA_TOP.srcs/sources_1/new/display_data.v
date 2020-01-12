`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/24 22:26:03
// Design Name: 
// Module Name: display_data
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
module DISPLAY_DATA(CLK_100MHz, I_Data, O_Data, Bit_ctrl);
    input CLK_100MHz;//时钟，上升沿有效
    input [7:0]I_Data;//需要显示的数据//默认八位
    output [6:0]O_Data;
    output reg[7:0]Bit_ctrl;//位控
    
    wire w_clk;//分频后的时钟
    reg [3:0]temp_disp;//暂时显示
    reg flag_set = 0;
    
    //位控
    always @ (posedge w_clk)
    begin
        if (flag_set)
            begin
            flag_set <= 0;
            Bit_ctrl = 8'b1111_1101;//显示[1]位
            temp_disp <= {I_Data[7:4]};
            end
        else
            begin
            flag_set <= 1;
            Bit_ctrl = 8'b1111_1110;//显示[0]位
            temp_disp <= {I_Data[3:0]};
            end
    end
    
    //显示
    display7 DIS_inst(.iData(temp_disp), .oData(O_Data));
    //分频时钟  
    divider DIV_inst(.I_CLK(CLK_100MHz), .rst(0), .O_CLK(w_clk));
endmodule
