`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/06 17:24:39
// Design Name: 
// Module Name: game_test
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


module game_test (
    input clk_fall,
    input clk,
    input clk_5,
    input rst,
    input valid,
    input reset,
    input [511:0] key_down,
    input [8:0] last_change,
    input key_valid,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    //output [3:0] vgaRed,
    //output [3:0] vgaGreen,
    //output [3:0] vgaBlue,
    output [15:0] led,
    ////////////////////////////////////////////////////////////////////////////
    input [1:0] state_of_interface,
    output [3:0] state_of_block, //// state
    output reg state_clear,
    output reg [13:0] score,
    output reg hit,
    output reg game_over,
    output reg [1:0] heart_cnt
);
  reg [3:0] map[14:0][19:0];
  assign state_of_block = map[v_cnt/32][h_cnt/32]; //// state
  integer i;
  integer j;
  reg [4:0] position;
  reg [4:0] position_next;
  reg [4:0] position_record_i;
  reg [4:0] position_record_j;
  reg [11:0] pixel;
  reg [4:0] bullet_pos_i;
  reg [4:0] bullet_pos_j;
  reg [4:0] bullet_pos_i_next;
  reg [4:0] bullet_pos_j_next;
  reg fly;
  reg fly_next;
  reg miss;
  //assign {vgaRed, vgaGreen, vgaBlue} = pixel;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////state
  //assign led = {fly_next ,fly, hit, position_record_i, position_record_j};
  reg hit_cnt;
  ////////////////////////////////////////////////////////////////////////////////////////////// keyboard function // fsm conditional signal
  // motion of robot
  always @(posedge key_down[last_change] or posedge rst)
    if (rst) position_next = 5'd9;
    else if (key_down[9'h06b] & (position != 5'd0)) position_next = position - 5'd1;
    else if (key_down[9'h174] & (position != 5'd19)) position_next = position + 5'd1;
    else position_next = position;
  always @(posedge clk or posedge rst)
    if (rst) position = 5'd9;
    else position <= position_next;
  // shoot
  reg clk_choose;
  always@*
    if (fly_next) clk_choose = clk_fall;
    else clk_choose = clk;
  always@*
      if (fly) 
        position_record_j = position_record_j;    
      else 
        position_record_j = position;
  always@*
    if (fly_next) position_record_i = bullet_pos_i;
    else position_record_i = position_record_i;

    
  always @(posedge clk_choose or posedge hit or posedge rst)
    if (rst | hit | miss) begin
      bullet_pos_i_next = 5'd14;
      bullet_pos_j_next = position;
    end else if (fly_next) begin
      bullet_pos_i_next = bullet_pos_i - 5'd1;
      bullet_pos_j_next = bullet_pos_j;
    end else begin
      bullet_pos_i_next = 5'd14;
      bullet_pos_j_next = position;
    end
  always @(posedge clk or posedge rst)
    if (rst | hit) bullet_pos_i = 5'd14;
    else bullet_pos_i = bullet_pos_i_next;

  always @(posedge clk or posedge rst)
    if (rst | hit) bullet_pos_j = position;
    else bullet_pos_j = bullet_pos_j_next;
    
  always @*
    case (fly)
      1'b1:
      if (hit | miss) fly_next = 0;
      else fly_next = fly_next;
      1'b0:
      if (key_down[9'h029]) fly_next = 1;
      else fly_next = fly_next;
      default: fly_next = fly_next;
    endcase
  always @(posedge clk or posedge rst)
    if (rst) fly = 0;
    else fly <= fly_next;

  //hit or not

  always @(negedge clk_choose or posedge rst)
    if (rst) begin
      hit = 0;
      miss = 0;
      hit_cnt = 0;
    end
    else if((map[bullet_pos_i-1][position_record_j]==4'd1)|(map[bullet_pos_i-1][position_record_j]==4'd2)|(map[bullet_pos_i-1][position_record_j]==4'd3)|(map[bullet_pos_i-1][position_record_j]==4'd4))
      begin
      hit  = 1;
      miss = 0;
    end else if (bullet_pos_i == 0 | ((bullet_pos_j == 0) & (bullet_pos_i == 1)) | ((bullet_pos_j == 1) & (bullet_pos_i == 1)) | ((bullet_pos_j == 2) & (bullet_pos_i == 1))) begin
      hit  = 0;
      miss = 1;
    end else begin
      hit  = 0;
      miss = 0;
    end
  //////////////////////////////////////////////////////////////////////////////////////////////bomb
   ////////////////////////////////////////////////////////////////////////////////bomb
     
     reg [4:0] bomb_i;
     reg bomb_end;
     always @(posedge clk_fall or posedge rst) begin
       bomb_end <= 0;
       if (rst | (state_of_interface != 2'b01)) bomb_i <= 5'd8;
       else if (bomb_i < 5'd14) bomb_i <= bomb_i + 1'd1;
       else begin
         bomb_i   <= 5'd8;
         bomb_end <= 1;
       end
     end
     wire [8:0] ran;
     reg  [4:0] idx;
     random Ur (
         .clk(clk),
         .rst(rst),
         .random_num(ran)
     );
     always @(posedge bomb_end) idx = ran % 20;
     always @(posedge clk_fall or posedge rst)
       if (rst | state_of_interface == 2'b00) heart_cnt = 2'd3;
       else if ((bomb_i == 5'd14) && (idx == position_next) && (heart_cnt != 2'd0))
         heart_cnt = heart_cnt - 1'd1;
       else heart_cnt = heart_cnt;
   
     always @*
       if (heart_cnt == 2'd0) game_over = 1;
       else game_over = 0;
  /////////////////////////////////////////////////////////////////////////////////////////////  map
  // map1  

  always @(posedge clk or posedge rst)
    if (rst | state_of_interface == 2'b00) begin
        score = 0; 
        for (i = 0; i < 15; i = i + 1) begin
          for (j = 0; j < 20; j = j + 1) begin
            if (i == 0) begin
              map[i][0] = 4'd6;
              map[i][1] = 4'd6;
              map[i][2] = 4'd6;
            end else if (i == 14 && j == 9) begin
              map[i][j] = 4'd5;
            end else if (i == 1) begin
              map[i][8]  = 4'd4;
              map[i][11] = 4'd4;
            end else if ((i == 2) && (7 <= j) && (12 >= j)) begin
              map[i][j] = 4'd3;
            end else if ((i == 3) && (6 <= j) && (13 >= j)) begin
              map[i][j] = 4'd2;
            end else if ((i >= 4) && (i <= 7) && (5 <= j) && (14 >= j)) begin
              map[i][j] = 4'd1;
            end else map[i][j] = 4'd0;
          end
        end
      end
    else if (miss) begin
        if (score < 225) score = 0;
            else score = score - 225;
        map[position_record_i][position_record_j] <= 4'd0;
        map[14][position] = 4'd0;
        map[14][position_next] = 4'd5;
     end
     else if (hit) begin
        map[position_record_i-1][position_record_j] <= 4'd0;
        map[position_record_i][position_record_j] <= 4'd0;
        map[14][position] = 4'd0;
        map[14][position_next] = 4'd5;
      if (map[position_record_i-1][position_record_j] == 4'd1) score = score + 60;
        else if (map[position_record_i-1][position_record_j] == 4'd2) score = score + 120;
        else if (map[position_record_i-1][position_record_j] == 4'd3) score = score + 180;
        else if (map[position_record_i-1][position_record_j] == 4'd4) score = score + 240;
        else score = score;
      end else begin
      if (heart_cnt == 2'd2)  map[0][2] = 4'd0;
      else if (heart_cnt == 2'd1) map[0][1] = 4'd0;
      else if (heart_cnt == 2'd0) map[0][0] = 4'd0;
        for (i = 0 ; i < 15 ; i = i + 1)
            for (j = 0; j < 20; j = j + 1)
                if (map[i][j] > 7 | ((map[i][j] == 1) & (i > 7))) map[i][j] = 4'd0;
      map[bullet_pos_i_next][bullet_pos_j_next] = 4'd8;
      map[14][position] = 4'd0;
      map[14][position_next] = 4'd5;
      map[bomb_i][idx] <= 4'd9;
      score = score;
    end
    //////////////////////////////////////////////STATE CHECK
    integer sum;
    initial sum = 0;
         
    always@*begin
        for (i = 1; i < 8; i = i+1)
            for (j = 0; j < 20; j = j + 1) begin
                sum = sum + map[i][j];
            end                
       if (sum == 0) state_clear <= 1;
       else begin state_clear <= 0; sum <= 0; end
       end
    
  //////////////////////////////////////////////////////////////////////////////VGA
  /*always @*
    if (h_cnt % 32 == 0 | v_cnt % 32 == 0) pixel = 12'd0;
    else
      case (map[v_cnt/32][h_cnt/32])
        4'd0: pixel = 12'hFFF;
        4'd1: pixel = 12'h00F;  //monster1
        4'd2: pixel = 12'h0FF;  //monster2
        4'd3: pixel = 12'hFF0;  //monster3
        4'd4: pixel = 12'hF80;  //monster4
        4'd5: pixel = 12'hF00;  //robot
        4'd6: pixel = 12'hF08;  //heart
        4'd7: pixel = 12'h808;
        4'd8: pixel = 12'h800;  //bullet
        4'd9: pixel = 12'h888;
        4'd9: pixel = 12'h888;
        4'd9: pixel = 12'h888;
        default: pixel = 12'h000;
      endcase*/
endmodule
