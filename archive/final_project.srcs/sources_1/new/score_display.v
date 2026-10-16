`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 05:38:50
// Design Name: 
// Module Name: score_display
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


module score_display(
    input [1:0] clk_1000,
    input [1:0] state_of_interface,
    input [13:0] score,
    output reg [7:0] ssd_out,
    output reg [3:0] ssd_ctl
    );
    reg [3:0] d4, d3, d2, d1;
    reg [7:0] SSD4, SSD3, SSD2, SSD1;
    
always@*begin
        d4 = (((score / 4'd10) / 4'd10) / 4'd10) % 4'd10;
        d3 = ((score / 4'd10) / 4'd10) % 4'd10;
        d2 = (score / 4'd10) % 4'd10;
        d1 = score % 4'd10;
    end
always@* begin
    case(d4)
       4'b0000: SSD4 = 8'b00000011;
       4'b0001: SSD4 = 8'b10011111;
       4'b0010: SSD4 = 8'b00100101;
       4'b0011: SSD4 = 8'b00001101;
       4'b0100: SSD4 = 8'b10011001;
       4'b0101: SSD4 = 8'b01001001;
       4'b0110: SSD4 = 8'b01000001;
       4'b0111: SSD4 = 8'b00011111;
       4'b1000: SSD4 = 8'b00000001;
       4'b1001: SSD4 = 8'b00001001;
       default: SSD4 = 8'b00000011;
   endcase
    case(d3)
      4'b0000: SSD3 = 8'b00000011;
      4'b0001: SSD3 = 8'b10011111;
      4'b0010: SSD3 = 8'b00100101;
      4'b0011: SSD3 = 8'b00001101;
      4'b0100: SSD3 = 8'b10011001;
      4'b0101: SSD3 = 8'b01001001;
      4'b0110: SSD3 = 8'b01000001;
      4'b0111: SSD3 = 8'b00011111;
      4'b1000: SSD3 = 8'b00000001;
      4'b1001: SSD3 = 8'b00001001;
      default: SSD3 = 8'b00000011;
   endcase
   case(d2)
      4'b0000: SSD2 = 8'b00000011;
      4'b0001: SSD2 = 8'b10011111;
      4'b0010: SSD2 = 8'b00100101;
      4'b0011: SSD2 = 8'b00001101;
      4'b0100: SSD2 = 8'b10011001;
      4'b0101: SSD2 = 8'b01001001;
      4'b0110: SSD2 = 8'b01000001;
      4'b0111: SSD2 = 8'b00011111;
      4'b1000: SSD2 = 8'b00000001;
      4'b1001: SSD2 = 8'b00001001;
      default: SSD2 = 8'b00000011;
   endcase
   case(d1)
      4'b0000: SSD1 = 8'b00000011;
      4'b0001: SSD1 = 8'b10011111;
      4'b0010: SSD1 = 8'b00100101;
      4'b0011: SSD1 = 8'b00001101;
      4'b0100: SSD1 = 8'b10011001;
      4'b0101: SSD1 = 8'b01001001;
      4'b0110: SSD1 = 8'b01000001;
      4'b0111: SSD1 = 8'b00011111;
      4'b1000: SSD1 = 8'b00000001;
      4'b1001: SSD1 = 8'b00001001;
      default: SSD1 = 8'b00000011;
   endcase
end
always@*
        case(clk_1000)
            2'b00: begin ssd_out = SSD1; ssd_ctl = 4'b1110; end
            2'b01: begin ssd_out = SSD2; ssd_ctl = 4'b1101; end
            2'b10: begin ssd_out = SSD3; ssd_ctl = 4'b1011; end
            2'b11: begin ssd_out = SSD4; ssd_ctl = 4'b0111; end
            default: begin ssd_out = 8'b00000000; ssd_ctl = 4'b1111; end
        endcase
endmodule
