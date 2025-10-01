module pong (
  input i_Clk,
  input i_Switch_1,
  input i_Switch_2,
  input i_Switch_3,
  input i_Switch_4,
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4,
  output o_Segment1_A,
  output o_Segment1_B,
  output o_Segment1_C,
  output o_Segment1_D,
  output o_Segment1_E,
  output o_Segment1_F,
  output o_Segment1_G,
  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G,
  output o_VGA_Red_0,
  output o_VGA_Red_1,
  output o_VGA_Red_2,
  output o_VGA_Grn_0,
  output o_VGA_Grn_1,
  output o_VGA_Grn_2,
  output o_VGA_Blu_0,
  output o_VGA_Blu_1,
  output o_VGA_Blu_2,
  output o_VGA_HSync,
  output o_VGA_VSync
  );

  parameter total_col = 800,
            total_row = 525,
            active_col = 640,
            active_row = 480;
  
  wire [9:0] w_X_Cursor;
  wire [9:0] w_Y_Cursor;

  wire [9:0] w_P1_left;
  wire [9:0] w_P1_right;
  wire [9:0] w_P1_top;
  wire [9:0] w_P1_bottom;
  wire [9:0] w_P2_left;
  wire [9:0] w_P2_right;
  wire [9:0] w_P2_top;
  wire [9:0] w_P2_bottom;
  wire [9:0] w_B_left;
  wire [9:0] w_B_right;
  wire [9:0] w_B_top;
  wire [9:0] w_B_bottom;
  
  wire [1:0] game_result;
  
  reg [1:0] device_state = 0;	// 0 is start, 1 is game, 2 is scored, 3 is finished
  reg r_en = 0;
  reg [5:0] r_p1_score = 0;
  reg [5:0] r_p2_score = 0;
  
	always @(posedge i_Clk) begin
		if (device_state == 0) begin
			if (i_Switch_1 == 1 || i_Switch_2 == 1 || i_Switch_3 == 1 || i_Switch_4 == 1 || r_en == 1)begin
				device_state <= 1;
				r_en <= 1;
			end
		end else if (device_state == 1) begin
			if (game_result != 0) begin
				if (game_result == 1) begin
					r_p1_score <= r_p1_score + 1;
				end else if (game_result == 2) begin
					r_p2_score <= r_p2_score + 1;
				end
				if (r_p1_score == 9 || r_p2_score == 9) begin
					device_state <= 3;
				end else begin
					device_state <= 2;
				end
				r_en <= 0;
			end
		end else if (device_state == 2) begin
			if (i_Switch_1 == 1 || i_Switch_2 == 1 || i_Switch_3 == 1 || i_Switch_4 == 1 || r_en == 1)begin
				device_state <= 1;
				r_en <= 1;
			end
		end else begin
			if (i_Switch_1 == 1 || i_Switch_2 == 1 || i_Switch_3 == 1 || i_Switch_4 == 1 || r_en == 1)begin
				r_p1_score <= 0;
				r_p2_score <= 0;
				device_state <= 1;
				r_en <= 1;
			end
		end
		
	end

  bin_to_7seg U_BIN2SEG(
    .i_bin({r_p1_score[3:0], r_p2_score[3:0]}),
    .o_Segment1_A(o_Segment1_A),
    .o_Segment1_B(o_Segment1_B),
    .o_Segment1_C(o_Segment1_C),
    .o_Segment1_D(o_Segment1_D),
    .o_Segment1_E(o_Segment1_E),
    .o_Segment1_F(o_Segment1_F),
    .o_Segment1_G(o_Segment1_G),
    .o_Segment2_A(o_Segment2_A),
    .o_Segment2_B(o_Segment2_B),
    .o_Segment2_C(o_Segment2_C),
    .o_Segment2_D(o_Segment2_D),
    .o_Segment2_E(o_Segment2_E),
    .o_Segment2_F(o_Segment2_F),
    .o_Segment2_G(o_Segment2_G)
    );

// debounce is not needed for the switch since the module only process switch input after consecutive switch input
  paddle #(.X_center(49)) Paddle1 (
		.i_Clk(i_Clk),
		.i_up(i_Switch_1),
		.i_down(i_Switch_2),
		.i_enable(r_en),
		.o1(o_LED_1),
		.o2(o_LED_2),
		.o_left(w_P1_left),
		.o_right(w_P1_right),
		.o_top(w_P1_top),
		.o_bottom(w_P1_bottom)
    );
	
  paddle #(.X_center(active_col-49)) Paddle2 (
		.i_Clk(i_Clk),
		.i_up(i_Switch_3),
		.i_down(i_Switch_4),
		.i_enable(r_en),
		.o1(o_LED_3),
		.o2(o_LED_4),
		.o_left(w_P2_left),
		.o_right(w_P2_right),
		.o_top(w_P2_top),
		.o_bottom(w_P2_bottom)
    );
	
  ball Ball_Unit (
	.i_Clk(i_Clk),
	.i_P1_sw_up(i_Switch_1),
	.i_P1_sw_down(i_Switch_2),
	.i_P2_sw_up(i_Switch_3),
	.i_P2_sw_down(i_Switch_4),
	.i_P1_top(w_P1_top),
	.i_P1_right(w_P1_right),
	.i_P1_bottom(w_P1_bottom),
	.i_P2_top(w_P2_top),
	.i_P2_left(w_P2_left),
	.i_P2_bottom(w_P2_bottom),
	.i_enable(r_en),
	.o_game_result(game_result),
	.o_left(w_B_left),
	.o_right(w_B_right),
	.o_top(w_B_top),
	.o_bottom(w_B_bottom)
  );
	
  sync_pulse_generator SPG1 (
    .i_Clk(i_Clk),
    .o_H_Sync(),
    .o_V_Sync(),
    .o_X_Cursor(w_X_Cursor),
    .o_Y_Cursor(w_Y_Cursor)
  );
  
  vga_sync_porch VSP1 (
    .i_X_Cursor(w_X_Cursor),
    .i_Y_Cursor(w_Y_Cursor),
    .o_H_Sync(o_VGA_HSync),
    .o_V_Sync(o_VGA_VSync)
  );
    
	display_to_screen Display1 (
		.i_Clk(i_Clk),
		.i_device_state(device_state),
		.i_p1_score(r_p1_score),
		.i_p2_score(r_p2_score),
	  .i_P1_left(w_P1_left),
	  .i_P1_right(w_P1_right),
	  .i_P1_top(w_P1_top),
	  .i_P1_bottom(w_P1_bottom),
	  .i_P2_left(w_P2_left),
	  .i_P2_right(w_P2_right),
	  .i_P2_top(w_P2_top),
	  .i_P2_bottom(w_P2_bottom),	  
	  .i_B_left(w_B_left),
	  .i_B_right(w_B_right),
	  .i_B_top(w_B_top),
	  .i_B_bottom(w_B_bottom),
	  .i_X_cursor(w_X_Cursor),
	  .i_Y_cursor(w_Y_Cursor),
	  .o_VGA_Red({o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0}),
	  .o_VGA_Grn({o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0}),
	  .o_VGA_Blu({o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0})
	);

endmodule
