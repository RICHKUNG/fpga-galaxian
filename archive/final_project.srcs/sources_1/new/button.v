`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 09:07:43
// Design Name: 
// Module Name: button
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


module button (
    clk,
    clk_100,  // Clock from crystal
    rst_n,  //active low reset
    pb_in,  //push button input
    out_pulse  // LED display output (1 pulse)
);
  input clk;  // Clock from crystal
  input clk_100;
  input rst_n;  //active low reset
  input pb_in;  //push button input
  output reg out_pulse;  // LED display output (1 pulse)
  reg pb_debounced;  // debounced push button output
  reg pb_debounced_delay;


  //////////debounce
  // declare the internal nodes
  reg [4-1:0] debounce_window;  // shift register flip flop
  reg pb_debounced_next;  // debounce result
  // Shift register
  always @(posedge clk_100 or posedge rst_n)
    if (rst_n) debounce_window <= 4'd0;
    else debounce_window <= {debounce_window[4-2:0], pb_in};

  // debounce circuit
  always @*
    if (debounce_window == 4'b1111) pb_debounced_next = 1'b1;
    else pb_debounced_next = 1'b0;

  always @(posedge clk_100 or posedge rst_n)
    if (rst_n) pb_debounced <= 1'b0;
    else pb_debounced <= pb_debounced_next;

  /////////////////////////////////////


  // Buffer input
  always @(posedge clk or posedge rst_n)
    if (rst_n) pb_debounced_delay <= 1'b0;
    else pb_debounced_delay <= pb_debounced;

  // Pulse generation
  assign out_pulse_next = pb_debounced & (~pb_debounced_delay);

  always @(posedge clk or posedge rst_n)
    if (rst_n) out_pulse <= 1'b0;
    else out_pulse <= out_pulse_next;
endmodule

