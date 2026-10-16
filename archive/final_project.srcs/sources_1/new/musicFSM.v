`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 09:10:19
// Design Name: 
// Module Name: musicFSM
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


module musicFSM (
    clk_10,
    clk_1,
    rst,
    hit,
    fly,
    music_state
);
  input clk_10;
  input clk_1;
  input rst;
  input hit;
  input fly;
  output reg [1:0] music_state;
  reg [1:0] next;

  always @* begin
    case (music_state)
      2'b00: begin
        if (hit) next <= 2'b01;
        else if (fly) next <= 2'b10;
        else next <= music_state;
      end
      2'b01: begin
        if (hit) next <= 2'b01;
        else if (fly) next <= 2'b10;
        else next <= 2'b00;
      end
      2'b10: begin
        if (hit) next <= 2'b01;
        else next <= 2'b00;
      end
      default: next <= 2'b00;
    endcase
  end
  always @(posedge clk_10 or posedge rst)
    if (rst) music_state <= 2'b00;
    else music_state <= next;
endmodule
