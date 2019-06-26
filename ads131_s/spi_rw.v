`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:15:08 06/26/2019 
// Design Name: 
// Module Name:    spi_rw 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spi_rw(
    input wire 			I_rst_n	  ,
	input wire 			I_clk	  ,
	input wire 			I_rx_en	  ,
	input wire 			I_tx_en	  ,
	input 		[7:0]   I_data_in ,
	output reg [23:0] 	O_data_out_0,
	output reg [23:0] 	O_data_out_1,
	output reg [23:0] 	O_data_out_2,
	output reg [23:0] 	O_data_out_3,
	output reg [23:0] 	O_data_out_4,
	output reg [23:0] 	O_data_out_5,
	output reg [23:0] 	O_data_out_6,
	output reg [23:0] 	O_data_out_7,
	
	output reg  		O_data_out_0_valid,
	output reg  		O_data_out_1_valid,
	output reg  		O_data_out_2_valid,
	output reg  		O_data_out_3_valid,
	output reg  		O_data_out_4_valid,
	output reg  		O_data_out_5_valid,
	output reg  		O_data_out_6_valid,
	output reg  		O_data_out_7_valid,
	// 四线标准SPI信号定义
	input  				I_spi_miso	,
	output reg 			O_spi_sck	,
	output  reg         O_spi_cs  	,
	output  reg         O_spi_mosi	,
	
	output reg 			O_tx_done 
    );

reg [5:0]   R_tx_state      ; 
reg [8:0]   R_rx_state      ;
reg [4:0]   R_rx_count		;
reg [23:0]  O_data_out		;
reg 		O_rx_done 		;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
        begin
            R_tx_state  <=  5'd0    ;
            R_rx_state  <=  9'd0    ;
            O_spi_cs    <=  1'b1    ;
            O_spi_sck   <=  1'b0    ;
            O_spi_mosi  <=  1'b0    ;
            O_tx_done   <=  1'b0    ;
            O_rx_done   <=  1'b0    ;
            O_data_out  <=  24'd0    ;
        end 
    else if(I_tx_en) // 发送使能信号打开的情况下
        begin
            O_spi_cs    <=  1'b0    ; // 把片选CS拉低
            case(R_tx_state)
                5'd1, 5'd3 , 5'd5 , 5'd7  , 
                5'd9, 5'd11, 5'd13, 5'd15 : //整合奇数状态
                    begin
                        O_spi_sck   <=  1'b1                ;
                        R_tx_state  <=  R_tx_state + 1'b1   ;
                        O_tx_done   <=  1'b0                ;
                    end
                5'd0:    // 发送第7位
                    begin
                        O_spi_mosi  <=  I_data_in[7]        ;
                        O_spi_sck   <=  1'b0                ;
                        R_tx_state  <=  R_tx_state + 1'b1   ;
                        O_tx_done   <=  1'b0                ;
                    end
                5'd2:    // 发送第6位
                    begin
                        O_spi_mosi  <=  I_data_in[6]        ;
                        O_spi_sck   <=  1'b0                ;
                        R_tx_state  <=  R_tx_state + 1'b1   ;
                        O_tx_done   <=  1'b0                ;
                    end
                5'd4:    // 发送第5位
                    begin
                        O_spi_mosi  <=  I_data_in[5]        ;
                        O_spi_sck   <=  1'b0                ;
                        R_tx_state  <=  R_tx_state + 1'b1   ;
                        O_tx_done   <=  1'b0                ;
                    end 
                5'd6:    // 发送第4位
                    begin
                        O_spi_mosi  <=  I_data_in[4]        ;
                        O_spi_sck   <=  1'b0                ;
                        R_tx_state  <=  R_tx_state + 1'b1   ;
                        O_tx_done   <=  1'b0                ;
                    end 
                5'd8:    // 发送第3位
                    begin
                        O_spi_mosi  <=  I_data_in[3]        ;
                        O_spi_sck   <=  1'b0                ;
                        R_tx_state  <=  R_tx_state + 1'b1   ;
                        O_tx_done   <=  1'b0                ;
                    end                            
                5'd10:    // 发送第2位
                    begin
                        O_spi_mosi  <=  I_data_in[2]        ;
                        O_spi_sck   <=  1'b0                ;
                        R_tx_state  <=  R_tx_state + 1'b1   ;
                        O_tx_done   <=  1'b0                ;
                    end 
                5'd12:    // 发送第1位
                    begin
                        O_spi_mosi  <=  I_data_in[1]        ;
                        O_spi_sck   <=  1'b0                ;
                        R_tx_state  <=  R_tx_state + 1'b1   ;
                        O_tx_done   <=  1'b0                ;
                    end 
                5'd14:    // 发送第0位
                    begin
                        O_spi_mosi  <=  I_data_in[0]        ;
                        O_spi_sck   <=  1'b0                ;
                        R_tx_state  <=  R_tx_state + 1'b1   ;
                        O_tx_done   <=  1'b1                ;
                    end
                5'd16:    // 增加一个冗余状态
                    begin
                        O_spi_sck   <=  1'b0                ;
                        R_tx_state  <=  5'd0                   ;
                        O_tx_done   <=  1'b0                ;
                    end
                default:R_tx_state  <=  5'd0                ;   
            endcase 
        end
		else if(I_rx_en)
			begin 
				O_spi_cs  <= 1'b0;
				case (R_rx_state)
				/* 9'd0,9'd2,8'd4,8'd6,8'd8,8'd10,8'd12,
				9'd14,9'd16,8'd18,8'd20,8'd22,8'd24,8'd26,
				9'd28,9'd30,8'd32,8'd34,8'd36,8'd38,8'd40,
				9'd42,9'd44,8'd46,8'd48,8'd50,8'd52,8'd54,
				9'd56,9'd58,8'd60,8'd62,8'd64,8'd66,8'd68,
				9'd70,9'd72,8'd74,8'd76,8'd78,8'd80,8'd82,
				9'd84,9'd86,8'd88,8'd90,8'd92,8'd94,8'd96,
				9'd98,9'd100,8'd102,8'd104,8'd106,8'd108,
				9'd110,9'd112,9'd114,9'd116,9'd118,8'd120,
				9'd122,9'd124,9'd126,9'd128,9'd130,8'd132,
				9'd134,9'd136,9'd138,9'd140,9'd142,
				9'd144,9'd146,9'd148,9'd150,9'd152,
				9'd154,9'd156,9'd158,9'd160,9'd162,
				9'd164,9'd166,9'd168,9'd170,9'd172,
				9'd174,9'd176,9'd178,9'd180,9'd182,
				9'd184,9'd186,9'd188,9'd190,9'd192,
				9'd194,9'd196,9'd198: */
				9'd0,9'd2,8'd4,8'd6,8'd8,8'd10,8'd12,
				9'd14,9'd16,8'd18,8'd20,8'd22,8'd24,8'd26,
				9'd28,9'd30,8'd32,8'd34,8'd36,8'd38,8'd40,
				9'd42,9'd44,8'd46,8'd48:
				begin
					O_spi_sck <= 1'b1;
					R_rx_state <= R_rx_state + 1'b1;
					O_rx_done <= 1'b0;
				end
				 5'd1:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[23]   <=  I_spi_miso          ;   
                    end
				 5'd3:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[22]   <=  I_spi_miso          ;   
                    end
				 5'd5:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[21]   <=  I_spi_miso          ;   
                    end
				 5'd7:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[20]   <=  I_spi_miso          ;   
                    end
				 5'd9:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[19]   <=  I_spi_miso          ;   
                    end
				 5'd11:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[18]   <=  I_spi_miso          ;   
                    end
				 5'd13:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[17]   <=  I_spi_miso          ;   
                    end
				 5'd15:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[16]   <=  I_spi_miso          ;   
                    end
				 5'd17:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[15]   <=  I_spi_miso          ;   
                    end
				 5'd19:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[14]   <=  I_spi_miso          ;   
                    end
				 5'd21:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[13]   <=  I_spi_miso          ;   
                    end
				5'd23:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[12]   <=  I_spi_miso          ;   
                    end
				5'd25:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[11]   <=  I_spi_miso          ;   
                    end
				5'd27:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[10]   <=  I_spi_miso          ;   
                    end
				5'd29:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[9]   <=  I_spi_miso          ;   
                    end
				5'd31:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[8]   <=  I_spi_miso          ;   
                    end
				5'd33:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[7]   <=  I_spi_miso          ;   
                    end
				5'd35:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[6]   <=  I_spi_miso          ;   
                    end
				5'd37:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[5]   <=  I_spi_miso          ;   
                    end
				5'd39:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[4]   <=  I_spi_miso          ;   
                    end
				5'd41:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[3]   <=  I_spi_miso          ;   
                    end
				5'd43:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[2]   <=  I_spi_miso          ;   
                    end
				5'd45:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[1]   <=  I_spi_miso          ;   
                    end
				5'd47:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b0                ;
                        R_rx_state      <=  R_rx_state + 1'b1   ;
                        O_rx_done       <=  1'b0                ;
                        O_data_out[0]   <=  I_spi_miso          ;   
                    end
				5'd49:    // 接收
                    begin                       
                        O_spi_sck       <=  1'b1                ;
						R_rx_count      <=  R_rx_count + 1'b1	;
						if(R_rx_count < 8)begin
						R_rx_state      <=  5'd0;
						O_rx_done       <=  1'b1; 
						end
						else begin
						R_rx_state      <=  5'd50  ;
						end 
                    end
			endcase
		end
	else 
		begin
		R_tx_state  <=  4'd0    ;
		R_rx_state  <=  5'd0    ;
		O_tx_done   <=  1'b0    ;
		O_rx_done   <=  1'b0    ;
		O_spi_cs    <=  1'b1    ;
		O_spi_sck   <=  1'b0    ;
		O_spi_mosi  <=  1'b0    ;
		O_data_out  <=  24'd0   ;
		R_rx_count  <=  4'd0	;
		end
end

always @(posedge I_clk or negedge I_rst_n)
begin
	if(!I_rst_n)
		begin
		O_data_out_0 <= 24'd0	;
		O_data_out_1 <= 24'd0	;
		O_data_out_2 <= 24'd0	;
		O_data_out_3 <= 24'd0	;
		O_data_out_4 <= 24'd0	;
		O_data_out_5 <= 24'd0	;
		O_data_out_6 <= 24'd0	;
		O_data_out_7 <= 24'd0	;
		O_data_out_0_valid <= 1'b0;
		O_data_out_1_valid <= 1'b0;
		O_data_out_2_valid <= 1'b0;
		O_data_out_3_valid <= 1'b0;
		O_data_out_4_valid <= 1'b0;
		O_data_out_5_valid <= 1'b0;
		O_data_out_6_valid <= 1'b0;
		O_data_out_7_valid <= 1'b0;
		end
	else if(O_rx_done == 1'b1 && R_rx_count == 5'd0) begin
	O_data_out_0 <= O_data_out	;
	O_data_out_0_valid <= 1'b1;
	end
	else if(O_rx_done == 1'b1 && R_rx_count == 5'd1) begin
	O_data_out_1 <= O_data_out	;
	O_data_out_1_valid <= 1'b1;
	end
	else if(O_rx_done == 1'b1 && R_rx_count == 5'd2) begin
	O_data_out_2 <= O_data_out	;
	O_data_out_2_valid <= 1'b1;
	end
	else if(O_rx_done == 1'b1 && R_rx_count == 5'd3) begin
	O_data_out_3 <= O_data_out	;
	O_data_out_3_valid <= 1'b1;
	end
	else if(O_rx_done == 1'b1 && R_rx_count == 5'd4) begin
	O_data_out_4 <= O_data_out	;
	O_data_out_4_valid <= 1'b1;
	end
	else if(O_rx_done == 1'b1 && R_rx_count == 5'd5) begin
	O_data_out_5 <= O_data_out	;
	O_data_out_5_valid <= 1'b1;
	end
	else if(O_rx_done == 1'b1 && R_rx_count == 5'd6) begin
	O_data_out_6 <= O_data_out	;
	O_data_out_6_valid <= 1'b1;
	end
	else if(O_rx_done == 1'b1 && R_rx_count == 5'd7) begin
	O_data_out_7 <= O_data_out	;
	O_data_out_7_valid <= 1'b1;
	end
	else begin
	O_data_out_0 <= 24'd0	;
	O_data_out_1 <= 24'd0	;
	O_data_out_2 <= 24'd0	;
	O_data_out_3 <= 24'd0	;
	O_data_out_4 <= 24'd0	;
	O_data_out_5 <= 24'd0	;
	O_data_out_6 <= 24'd0	;
	O_data_out_7 <= 24'd0	;
	O_data_out_0_valid <= 1'b0;
	O_data_out_1_valid <= 1'b0;
	O_data_out_2_valid <= 1'b0;
	O_data_out_3_valid <= 1'b0;
	O_data_out_4_valid <= 1'b0;
	O_data_out_5_valid <= 1'b0;
	O_data_out_6_valid <= 1'b0;
	O_data_out_7_valid <= 1'b0;
	end
end

endmodule
