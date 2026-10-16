`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/03 00:29:19
// Design Name: 
// Module Name: game
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


module game (
    input rst,
    input [511:0] key_down,
    input [8:0] last_change,
    input key_valid,
    input [1:0] state_of_interface,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output [15:0] led,
    output [3:0] state_of_block
);
  reg [3:0] map[14:0][19:0];
  assign state_of_block = map[v_cnt/32][h_cnt/32];
  integer i;
  integer j;
  reg [4:0] position;
  
  assign led = {key_down[9'h06b], key_down[9'h174], position};
  ////////////////////////////////////////////////////////////////////////////////////////////// keyboard function // fsm conditional signal
  // motion of robot
  always @(posedge key_valid or posedge rst)
    if (rst) position = 5'd9;
    else if ((state_of_interface == 2'b01) & key_down[9'h06b] & (position != 5'd0)) position = position - 5'd1;
    else if ((state_of_interface == 2'b01) & key_down[9'h174] & (position != 5'd19)) position = position + 5'd1;
    else position = position;
  // shoot

  /////////////////////////////////////////////////////////////////////////////////////////////  map
  // map1  
  always @* begin
    for (i = 0; i < 15; i = i + 1) begin
      for (j = 0; j < 20; j = j + 1) begin
        if (i == 0) begin
            map[i][0] = 4'd6;
            map[i][1] = 4'd6;
            map[i][2] = 4'd6;
        end
        else if (i == 1) begin
          map[i][8] = 4'd4;
          map[i][11] = 4'd4;
        end
        else if ((i == 2) && (7 <= j) && (12 >= j)) begin
            map[i][j] = 4'd3;
        end 
        else if ((i == 3) && (6 <= j) && (13 >= j)) begin
            map[i][j] = 4'd2;
        end
        else if ((i >= 4) && (i <= 7) && (5 <= j) && (14 >= j)) begin
            map[i][j] = 4'd1;
        end
        else if (i == 14 && j == position) begin
            map[i][j] = 4'd5;
        end
        else map[i][j] = 4'd0;
      end
    end
  end  
  
endmodule
