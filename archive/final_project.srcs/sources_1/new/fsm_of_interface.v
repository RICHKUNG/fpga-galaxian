`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/03 01:33:05
// Design Name: 
// Module Name: fsm_of_interface
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


module fsm_of_interface (clk_100, rst, key_valid, last_change, key_down, state_of_interface, reset, clear, game_over);
input clk_100, rst;
input key_valid;
input [8:0] last_change;
input [511:0] key_down;
input game_over;
wire start;
wire restart;
input clear;
output reg [1:0] state_of_interface;
output reg reset;
reg [1:0] next_state;

// keyboard to temporarily replace with qualification
    assign start = key_down[9'h05A] & (state_of_interface == 2'b00);
    //assign gameover = key_down[9'h034] & (state_of_interface == 2'b01);
    //assign clear = key_down[9'h021] & (state_of_interface == 2'b01);
    assign restart = key_down[9'h02D] & ((state_of_interface == 2'b10)|(state_of_interface == 2'b11));

//////

always@*
    case(state_of_interface)
    // to start
    2'b00: if (start) begin next_state = 2'b01; reset = 1; end
        else begin next_state = 2'b00; reset = 0; end
    // in game
    2'b01: if (game_over) begin next_state = 2'b10; reset = 1;end
        else if (clear) begin next_state = 2'b11; reset = 1;end
        else begin next_state = 2'b01;reset = 0; end
    // gameover
    2'b10: if (restart) begin next_state = 2'b00; reset = 1;end
        else begin next_state = 2'b10; reset = 0; end
    // clear
    2'b11: if (restart) begin next_state = 2'b00; reset = 1; end
        else begin next_state = 2'b11; reset = 0; end
    default: begin next_state = 2'b00; reset = 0;end
    endcase 
    
always@(posedge clk_100 or negedge rst)
    if (rst) state_of_interface <= 2'b00;
    else state_of_interface <= next_state;    
    
endmodule
