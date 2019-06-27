`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:43:40 06/27/2019 
// Design Name: 
// Module Name:    top 
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
module top(
    input I_clk_50M			,
    input I_rst_n			,
	
	output 		SCLK		,
	output 		CS			,
	output 		DIN			,
	input 		DOUT		,
	
	input 		DRDY		,
	output reg 		START		,
	output reg 		RESET		,
	output reg 		PWDN		
    );

reg 	I_spi_en	;
wire 	I_clk		;
reg 	I_tx_en		;
reg 	I_data_in	;
wire 	O_tx_done	;
wire 	O_rx_done	;

reg 	I_rx_en		;
wire [7:0] O_rx_data;

spi spi_u(
.I_spi_en			(I_spi_en),//SPI使能信号；
.I_rst_n			(I_rst_n),
.I_clk				(I_clk),//4MHZ速度
.I_tx_en			(I_tx_en),
.I_rx_en			(I_rx_en),
.I_data_in			(I_data_in),
.O_tx_done   		(O_tx_done),
.O_rx_done			(O_rx_done),
.O_rx_data			(O_rx_data),
.I_spi_miso			(DOUT),
.O_spi_sck   		(SCLK),
.O_spi_cs   		(CS),
.O_spi_mosi         (DIN)
    );
//读寄存器0；
wire  rd_reg0       		;
wire  rd_reg1 				;

assign rd_reg0	= 8'h20		;
assign rd_reg1  = 8'h00		;//读寄存器0；

localparam  WRITE_0 = 4'b0001;
localparam  WRITE_1 = 4'b0010;
localparam  READ_0  = 4'b0100;
localparam  STA     = 4'b1000;

reg  [7:0] rx_data_done;

reg [3:0]	SPI_STATE;
always@(posedge I_clk_50M or negedge I_rst_n) begin
	if(!I_rst_n)begin
		SPI_STATE <= STA;
		I_spi_en <= 1'b0;
		I_tx_en <= 1'b0;
		I_data_in <= 8'h0;
		rx_data_done <= 8'h0;
		
		START <= 1'b0;
		PWDN  <= 1'b1;
		RESET <= 1'b1;
	end
	else begin
		case(SPI_STATE)
			STA : 
			begin
				I_spi_en <= 1'b1;//使能SPI模块；
				SPI_STATE <= WRITE_0;
			end
			WRITE_0:
			begin
				I_tx_en <= 1'b1;
				I_data_in <= rd_reg0;
				if(O_tx_done)begin
					SPI_STATE <= WRITE_0;
					I_tx_en <= 1'b0;
				end
				else begin
					SPI_STATE <= WRITE_1;
				end
			end
			WRITE_1:
			begin
				I_tx_en <= 1'b1;
				I_data_in <= rd_reg0;
				if(O_tx_done)begin
					SPI_STATE <= WRITE_1;
					I_tx_en <= 1'b0;
				end
				else begin
					SPI_STATE <= READ_0;
				end
			end
			READ_0:
			begin
				I_rx_en <= 1'b1;
				if(O_rx_done) begin
					rx_data_done <= O_rx_data;
					SPI_STATE <= READ_0;
				end
				else begin
					rx_data_done <= rx_data_done;
				end
			end
			default:SPI_STATE <= STA;
		endcase
	end
end


endmodule
