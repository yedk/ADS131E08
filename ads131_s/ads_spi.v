`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:51:35 06/18/2019 
// Design Name: 
// Module Name:    ads_spi 
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
module ads_spi(
//AD一侧的接口;
    output  SCLK,
	output  CS,
	input   DIN,
	output  DOUT,
	input  DRDY,
	output START,
	output RESET,
	output PWDN,
//FPGA一侧接口;
	input 		  rst_n,//复位低有效；
	input 		  clk_50M,//时钟50MHZ;
	input 		  CLK_IN,
	output 		  CLK_OUT,
	output [23:0] data_out,
	output 		  data_valid
    );
	
//SPI模块；	
reg 		I_rst_n;
reg 		I_rx_en;
reg 		I_tx_en;
reg [7:0]   I_data_in;
	
spi_rw u_spi_rw(
.I_rst_n	  				(I_rst_n),//    input wire 			
.I_clk	  					(),//	input wire 			
.I_rx_en	  				(I_rx_en),//	input wire 			
.I_tx_en	  				(I_tx_en),//	input wire 			
.I_data_in 					(I_data_in),//	input 		[7:0]   
.O_data_out_0				(),//	output reg [23:0] 	
.O_data_out_1				(),//	output reg [23:0] 	
.O_data_out_2				(),//	output reg [23:0] 	
.O_data_out_3				(),//	output reg [23:0] 	
.O_data_out_4				(),//	output reg [23:0] 	
.O_data_out_5				(),//	output reg [23:0] 	
.O_data_out_6				(),//	output reg [23:0] 	
.O_data_out_7				(),//	output reg [23:0] 	
.O_data_out_0_valid			(),//	output reg
.O_data_out_1_valid			(),//	output reg  		
.O_data_out_2_valid			(),//	output reg  		
.O_data_out_3_valid			(),//	output reg  		
.O_data_out_4_valid			(),//	output reg  		
.O_data_out_5_valid			(),//	output reg  		
.O_data_out_6_valid			(),//	output reg  		
.O_data_out_7_valid			(),//	output reg  
.I_spi_miso					(DIN),//
.O_spi_sck                  (SCLK),//
.O_spi_cs                   (CS),//
.O_spi_mosi					(DOUT),//
.O_tx_done              	()  //	output reg  		
    ); 	
	

	
//SPI配置读写状态机
localparam [2:0] ADS_START = 3'b001;
localparam [2:0] ADS_INIT  = 3'b010;
localparam [2:0] ADS_READ  = 3'b100;

reg [3:0] ADS_state ;
//定时器模块，用来控制发送指令的时间延时；
reg [20:0] cnt ;
reg 	   timer_en ;
always @(posedge clk_50M or negedge rst_n) begin
	if(!rst_n) begin
		cnt <= 21'h0;
	end
	else if(timer_en == 1)begin
		cnt <= cnt + 1'b1;
	end
	else begin
		cnt <= cnt;
	end
end

always@(posedge clk_50M or negedge rst_n) begin
	if(!rst_n) begin
		ADS_state <= ADS_START;
	end
	else begin
		case (ADS_state)
			ADS_START :
			ADS_state <= ADS_INIT;
			ADS_INIT:if(ads_init_done == 1)begin
				ADS_state <= ADS_READ;
			end
			else begin
				ADS_state <= ADS_INIT;
			end
			ADS_READ: ADS_state <= ADS_READ;
			default: begin
			ADS_state <= ADS_START;
			end
		endcase
	end
end

wire [7:0] memory [0:18];
assign memory[0] = 8'h11;
assign memory[1] = 8'h41;
assign memory[2] = 8'h02;
assign memory[3] = 8'hD6;
assign memory[4] = 8'hE3;
assign memory[5] = 8'h40;
assign memory[6] = 8'h45;
assign memory[7] = 8'h07;
assign memory[8] = 8'h10;
assign memory[9] = 8'h10;
assign memory[10] = 8'h10;
assign memory[11] = 8'h10;
assign memory[12] = 8'h10;
assign memory[13] = 8'h10;
assign memory[14] = 8'h10;
assign memory[15] = 8'h10;
assign memory[16] = 8'h20;
assign memory[17] = 8'h00;
assign memory[18] = 8'h10;

reg CS_INIT		;
reg START_INIT  ;
reg RESET_INIT  ;
reg PWDN_INIT   ;

reg  

//控制状态机第二段；
always@(posedge clk_50M or negedge rst_n) begin
	if(!rst_n) begin
	I_rst_n <= 1'b0;
	I_data_in <= 8'd0;
	I_tx_en <= 1'b0;
	I_rx_en <= 1'b0;
	end
	else begin
		case(ADS_state)
			ADS_START ：begin
			I_rst_n <= 1'b1;
			end
			ADS_INIT : begin
			timer_en <= 1'b1;
				if()begin
				end
				else if()begin
				end
				else begin
				end
			end
			ADS_READ : begin
			
			end
			default: begin
			
			end
		endcase
	end
end


                    	                           	 			

endmodule
