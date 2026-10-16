`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/02 14:41:05
// Design Name: 
// Module Name: mem_addr_gen
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


module mem_addr_gen(
  input [9:0] h_cnt,
  input [9:0] v_cnt,
  input [1:0] state_of_interface,
  output reg [16:0] pixel_addr
);

always@*
    if (state_of_interface == 2'b01)
        pixel_addr = (h_cnt[4:0] + 32*v_cnt[4:0]) % (1024);
    else if ((state_of_interface == 2'b00) | (state_of_interface == 2'b10) | (state_of_interface == 2'b11))
        if (v_cnt < 120 | v_cnt > 360 | h_cnt < 160 | h_cnt > 480)
          pixel_addr = 0;
        else          
          pixel_addr = (((h_cnt - 160) >> 1) + 160*((v_cnt - 120) >> 1)) % 19200;
    
            
endmodule
