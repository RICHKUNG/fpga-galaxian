`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/03 00:45:41
// Design Name: 
// Module Name: freq
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


module freq (
    input clk,
    input rst_n,
    output reg clk_1,
    output reg clk_10,
    output reg clk_5,
    output reg [1:0] clk_1000,
    output reg clk_100,
    output reg clk_1M
);
  reg [25:0] q;
  reg [25:0] q_tmp;
  reg [25:0] p;
  reg [25:0] p_tmp;
  reg [25:0] cnt3, cnt4, cnt5;
  always @* clk_1000 <= {q[16], q[15]};

  /////// clk_3
  always @(posedge clk or negedge rst_n)
    if (rst_n) begin
      cnt3   <= 0;
      clk_10 <= 0;
    end else if (cnt3 == 5000000) begin
      cnt3   <= 0;
      clk_10 <= ~clk_10;
    end else begin
      cnt3   <= cnt3 + 1;
      clk_10 <= clk_10;
    end
    
      always @(posedge clk or negedge rst_n)
      if (rst_n) begin
        cnt4   <= 0;
        clk_1M <= 0;
      end else if (cnt4 == 54) begin
        cnt4   <= 0;
        clk_1M <= ~clk_1M;
      end else begin
        cnt4   <= cnt4 + 1;
        clk_1M <= clk_1M;
      end
  
      always @(posedge clk or negedge rst_n)
        if (rst_n) begin
          cnt5   <= 0;
          clk_5 <= 0;
        end else if (cnt5 == 26'd10000000) begin
          cnt5   <= 0;
          clk_5 <= ~clk_5;
        end else begin
          cnt5   <= cnt5 + 1;
          clk_5 <= clk_5;
        end

  always @* q_tmp = q + 1'b1;
  always @(posedge clk or posedge rst_n)
    if (rst_n) begin
      q <= 26'd0;
      clk_1 <= 0;
    end else if (q == 26'd50000000) begin
      q <= 26'd0;
      clk_1 <= ~clk_1;
    end else q <= q_tmp;

  always @* p_tmp = p + 1'b1;
  always @(posedge clk or posedge rst_n)
    if (rst_n) begin
      p <= 26'd0;
      clk_100 <= 0;
    end else if (p == 26'd500000) begin
      p <= 26'd0;
      clk_100 <= ~clk_100;
    end else p <= p_tmp;
endmodule
