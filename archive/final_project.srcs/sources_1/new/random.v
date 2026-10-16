`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 11:24:13
// Design Name: 
// Module Name: random
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


module random(
  input wire clk,
  input wire rst,
  output wire [8:0] random_num
);

  reg [8:0] state;

  always @(posedge clk or posedge rst) begin
    if (rst)
      state <= 9'b000101110; 
    else begin
      state[8] <= state[7] ^ state[4] ^ state[2]; // Feedback bit calculation
      state[7:0] <= {state[6:0], state[8]}; // Rotate bits
    end
  end
  assign random_num= state;
endmodule

