`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 22:44:55
// Design Name: 
// Module Name: RGB565_Config
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
//以RGB565模式配置信息，协议规范为SCCB
module RGB565_Config(LUT_INDEX, LUT_DATA, LUT_SIZE);
    input [7:0]LUT_INDEX;//当前配置模块查询指定寄存器的索引
    output reg[15:0]LUT_DATA;//指定寄存器的地址与数据
    output [7:0]LUT_SIZE;//为I2C配置模块寄存器的数量
    
    assign LUT_SIZE = 8'd179;//179条配置信息
    //assign LUT_SIZE = 8'd2;//1条配置信息
    
    always @ (*)
    begin
    case (LUT_INDEX)
    8'd0: LUT_DATA = {16'hFF01};
    8'd1: LUT_DATA = {16'h1280};// UXGA  h1280   CIF1290
    8'd2: LUT_DATA = {16'hFF00};
    8'd3: LUT_DATA = {16'h2CFF};
    8'd4: LUT_DATA = {16'h2EDF};
    8'd5: LUT_DATA = {16'hFF01};
    8'd6: LUT_DATA = {16'h3C32};
    8'd7: LUT_DATA = {16'h1101};
    8'd8: LUT_DATA = {16'h0902};//
    8'd9: LUT_DATA = {16'h0420};
    8'd10: LUT_DATA = {16'h13E5};
    8'd11: LUT_DATA = {16'h1448};
    8'd12: LUT_DATA = {16'h2C0C};
    8'd13: LUT_DATA = {16'h3378};
    8'd14: LUT_DATA = {16'h3A33};
    8'd15: LUT_DATA = {16'h3BFB};
    8'd16: LUT_DATA = {16'h3E00};
    8'd17: LUT_DATA = {16'h4311};
    8'd18: LUT_DATA = {16'h1610};
    8'd19: LUT_DATA = {16'h3992};
    8'd20: LUT_DATA = {16'h35DA};
    8'd21: LUT_DATA = {16'h221A};
    8'd22: LUT_DATA = {16'h37C3};
    8'd23: LUT_DATA = {16'h2300};
    8'd24: LUT_DATA = {16'h34C0};
    8'd25: LUT_DATA = {16'h361A};
    8'd26: LUT_DATA = {16'h0688};
    8'd27: LUT_DATA = {16'h07C0};
    8'd28: LUT_DATA = {16'h0D87};
    8'd29: LUT_DATA = {16'h0E41};
    8'd30: LUT_DATA = {16'h4C00};
    8'd31: LUT_DATA = {16'h4800};
    8'd32: LUT_DATA = {16'h5B00};
    8'd33: LUT_DATA = {16'h4203};
    8'd34: LUT_DATA = {16'h4A81};
    8'd35: LUT_DATA = {16'h2199};
    8'd36: LUT_DATA = {16'h2440};
    8'd37: LUT_DATA = {16'h2538};
    8'd38: LUT_DATA = {16'h2682};
    8'd39: LUT_DATA = {16'h5C00};
    8'd40: LUT_DATA = {16'h6300};
    8'd41: LUT_DATA = {16'h4600};
    8'd42: LUT_DATA = {16'h0C3C};//default 3c   single frame 3d
    8'd43: LUT_DATA = {16'h6170};
    8'd44: LUT_DATA = {16'h6280};
    8'd45: LUT_DATA = {16'h7C05};
    8'd46: LUT_DATA = {16'h2080};
    8'd47: LUT_DATA = {16'h2830};
    8'd48: LUT_DATA = {16'h6C00};
    8'd49: LUT_DATA = {16'h6D80};
    8'd50: LUT_DATA = {16'h6E00};
    8'd51: LUT_DATA = {16'h7002};
    8'd52: LUT_DATA = {16'h7194};
    8'd53: LUT_DATA = {16'h73C1};
    8'd54: LUT_DATA = {16'h1240};//default 40  cif 50
    8'd55: LUT_DATA = {16'h1711};
    8'd56: LUT_DATA = {16'h1843};//defailt 
    8'd57: LUT_DATA = {16'h1900};
    8'd58: LUT_DATA = {16'h1A4B};
    8'd59: LUT_DATA = {16'h3209};
    8'd60: LUT_DATA = {16'h37C0};
    8'd61: LUT_DATA = {16'h4FCA};
    8'd62: LUT_DATA = {16'h50A8};
    8'd63: LUT_DATA = {16'h5a23};
    8'd64: LUT_DATA = {16'h6D00};
    8'd65: LUT_DATA = {16'h3D38};
    8'd66: LUT_DATA = {16'hFF00};
    8'd67: LUT_DATA = {16'hE57F};
    8'd68: LUT_DATA = {16'hF9C0};
    8'd69: LUT_DATA = {16'h4124};
    8'd70: LUT_DATA = {16'hE014};//default 14  cif 15
    8'd71: LUT_DATA = {16'h76FF};
    8'd72: LUT_DATA = {16'h33A0};
    8'd73: LUT_DATA = {16'h4220};
    8'd74: LUT_DATA = {16'h4318};
    8'd75: LUT_DATA = {16'h4C00};
    8'd76: LUT_DATA = {16'h87D5};
    8'd77: LUT_DATA = {16'h883F};
    8'd78: LUT_DATA = {16'hD703};
    8'd79: LUT_DATA = {16'hD910};
    8'd80: LUT_DATA = {16'hD382};
    8'd81: LUT_DATA = {16'hC808};
    8'd82: LUT_DATA = {16'hC980};
    8'd83: LUT_DATA = {16'h7C00};
    8'd84: LUT_DATA = {16'h7D00};
    8'd85: LUT_DATA = {16'h7C03};
    8'd86: LUT_DATA = {16'h7D48};
    8'd87: LUT_DATA = {16'h7D48};
    8'd88: LUT_DATA = {16'h7C08};
    8'd89: LUT_DATA = {16'h7D20};
    8'd90: LUT_DATA = {16'h7D10};
    8'd91: LUT_DATA = {16'h7D0E};
    8'd92: LUT_DATA = {16'h9000};
    8'd93: LUT_DATA = {16'h910E};
    8'd94: LUT_DATA = {16'h911A};
    8'd95: LUT_DATA = {16'h9131};
    8'd96: LUT_DATA = {16'h915A};
    8'd97: LUT_DATA = {16'h9169};
    8'd98: LUT_DATA = {16'h9175};
    8'd99: LUT_DATA = {16'h917E};
    8'd100: LUT_DATA = {16'h9188};
    8'd101: LUT_DATA = {16'h918F};
    8'd102: LUT_DATA = {16'h9196};
    8'd103: LUT_DATA = {16'h91A3};
    8'd104: LUT_DATA = {16'h91AF};
    8'd105: LUT_DATA = {16'h91C4};
    8'd106: LUT_DATA = {16'h91D7};
    8'd107: LUT_DATA = {16'h91E8};
    8'd108: LUT_DATA = {16'h9120};
    8'd109: LUT_DATA = {16'h9200};
    8'd110: LUT_DATA = {16'h9306};
    8'd111: LUT_DATA = {16'h93E3};
    8'd112: LUT_DATA = {16'h9305};
    8'd113: LUT_DATA = {16'h9305};
    8'd114: LUT_DATA = {16'h9300};
    8'd115: LUT_DATA = {16'h9304};
    8'd116: LUT_DATA = {16'h9300};
    8'd117: LUT_DATA = {16'h9300};
    8'd118: LUT_DATA = {16'h9300};
    8'd119: LUT_DATA = {16'h9300};
    8'd120: LUT_DATA = {16'h9300};
    8'd121: LUT_DATA = {16'h9300};
    8'd122: LUT_DATA = {16'h9300};
    8'd123: LUT_DATA = {16'h9600};
    8'd124: LUT_DATA = {16'h9708};
    8'd125: LUT_DATA = {16'h9719};
    8'd126: LUT_DATA = {16'h9702};
    8'd127: LUT_DATA = {16'h970C};
    8'd128: LUT_DATA = {16'h9724};
    8'd129: LUT_DATA = {16'h9730};
    8'd130: LUT_DATA = {16'h9728};
    8'd131: LUT_DATA = {16'h9726};
    8'd132: LUT_DATA = {16'h9702};
    8'd133: LUT_DATA = {16'h9798};
    8'd134: LUT_DATA = {16'h9780};
    8'd135: LUT_DATA = {16'h9700};
    8'd136: LUT_DATA = {16'h9700};
    8'd137: LUT_DATA = {16'hC3ED};
    8'd138: LUT_DATA = {16'hA400};
    8'd139: LUT_DATA = {16'hA800};
    8'd140: LUT_DATA = {16'hC511};
    8'd141: LUT_DATA = {16'hC651};
    8'd142: LUT_DATA = {16'hBF80};
    8'd143: LUT_DATA = {16'hC710};
    8'd144: LUT_DATA = {16'hB666};
    8'd145: LUT_DATA = {16'hB8A5};
    8'd146: LUT_DATA = {16'hB764};
    8'd147: LUT_DATA = {16'hB97C};
    8'd148: LUT_DATA = {16'hB3AF};
    8'd149: LUT_DATA = {16'hB497};
    8'd150: LUT_DATA = {16'hB5FF};
    8'd151: LUT_DATA = {16'hB0C5};
    8'd152: LUT_DATA = {16'hB194};
    8'd153: LUT_DATA = {16'hB20F};
    8'd154: LUT_DATA = {16'hC45C};
    8'd155: LUT_DATA = {16'hC064};//default 64  CIF 32
    8'd156: LUT_DATA = {16'hC14B};//default 4B   CIF 25
    8'd157: LUT_DATA = {16'h8C00};
    8'd158: LUT_DATA = {16'h863D};
    8'd159: LUT_DATA = {16'h5000};
    8'd160: LUT_DATA = {16'h51C8};//default c8 CIF 64
    8'd161: LUT_DATA = {16'h5296};//default 96 CIF 4a
    8'd162: LUT_DATA = {16'h5300};
    8'd163: LUT_DATA = {16'h5400};
    8'd164: LUT_DATA = {16'h5500};
    8'd165: LUT_DATA = {16'h5AC8};//default c8 CIF 64
    8'd166: LUT_DATA = {16'h5B96};//default 96 CIF 4a
    8'd167: LUT_DATA = {16'h5C00};
    8'd168: LUT_DATA = {16'hD382};
    8'd169: LUT_DATA = {16'hC3ED};
    8'd170: LUT_DATA = {16'h7F00};
    8'd171: LUT_DATA = {16'hDA08};
    8'd172: LUT_DATA = {16'hE51F};
    8'd173: LUT_DATA = {16'hE167};
    8'd174: LUT_DATA = {16'hE000};//default 00 CIF 01
    8'd175: LUT_DATA = {16'hDD7F};
    8'd176: LUT_DATA = {16'h0500};
    8'd177: LUT_DATA = {16'hFF01};
    8'd178: LUT_DATA = {16'h0a61};
    default:  LUT_DATA = {16'hFF01};
    endcase
    end
endmodule