`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/21 22:42:42
// Design Name: 
// Module Name: SCCB_Timing_Control
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
//SCCB协议时序控制（协助读写配置）
module SCCB_Timing_Control(CLK, RST_n, SCCB_CLK, SCCB_DATA, CFG_size, CFG_index, CFG_data, CFG_done, CFG_rdata, ACK, Read_en);
    input CLK;//全局时钟，上升沿有效，需要24MHz的时钟
    input RST_n;//复位信号，低电平有效
    output SCCB_CLK;//SCCB协议时钟（接摄像头）
    inout SCCB_DATA;//SCCB双向传输数据（接摄像头）
    input [7:0]CFG_size;//配置模块寄存器的数量    
    input [23:0]CFG_data;//配置SCCB的数据，写入寄存器操作：3phase{ID, 地址，数据}
    output reg[7:0]CFG_index;//当前配置模块查询指定寄存器的索引
    output CFG_done;//摄像头配置完成信号
    output reg[7:0]CFG_rdata;//读取寄存器的数据
    output reg ACK;//输出应答反馈
    output Read_en;//读写使能
    
    //**********************从机地址：写时：0x60******************
    parameter p_delay_num = 100000;
    parameter p_sccb_clk = 1000;
    parameter p_SCCB_IDLE = 5'd0;//不操作状态
    parameter p_SCCB_W_START = 5'd1;//写：时序开始
    parameter p_SCCB_W_IDADDR = 5'd2;//写：输出ID地址
    parameter p_SCCB_W_ACK1 = 5'd3;//写：读取应答信号1
    parameter p_SCCB_W_REGADDR = 5'd4;//写：输出寄存器地址
    parameter p_SCCB_W_ACK2 = 5'd5;//写：读取应答信号2
    parameter p_SCCB_W_REGDATA = 5'd6;//写：输出寄存器数据
    parameter p_SCCB_W_ACK3 = 5'd7;//写：读取应答信号3
    parameter p_SCCB_W_STOP = 5'd8;//写：时序结束
    parameter p_SCCB_R_START1 = 5'd9;//读1：时序开始信号1
    parameter p_SCCB_R_IDADDR1 = 5'd10;//读1：输出ID地址
    parameter p_SCCB_R_ACK1 = 5'd11;//读1：写入应答信号1
    parameter p_SCCB_R_REGADDR = 5'd12;//读1：输出寄存器地址
    parameter p_SCCB_R_ACK2 = 5'd13;//读1：写入应答信号2
    parameter p_SCCB_R_STOP1 = 5'd14;//读1：时序结束信号
    parameter p_SCCB_R_IDLE = 5'd15;//中间跳转状态，跳转至读取装态2
    parameter p_SCCB_R_START2 = 5'd16;//读2：时序开始信号
    parameter p_SCCB_R_IDADDR2 = 5'd17;//读2：输出ID地址
    parameter p_SCCB_R_ACK3 = 5'd18;//读2：写入应答信号3
    parameter p_SCCB_R_REGDATA = 5'd19;//读2：读取寄存器
    parameter p_SCCB_R_NACK = 5'd20;//读2：读取应答信号输入
    parameter p_SCCB_R_STOP2 = 5'd21;//读2：时序结束信号
    
    reg [16:0]r_delay_cnt;//延迟计数    
    reg [16:0]r_clk_cnt;//时钟计数
    reg r_sccb_clk;//SCCB协议时钟
    reg [4:0]r_now_state;//状态机当前状态
    reg [4:0]r_next_state;//状态机下一状态
    reg [3:0]r_bit_cnt;//每一phas的传输位数计数器。0-7
    reg r_sccb_out;//要输出的数据，连接至三态门    
    wire w_sccb_in = SCCB_DATA;//要输入的数据，连接至三态门
    wire w_delay_done = (r_delay_cnt == p_delay_num) ? 1'b1 : 1'b0;//延迟完成后信号为1
    wire w_transfer_en = (r_clk_cnt == 17'd0) ? 1'b1 :1'b0;//数据发送使能信号
    wire w_capture_en = (r_clk_cnt == (2*p_sccb_clk/4) - 1'b1) ? 1'b1 :1'b0;//数据发送使能信号
    wire w_write_done;//写完信号

    //上电初期延迟
    always @ (posedge CLK or negedge RST_n)
    begin
        if (!RST_n)//复位
            r_delay_cnt <= 0;
        else if (r_delay_cnt < p_delay_num)
            r_delay_cnt <= r_delay_cnt + 1'b1;
        else
            r_delay_cnt <= r_delay_cnt;
    end
    
    //延时完成后，确定SCCB的时钟
    always @ (posedge CLK or negedge RST_n)
    begin
        if (!RST_n)//复位
            begin 
            r_clk_cnt <= 0;
            r_sccb_clk <= 0;
            end
        else if (w_delay_done)
            begin 
            if (r_clk_cnt < (p_sccb_clk - 1'b1))
                r_clk_cnt <= (r_clk_cnt + 1'd1);
            else
                r_clk_cnt <= 0;
            r_sccb_clk <= (r_clk_cnt >= (p_sccb_clk/4 + 1'b1))&&(r_clk_cnt  < (3*p_sccb_clk/4) + 1'b1) ? 1'b1 : 1'b0;
            end
        else
            begin
            r_clk_cnt <= 0;
            r_sccb_clk <= 0;
            end
    end
    
    //读取使能有效信号
    wire w_read_en = (r_now_state == p_SCCB_W_ACK1 || r_now_state == p_SCCB_W_ACK2
                    || r_now_state == p_SCCB_W_ACK3 || r_now_state == p_SCCB_R_ACK1
                    || r_now_state == p_SCCB_R_ACK2 || r_now_state == p_SCCB_R_ACK3
                    || r_now_state == p_SCCB_R_REGDATA) ? 1'b1 : 1'b0;
    assign Read_en =  w_read_en;
    //SCCB时钟输出
    assign SCCB_CLK = (r_now_state >= p_SCCB_W_IDADDR && r_now_state <= p_SCCB_W_ACK3 
                    || r_now_state >= p_SCCB_R_IDADDR1 && r_now_state <= p_SCCB_R_ACK2
                    || r_now_state >= p_SCCB_R_IDADDR2 && r_now_state <= p_SCCB_R_NACK) ? r_sccb_clk : 1'b1;

    //三态门进行输入输出的判定
    assign SCCB_DATA = (~w_read_en) ? r_sccb_out : 1'bz;
    
    //读取状态机：读取寄存器操作：4phase{ID1, 地址，ID2, 数据}
    reg r_sclk_default;
    reg [7:0]r_sccb_wdata;//暂存要写的数据
    //（1）同步时序块，格式化次态与现态
    always @ (posedge CLK or negedge RST_n)
        if (!RST_n)//重置
            r_now_state = p_SCCB_IDLE;//初始化
        else
            r_now_state = r_next_state;
    //（2）转移条件块
    always @ (*)
    begin
        r_next_state = p_SCCB_IDLE;
        case (r_now_state)
        p_SCCB_IDLE: 
            if (w_delay_done)
                r_next_state = p_SCCB_W_START;//p_SCCB_R_PRE  p_SCCB_R_START1
            else
                r_next_state = p_SCCB_IDLE;
        p_SCCB_R_START1: //开始1
            if (w_transfer_en)
                r_next_state = p_SCCB_R_IDADDR1;
            else
                r_next_state = p_SCCB_R_START1;
        p_SCCB_R_IDADDR1: //ID1
            if (w_transfer_en == 1'b1 && r_bit_cnt == 4'd8)
                r_next_state = p_SCCB_R_ACK1;
            else
                r_next_state = p_SCCB_R_IDADDR1;
        p_SCCB_R_ACK1://应答1
            if (w_transfer_en)
                r_next_state = p_SCCB_R_REGADDR;
            else
                r_next_state = p_SCCB_R_ACK1;
        p_SCCB_R_REGADDR: //寄存器地址
            if (w_transfer_en == 1'b1 && r_bit_cnt == 4'd8)
                r_next_state = p_SCCB_R_ACK2;
            else
                r_next_state = p_SCCB_R_REGADDR;
        p_SCCB_R_ACK2: //应答2
            if (w_transfer_en)
                r_next_state = p_SCCB_R_STOP1;
            else
                r_next_state = p_SCCB_R_ACK2;
        p_SCCB_R_STOP1: //停止1
            if (w_transfer_en)
                r_next_state = p_SCCB_R_IDLE;
            else
                r_next_state = p_SCCB_R_STOP1;
        p_SCCB_R_IDLE: //中间转换状态
            if (w_transfer_en)
                r_next_state = p_SCCB_R_START2;
            else
                r_next_state = p_SCCB_R_IDLE;
        p_SCCB_R_START2: //开始2
            if (w_transfer_en)
                r_next_state = p_SCCB_R_IDADDR2;
            else
                r_next_state = p_SCCB_R_START2;
        p_SCCB_R_IDADDR2: //ID2
            if (w_transfer_en == 1'b1 && r_bit_cnt == 4'd8)
                r_next_state = p_SCCB_R_ACK3;
            else
                r_next_state = p_SCCB_R_IDADDR2;
        p_SCCB_R_ACK3: //应答3
            if (w_transfer_en)
                r_next_state = p_SCCB_R_REGDATA;
            else 
                r_next_state = p_SCCB_R_ACK3;
        p_SCCB_R_REGDATA: 
            if (w_transfer_en == 1'b1 && r_bit_cnt == 4'd8)
                r_next_state = p_SCCB_R_NACK;
            else
                r_next_state = p_SCCB_R_REGDATA;
        p_SCCB_R_NACK: //NA位
            if (w_transfer_en)
                r_next_state = p_SCCB_R_STOP2;
            else
                r_next_state = p_SCCB_R_NACK;
        p_SCCB_R_STOP2: //停止2
            r_next_state = p_SCCB_R_STOP2;//保持停止状态
        /////////////////////////////////////////////////////
        p_SCCB_W_START://写：开始
            if (w_transfer_en)
                r_next_state = p_SCCB_W_IDADDR;
            else
                r_next_state = p_SCCB_W_START;
        p_SCCB_W_IDADDR://写：ID地址
            if (w_transfer_en == 1'b1 && r_bit_cnt == 4'd8)
                r_next_state = p_SCCB_W_ACK1;
            else
                r_next_state = p_SCCB_W_IDADDR;
        p_SCCB_W_ACK1://写：应答ACK1
            if (w_transfer_en)
                r_next_state = p_SCCB_W_REGADDR;
            else
                r_next_state = p_SCCB_W_ACK1;
        p_SCCB_W_REGADDR://写：寄存器地址
            if (w_transfer_en == 1'b1 && r_bit_cnt == 4'd8)
                r_next_state = p_SCCB_W_ACK2;
            else
                r_next_state = p_SCCB_W_REGADDR;
        p_SCCB_W_ACK2: //写：应答ACK2
            if (w_transfer_en)
                r_next_state = p_SCCB_W_REGDATA;
            else
                r_next_state = p_SCCB_W_ACK2;
        p_SCCB_W_REGDATA: //写：ID读地址
            if (w_transfer_en == 1'b1 && r_bit_cnt == 4'd8)
                r_next_state = p_SCCB_W_ACK3;
            else
                r_next_state = p_SCCB_W_REGDATA;
        p_SCCB_W_ACK3: //写：应答ACK3
            if (w_transfer_en)
                r_next_state = p_SCCB_W_STOP;
            else 
                r_next_state = p_SCCB_W_ACK3;
        p_SCCB_W_STOP: //写：停止*********************改***********************
            if (w_transfer_en)//完成
                if (w_write_done) //CFG_done  
                    r_next_state = p_SCCB_R_START1;//转至读取 p_SCCB_W_STOP  
                else
                    r_next_state = p_SCCB_W_START;//返回继续写入  p_SCCB_W_START
            else
                r_next_state = p_SCCB_W_STOP;//保持该状态
        endcase
    end 
    //（3）次态输出结果块（从寄存器读数据）
    always @ (negedge CLK or negedge RST_n)
    begin
        if (!RST_n)//重置
            begin
            r_sccb_out <= 1'b0;//r_next_state <= p_SCCB_IDLE;
            end
        else if (w_transfer_en)
            case (r_next_state)
            //******读状态******
            p_SCCB_R_STOP1: //停止情况
                begin
                r_sclk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                end
            p_SCCB_R_STOP2:
                begin
                r_sclk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                end
            p_SCCB_R_IDLE: //读：中间转换状态
                begin
                r_sclk_default <= 1'b1;
                r_sccb_out <= 1'b1;
                end
            p_SCCB_R_START1: //读：开始1
                begin
                r_sclk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                r_sccb_wdata <= CFG_data[23:16];//最高位的ID地址
                end
            p_SCCB_R_START2: //读：开始2
                begin
                r_sclk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                r_sccb_wdata <= CFG_data[7:0];//低位的ID地址
                end
            p_SCCB_R_IDADDR1: //读：写（也就是读）ID地址
                begin
                r_sclk_default <= 1'b0;
                r_sccb_out <= r_sccb_wdata[3'd7 - r_bit_cnt];
                end
            p_SCCB_R_IDADDR2: //读：读ID地址
                begin
                r_sclk_default <= 1'b0;
                if (r_bit_cnt < 4'd7)
                    r_sccb_out <= r_sccb_wdata[3'd7 - r_bit_cnt];
                else
                    r_sccb_out <= 1'b1;//将低位拉高
                end
            p_SCCB_R_ACK1: //读：应答1
                begin
                r_sclk_default <= 1'b0;
                r_sccb_wdata <= CFG_data[15:8];//中间位的寄存器地址
                end
            p_SCCB_R_ACK2://读：应答2
                begin
                r_sclk_default <= 1'b0;
                end
            p_SCCB_R_ACK3:
                begin
                r_sclk_default <= 1'b0;
                end
            p_SCCB_R_REGDATA: //读：寄存器数据
                begin
                r_sclk_default <= 1'b0;
                end
            p_SCCB_R_REGADDR: //读：寄存器地址
                begin
                r_sclk_default <= 1'b0;
                r_sccb_out <= r_sccb_wdata[3'd7 - r_bit_cnt];
                end
            p_SCCB_R_NACK: //读：NA状态
                begin
                r_sclk_default <= 1'b1;
                r_sccb_out <= 1'b1;
                end
            //******写状态******
            p_SCCB_W_START: //写：开始情况
                begin
                r_sclk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                r_sccb_wdata <= CFG_data[23:16];//最高位的ID地址
                end
            p_SCCB_W_IDADDR: //写：写ID地址
                begin
                r_sclk_default <= 1'b0;
                r_sccb_out <= r_sccb_wdata[3'd7 - r_bit_cnt];
                end
            p_SCCB_W_REGDATA: //写：寄存器数据
                begin
                r_sclk_default <= 1'b0;
                r_sccb_out <= r_sccb_wdata[3'd7 - r_bit_cnt];
                end
            p_SCCB_W_REGADDR: //写：寄存器地址
                begin
                r_sclk_default <= 1'b0;
                r_sccb_out <= r_sccb_wdata[3'd7 - r_bit_cnt];
                end
            p_SCCB_W_ACK1: //写：应答1
                begin
                r_sclk_default <= 1'b0;
                r_sccb_wdata <= CFG_data[15:8];//中间位的寄存器地址
                end
            p_SCCB_W_ACK2: //写：应答2
                begin
                r_sclk_default <= 1'b0;
                r_sccb_wdata <= CFG_data[7:0];//低位的写入数据
                end
            p_SCCB_W_ACK3: //写：应答3
                begin
                r_sclk_default <= 1'b0;
                end
            p_SCCB_W_STOP: //写：停止
                begin
                r_sclk_default <= 1'b1;
                r_sccb_out <= 1'b0;
                end
            default: ;//
            endcase
    end
    
    //（4）次态输出结果块（向寄存器写数据）
    //写入传输数据结束标志
    wire w_transfer_end = (r_now_state == p_SCCB_W_STOP 
                         || r_now_state == p_SCCB_R_STOP2) ? 1'b1 : 1'b0;
    always @ (negedge CLK or negedge RST_n)
    begin
        if (!RST_n)//重置
            CFG_index <= 0;
        else if (w_transfer_en)
            begin
            if (w_transfer_end && ACK == 1'b0)
                begin
                if (CFG_index < CFG_size)
                    CFG_index <= CFG_index + 1'b1;
                else
                    CFG_index <= CFG_size;
                end
            else
                CFG_index <= CFG_index;
            end
        else
            CFG_index <= CFG_index;
    end
    assign CFG_done = (CFG_index == CFG_size) ? 1'b1 : 1'b0;
    assign w_write_done = (CFG_index == (CFG_size - 1'b1)) ? 1'b1 : 1'b0;
    //（5）数据采样，即在时钟中点接受数据
    always @ (negedge CLK or negedge RST_n)
    begin
        if (!RST_n)//重置 
            CFG_rdata <= 0;//CFG_rdata
        else if (w_capture_en)
            case (r_next_state)
            p_SCCB_R_REGDATA: //读寄存器数据
                CFG_rdata <= {CFG_rdata[6:0], w_sccb_in};
            default:  ;
            endcase
    end
        
    //（6）位计数
    always @ (posedge r_sccb_clk or negedge RST_n)
    begin
        if (!RST_n)//重置
            begin
            r_bit_cnt <= 0;//CFG_rdata
            end
        else
            begin
            case (r_next_state)
            p_SCCB_R_START1: //读：开始1
                r_bit_cnt <= 0;
            p_SCCB_R_START2: //读：开始2
                r_bit_cnt <= 0;
            p_SCCB_R_IDADDR1: //读：写（也就是读）ID地址
                r_bit_cnt <= r_bit_cnt + 1'b1;
            p_SCCB_R_IDADDR2: //读：读ID地址
                r_bit_cnt <= r_bit_cnt + 1'b1;
            p_SCCB_R_ACK1: //读：应答1
                r_bit_cnt <= 0;
            p_SCCB_R_ACK2: //读：应答2
                r_bit_cnt <= 0;
            p_SCCB_R_ACK3: //读：应答3
                r_bit_cnt <= 0;
            p_SCCB_R_REGDATA: //读：寄存器数据
                r_bit_cnt <= r_bit_cnt + 1'b1;
            p_SCCB_R_REGADDR: //读：寄存器地址
                r_bit_cnt <= r_bit_cnt + 1'b1;
            /////////////////////////////
            p_SCCB_W_START: //写：开始
                r_bit_cnt <= 0; 
            p_SCCB_W_IDADDR: //写：ID地址
                r_bit_cnt <= r_bit_cnt + 1'b1;
            p_SCCB_W_REGDATA: //写：寄存器数据
                r_bit_cnt <= r_bit_cnt + 1'b1;
            p_SCCB_W_REGADDR: //写：寄存器地址
                r_bit_cnt <= r_bit_cnt + 1'b1;
            p_SCCB_W_ACK1: //写：应答1
                r_bit_cnt <= 0;
            p_SCCB_W_ACK2: //写：应答2
                r_bit_cnt <= 0;
            p_SCCB_W_ACK3: //写：应答3
                r_bit_cnt <= 0;
            endcase
            end
    end

    //（7）捕获应答信号
    reg [2:0]r_ack;//3个应答信号的记录
    always @ (posedge CLK or negedge RST_n)
    begin
        if (!RST_n)//重置
            begin
            r_ack <= 3'b111;
            ACK <= 1'b1;
            end
        else if(w_capture_en)
            begin
            case(r_next_state)
            p_SCCB_IDLE: //空闲态
                begin
                r_ack <= 3'b111;
                ACK <= 1'b1;
                end
            //******读应答******
            p_SCCB_R_ACK1:
                r_ack[0] <= w_sccb_in;
            p_SCCB_R_ACK2:
                r_ack[1] <= w_sccb_in;
            p_SCCB_R_ACK3:
                r_ack[2] <= w_sccb_in;
            p_SCCB_R_STOP2:
                ACK <= (r_ack[0] | r_ack[1] | r_ack[2]);
            //******写应答******
            p_SCCB_W_ACK1:
                r_ack[0] <= w_sccb_in;
            p_SCCB_W_ACK2:
                r_ack[1] <= w_sccb_in;
            p_SCCB_W_ACK3:
                r_ack[2] <= w_sccb_in;
            p_SCCB_W_STOP:
                ACK <= (r_ack[0] | r_ack[1] | r_ack[2]); 
            default: ;
            endcase
            end
        else
            begin
            r_ack <= r_ack;//保持
            ACK <= ACK;
            end
    end
endmodule
