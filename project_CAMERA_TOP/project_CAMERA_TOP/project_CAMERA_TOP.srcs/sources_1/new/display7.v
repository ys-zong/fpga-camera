`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/13 09:20:52
// Design Name: 
// Module Name: display7
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
module display7(iData, oData);
    input [3:0]iData;
    output reg [6:0]oData;
    
    always @ (*)
    begin
    case (iData) 
        4'b0000: //0
        oData = 7'b1000000; 
        4'b0001: //1
        oData = 7'b1111001;
        4'b0010: //2
        oData = 7'b0100100;
        4'b0011: //3
        oData = 7'b0110000;
        4'b0100: //4
        oData = 7'b0011001;
        4'b0101: //5
        oData = 7'b0010010;
        4'b0110: //6
        oData = 7'b0000010;
        4'b0111: //7
        oData = 7'b1111000;
        4'b1000: //8
        oData = 7'b0000000;
        4'b1001: //9
        oData = 7'b0010000;
        4'b1010: //A
        oData = 7'b0001000;
        4'b1011: //b
        oData = 7'b0000011;
        4'b1100: //C
        oData = 7'b1000110;
        4'b1101: //d
        oData = 7'b0100001;
        4'b1110: //E
        oData = 7'b0000110;
        4'b1111: //F
        oData = 7'b0001110;
        /*default: //Ãð
        oData = 7'b1111111;*/
    endcase
    end
endmodule
