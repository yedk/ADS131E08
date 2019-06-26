`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:59 06/25/2019 
// Design Name: 
// Module Name:    spi_wb 
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
// 通过spi发送1个字节的数据；
//////////////////////////////////////////////////////////////////////////////////
module spi_wb(
    input wire I_clk,
	input wire I_rst_n,
	input wire I_tx_en,
	output reg O_tx_done,
    input [7:0] I_data_in,
	
	//四线标准SPI信号定义
	input 		I_spi_miso,
	output reg  O_spi_sck,
	output reg  O_spi_cs,
	output reg  O_spi_mosi
    );

reg [4:0]   R_tx_state      ; 

always @(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
        begin
            R_tx_state  <=  5'd0    ;
            O_spi_cs    <=  1'b1    ;
            O_spi_sck   <=  1'b0    ;
            O_spi_mosi  <=  1'b0    ;
            O_tx_done   <=  1'b0    ;
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
    else
        begin
            R_tx_state  <=  4'd0    ;
            O_tx_done   <=  1'b0    ;
            O_spi_cs    <=  1'b1    ;
            O_spi_sck   <=  1'b0    ;
            O_spi_mosi  <=  1'b0    ;
        end      
end
endmodule
