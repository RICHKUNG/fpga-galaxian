`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/02 15:18:13
// Design Name: 
// Module Name: top
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


module top(
    clk, 
    vgaRed, 
    vgaGreen, 
    vgaBlue, 
    hsync, 
    vsync,
    PS2_DATA,
    PS2_CLK,
    led,
    ssd_out,
    ssd_ctl,
    audio_mclk,
    audio_lrck,
    audio_sck,
    audio_sdin,
    music_on,
    rst_ori
    );
input clk; 
input rst_ori, music_on;
inout PS2_DATA, PS2_CLK;
output [15:0] led;
output [7:0] ssd_out;
output [3:0] ssd_ctl;

output audio_mclk;
output audio_lrck;
output audio_sck;
output audio_sdin;
//when test  
output reg [3:0] vgaRed;
output reg [3:0] vgaGreen;
output reg [3:0] vgaBlue;
//output [3:0] vgaRed;
//output [3:0] vgaGreen;
//output [3:0] vgaBlue;
output hsync, vsync;
    ////vga
    wire [11:0] data;
    wire clk_25MHz;
    wire clk_22;
    wire [16:0] pixel_addr;
    reg [11:0] pixel;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
    
    //////sound
    wire [15:0] audio_in_left;
    wire [15:0] audio_in_right;
    reg hitted_en;
    reg fire_en;
    wire [1:0] music_state;
    wire hit;

    
    
    ////kryboard
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire key_valid;
    
    //////clock
    wire [1:0] clk_1000;
    wire clk_1;
    wire clk_5;
    wire clk_10;
    wire clk_100;
    wire clk_1M;
    wire rst;
    
    ////////state
    wire reset;
    wire state_clear;
    wire [13:0] score;
    wire [1:0] heart_cnt;
    wire game_over;
     assign led = {game_over, 13'd0, heart_cnt};
    
    freq U0 (
        .clk(clk),
        .rst_n(rst),
        .clk_1(clk_1),
        .clk_5(clk_5),
        .clk_10(clk_10),
        .clk_100(clk_100),
        .clk_1M(clk_1M),
        .clk_1000(clk_1000)
    );
    button Ua (
        .clk(clk),
        .clk_100(clk_100),
        .rst_n(rst),
        .pb_in(rst_ori),
        .out_pulse(rst)
    );
    // picture
    wire [11:0] monster4;
    wire [11:0] monster3;
    wire [11:0] monster2;
    wire [11:0] monster1;
    wire [11:0] robot;
    wire [11:0] background;
    wire [11:0] score3;
    wire [11:0] score2;
    wire [11:0] score1;
    wire [11:0] heart;
    wire [11:0] bullet;
    wire [11:0] explode;
    wire [11:0] start00;
    wire [11:0] start01;
    reg [11:0] start;
    wire [11:0] gameover;
    wire [11:0] clear;
    wire [11:0] clear2;
    reg [11:0] clear_pic;
    wire [11:0] bomb;
    
    
    
    wire [3:0] state_of_block;
    wire [1:0] state_of_interface;
    
      KeyboardDecoder U1 (
        .clk(clk),
        .rst(rst),
        .last_change(last_change),
        .key_down(key_down),
        .key_valid(key_valid),
        .PS2_CLK(PS2_CLK),
        .PS2_DATA(PS2_DATA)
    );
      
     /* game U7 (
          .h_cnt(h_cnt),
          .v_cnt(v_cnt),
          .rst(rst),
          .key_valid(key_valid),
          .last_change(last_change),
          .key_down(key_down),
          .led(led),
          .state_of_interface(state_of_interface),
          .state_of_block(state_of_block)
      );*/
  game_test U7 (
          .reset(reset),
          .h_cnt(h_cnt),
          .v_cnt(v_cnt),
          .valid(valid),
          //.vgaRed(vgaRed),
          //.vgaGreen(vgaGreen),
          //.vgaBlue(vgaBlue),
          .clk_fall(clk_10),
          .clk(clk),
          .clk_5(clk_5),
          .rst(rst),
          .last_change(last_change),
          .key_down(key_down),
          .key_valid(key_valid),
          .led(led),
          .state_of_block(state_of_block),
          .state_of_interface(state_of_interface),
          .state_clear(state_clear), 
          .score(score),
          .hit(hit),
          .game_over(game_over),
          .heart_cnt(heart_cnt)
      );
      score_display display_inst(
        .clk_1000(clk_1000),
        .score(score),
        .ssd_out(ssd_out),
        .ssd_ctl(ssd_ctl), 
        .state_of_interface(state_of_interface)        
      );
      
        music U2 (
          .clk(clk),
          .rst_n(rst),
          .audio_in_left(audio_in_left),
          .audio_in_right(audio_in_right),
          .audio_mclk(audio_mclk),
          .audio_lrck(audio_lrck),
          .audio_sck(audio_sck),
          .audio_sdin(audio_sdin),
          .music_state(music_state)
      );
      
        musicFSM U3 (
          .clk_10(clk_10),
          .clk_1(clk_1),
          .rst(rst),
          .hit(hit),
          .fly(key_down[9'h029]),
          .music_state(music_state)
      );
    
    wire [15:0] high;
    wire [15:0] low;
    assign high = music_on ? 16'h2664 : 16'd0;
    assign low  = music_on ? 16'hd996 : 16'd0;
    buzz Ub (
        .clk(clk),
        .rst_n(rst),
        .audio_left(audio_in_left),
        .audio_right(audio_in_right),
        .high(high),
        .low(low),
        .clk_25M(clk_25MHz),
        .music_state(music_state)
    );
    
     clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk1(clk_25MHz),
      .clk22(clk_22)
    );

    mem_addr_gen mem_addr_gen_inst(
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .state_of_interface(state_of_interface),
    .pixel_addr(pixel_addr)
    );
    
    fsm_of_interface fsm1(
        .clk_100(clk_100), 
        .rst(rst), 
        .key_valid(key_valid), 
        .last_change(last_change), 
        .key_down(key_down), 
        .state_of_interface(state_of_interface),
        .reset(reset),
        .clear(state_clear),
        .game_over(game_over)
        );
        
    monster1 monster1_inst(
          .clka(clk_25MHz),
          .wea(0),
          .addra(pixel_addr),
          .dina(data[11:0]),
          .douta(monster1)
    ); 
    
    monster2 monster2_inst(
          .clka(clk_25MHz),
          .wea(0),
          .addra(pixel_addr),
          .dina(data[11:0]),
          .douta(monster2)
    ); 
    
    monster3 monster3_inst(
          .clka(clk_25MHz),
          .wea(0),
          .addra(pixel_addr),
          .dina(data[11:0]),
          .douta(monster3)
    ); 
   monster4 monster4_inst(
          .clka(clk_25MHz),
          .wea(0),
          .addra(pixel_addr),
          .dina(data[11:0]),
          .douta(monster4)
    ); 
    
   background background_inst(
          .clka(clk_25MHz),
          .wea(0),
          .addra(pixel_addr),
          .dina(data[11:0]),
          .douta(background)
    ); 
    robot robot_inst(
           .clka(clk_25MHz),
           .wea(0),
           .addra(pixel_addr),
           .dina(data[11:0]),
           .douta(robot)
     );

     heart heart_inst(
           .clka(clk_25MHz),
           .wea(0),
           .addra(pixel_addr),
           .dina(data[11:0]),
           .douta(heart)
    );

   bullet bullet_inst(
          .clka(clk_25MHz),
          .wea(0),
          .addra(pixel_addr),
          .dina(data[11:0]),
          .douta(bullet)
      );
   explode explode_inst(
          .clka(clk_25MHz),
          .wea(0),
          .addra(pixel_addr),
          .dina(data[11:0]),
          .douta(explode)
         );
       start00 start00_inst(
           .clka(clk_25MHz),
           .wea(0),
           .addra(pixel_addr),
           .dina(data[11:0]),
           .douta(start00)
         );
         start01 start01_inst(
           .clka(clk_25MHz),
           .wea(0),
           .addra(pixel_addr),
           .dina(data[11:0]),
           .douta(start01)
         );
         clear clear_inst(
           .clka(clk_25MHz),
           .wea(0),
           .addra(pixel_addr),
           .dina(data[11:0]),
           .douta(clear)
         );
         clear2 clear2_inst(
           .clka(clk_25MHz),
           .wea(0),
           .addra(pixel_addr),
           .dina(data[11:0]),
           .douta(clear2)
         );
         gameover gameover_inst(
           .clka(clk_25MHz),
           .wea(0),
           .addra(pixel_addr),
           .dina(data[11:0]),
           .douta(gameover)
         );  
         bomb bomb_inst(
           .clka(clk_25MHz),
           .wea(0),
           .addra(pixel_addr),
           .dina(data[11:0]),
           .douta(bomb)
         ); 
         
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////VGA    
  always @*
      if (h_cnt % 32 == 0 | v_cnt % 32 == 0) pixel = 12'd0;
      else
        case (state_of_block)
          4'd0: pixel = background;
          4'd1: pixel = monster1;
          4'd2: pixel = monster2;
          4'd3: pixel = monster3;
          4'd4: pixel = monster4;
          4'd5: pixel = robot;
          4'd6: pixel = heart;
          4'd7: pixel = explode;
          4'd8: pixel = bullet;
          4'd9: pixel = bomb;
          default: pixel = 12'hFFF;
        endcase
        
always@*                              ////////////////////////////////  to let the word " press to start" flash //////////////////////////
    case(clk_1)
       1'b0: begin start = start00; clear_pic = clear; end
       1'b1: begin start = start01; clear_pic = clear2; end
       default: begin start = start00; clear_pic = clear; end
   endcase
   
  reg [9:0] hcount;        
always@(posedge clk_100 or posedge rst)
   if (rst | reset) hcount = 0;
   else if (320 > hcount) hcount <= hcount + 2;
   else hcount = hcount;
       
always@*
    if (state_of_interface == 2'b00) 
        {vgaRed, vgaGreen, vgaBlue} = start;
    else if (state_of_interface == 2'b01) 
        {vgaRed, vgaGreen, vgaBlue} = pixel;
    else if (state_of_interface == 2'b10)
        {vgaRed, vgaGreen, vgaBlue} = ((h_cnt - 160) < hcount) ? gameover : 12'h0; // gameover but capacity is not enoough
    else if (state_of_interface == 2'b11) 
        {vgaRed, vgaGreen, vgaBlue} = ((h_cnt - 160) < hcount) ? clear_pic : 12'h0;
    else 
        {vgaRed, vgaGreen, vgaBlue} = 12'b0;    
            //////////////////////////////////////////////////
    
    vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
      
endmodule
