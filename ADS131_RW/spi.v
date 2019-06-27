`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:46 06/27/2019 
// Design Name: 
// Module Name:    spi 
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
//开启新一轮的发送，则I_tx_en 为0至少一个周期；
//////////////////////////////////////////////////////////////////////////////////
module spi(
	input I_spi_en				,//SPI使能信号；
    input I_rst_n				,
	input I_clk					,
	input I_tx_en				,
	input I_rx_en				,
	input [7:0] I_data_in		,
	output reg [7:0] O_rx_data	,
	output reg  O_tx_done   	,
	output reg  O_rx_done		,
	
//四线标准SPI信号标准定义
	input 		I_spi_miso	,
	output reg 	O_spi_sck   ,
	output reg 	O_spi_cs    ,
	output reg 	O_spi_mosi
    );
	
	always@(posedge I_clk or negedge I_rst_n)begin
		if(!I_rst_n)begin
			O_spi_cs <= 1'b1;
		end
		else if(I_spi_en == 1'b1)begin
			O_spi_cs <= 1'b0;
		end
		else begin
			O_spi_cs <= O_spi_cs;
		end
	end
	
	//发送数据状态机
	reg [5:0] 	R_tx_state		;
	reg [5:0] 	R_rx_state		;
	
	always@(posedge I_clk or negedge I_rst_n) begin
		if(!I_rst_n) begin
			R_tx_state <= 5'd0		;
			O_spi_sck  <= 1'b0		;
			O_spi_mosi <= 1'b0		;
			O_tx_done  <= 1'b0		;
			
			R_rx_state <= 5'd0 		;
		end
		else if(I_tx_en) begin
			case(R_tx_state)
			5'd1,5'd3,5'd5,5'd7,5'd9,
			5'd11,5'd13:
				begin
					O_spi_sck <= 1'b0;
					R_tx_state <= R_tx_state + 1'b1;
					O_tx_done <= 1'b0;
				end
			5'd0://发送第7位；
				begin
					O_spi_mosi <= I_data_in[7]		;
					O_spi_sck  <= 1'b1				;
					R_tx_state <= R_tx_state +1'b1	;
					O_tx_done  <= 1'b0				;
				end
			5'd2://发送第6位；
				begin
					O_spi_mosi <= I_data_in[7]		;
					O_spi_sck  <= 1'b1				;
					R_tx_state <= R_tx_state +1'b1	;
					O_tx_done  <= 1'b0				;
				end
			5'd4://发送第5位；
				begin
					O_spi_mosi <= I_data_in[7]		;
					O_spi_sck  <= 1'b1				;
					R_tx_state <= R_tx_state +1'b1	;
					O_tx_done  <= 1'b0				;
				end
			5'd6://发送第4位；
				begin
					O_spi_mosi <= I_data_in[7]		;
					O_spi_sck  <= 1'b1				;
					R_tx_state <= R_tx_state +1'b1	;
					O_tx_done  <= 1'b0				;
				end
			5'd8://发送第3位；
				begin
					O_spi_mosi <= I_data_in[7]		;
					O_spi_sck  <= 1'b1				;
					R_tx_state <= R_tx_state +1'b1	;
					O_tx_done  <= 1'b0				;
				end
			5'd10://发送第2位；
				begin
					O_spi_mosi <= I_data_in[7]		;
					O_spi_sck  <= 1'b1				;
					R_tx_state <= R_tx_state +1'b1	;
					O_tx_done  <= 1'b0				;
				end
			5'd12://发送第1位；
				begin
					O_spi_mosi <= I_data_in[7]		;
					O_spi_sck  <= 1'b1				;
					R_tx_state <= R_tx_state +1'b1	;
					O_tx_done  <= 1'b0				;
				end
			5'd14://发送第0位；
				begin
					O_spi_mosi <= I_data_in[7]		;
					O_spi_sck  <= 1'b1				;
					R_tx_state <= R_tx_state +1'b1	;
					O_tx_done  <= 1'b0				;
				end
			5'd15://第15个状态；标志为tx_done;
				begin
					O_spi_mosi <= O_spi_mosi		;
					O_spi_sck  <= 1'b0				;
					R_tx_state <= 5'd15				;
					O_tx_done  <= 1'b1				;
				end
			default:R_tx_state <= 5'd0				;
			endcase
		end
		else if(I_rx_en)begin
			case(R_rx_state)
			5'd1,5'd3,5'd5,5'd7,5'd9,
			5'd11,5'd13:
			begin
				O_spi_sck <= 1'b1 				;
				R_rx_state <= R_rx_state + 1'b1 ;
				O_rx_done <= 1'b0				;
			end
			5'd0: begin
				O_spi_sck <= 1'b0				;
				R_rx_state <= R_rx_state + 1'b1 ;
				O_rx_done <= 1'b0				;
				O_rx_data[7] <= I_spi_miso		;
			end
			5'd2: begin
				O_spi_sck <= 1'b0				;
				R_rx_state <= R_rx_state + 1'b1 ;
				O_rx_done <= 1'b0				;
				O_rx_data[6] <= I_spi_miso		;
			end
			5'd4: begin
				O_spi_sck <= 1'b0				;
				R_rx_state <= R_rx_state + 1'b1 ;
				O_rx_done <= 1'b0				;
				O_rx_data[5] <= I_spi_miso		;
			end
			5'd6: begin
				O_spi_sck <= 1'b0				;
				R_rx_state <= R_rx_state + 1'b1 ;
				O_rx_done <= 1'b0				;
				O_rx_data[4] <= I_spi_miso		;
			end
			5'd8: begin
				O_spi_sck <= 1'b0				;
				R_rx_state <= R_rx_state + 1'b1 ;
				O_rx_done <= 1'b0				;
				O_rx_data[3] <= I_spi_miso		;
			end
			5'd10: begin
				O_spi_sck <= 1'b0				;
				R_rx_state <= R_rx_state + 1'b1 ;
				O_rx_done <= 1'b0				;
				O_rx_data[2] <= I_spi_miso		;
			end
			5'd12: begin
				O_spi_sck <= 1'b0				;
				R_rx_state <= R_rx_state + 1'b1 ;
				O_rx_done <= 1'b0				;
				O_rx_data[1] <= I_spi_miso		;
			end
			5'd14: begin
				O_spi_sck <= 1'b0				;
				R_rx_state <= R_rx_state + 1'b1 ;
				O_rx_done <= 1'b0				;
				O_rx_data[0] <= I_spi_miso		;
			end
			5'd15: begin
				O_spi_sck <= 1'b0				;
				R_rx_state <= 5'd15			    ;
				O_rx_done <= 1'b1				;
			end
			default: begin
				R_rx_state  <=  5'd0 			;
			end
			endcase
		end
		else begin
			O_spi_mosi <= 1'b0				;
			O_spi_sck  <= 1'b0				;
			R_tx_state <= 5'b0				;
			O_tx_done  <= 1'b0				;
			
			R_rx_state <= 5'd0				;
		end
	end
	
	
endmodule
