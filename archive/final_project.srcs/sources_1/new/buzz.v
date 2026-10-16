`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 09:12:35
// Design Name: 
// Module Name: buzz
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


module buzz (
    clk,  // clock from crystal
    rst_n,  // active low reset
    audio_left,  // left sound audio
    audio_right,  // right sound audio
    high,
    low,
    clk_25M,
    music_state
);

  // I/O declaration
  input clk;  // clock from crystal
  input rst_n;  // active low reset
  input [15:0] high;
  input [15:0] low;
  input clk_25M;
  reg en;
  output [15:0] audio_left;  // left sound audio
  output [15:0] audio_right;  // right sound audio
  input [1:0] music_state;
  // Declare internal signals
  reg [21:0] clk_cnt_next, clk_cnt;
  //background
  reg back_clk;
  reg [22:0] tone;
  always @(posedge clk_25M) tone <= tone + 1;
  wire [6:0] ramp = (tone[22] ? tone[21:15] : ~tone[21:15]);
  wire [14:0] clkdivider = {2'b01, ramp, 6'b000000};
  reg [14:0] counter;
  always @(posedge clk_25M)
    if (counter == 0) counter <= clkdivider;
    else counter <= counter - 1;
  always @(posedge clk_25M) if (counter == 0) back_clk <= ~back_clk;

  //fire 
  reg [23:0] tone_f;
  always @(posedge clk) tone_f <= tone_f + 1;
  reg [14:0] counter_f;
  always @(posedge clk)
    if (counter_f == 0)
      counter_f <= (tone_f[23] ? 25000000 / 440 / 2 - 1 : 25000000 / 440 / 2 / 2 - 1);
    else counter_f <= counter_f - 1;
  reg hitted_clk;
  always @(posedge clk) if (counter_f == 0) hitted_clk <= ~hitted_clk;

  //hitted
  reg fire_clk, fire_clk_next;

  // Note frequency generation
  always @(posedge clk or posedge rst_n)
    if (rst_n) begin
      clk_cnt  <= 22'd0;
      fire_clk <= 1'b0;
    end else begin
      clk_cnt  <= clk_cnt_next;
      fire_clk <= fire_clk_next;
    end
  always @*
    if (clk_cnt == 22'd33333) begin
      clk_cnt_next  <= 22'd0;
      fire_clk_next <= ~fire_clk;
    end else begin
      clk_cnt_next  <= clk_cnt + 1'b1;
      fire_clk_next <= fire_clk;
    end

  // Assign the amplitude of the note
  reg b_clk;
  always @*
    case (music_state)
      2'b00:   b_clk <= back_clk;
      //2'b01:   b_clk <= 0;
      2'b01:   b_clk <= hitted_clk;
      2'b10:   b_clk <= fire_clk;
      default: b_clk <= back_clk;
    endcase
  assign audio_left  = (b_clk == 1'b0) ? high : low;
  assign audio_right = (b_clk == 1'b0) ? high : low;

endmodule
