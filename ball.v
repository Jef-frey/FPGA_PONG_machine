module ball 
	#( parameter
		SIZE = 10,
		DEFAULT_SPEED = 100000,
		SCREEN_HEIGHT = 480,
		SCREEN_WIDTH = 640
	)
	(
	input i_Clk,
	input i_enable,
	
	input i_P1_sw_up,
	input i_P1_sw_down,
	input i_P2_sw_up,
	input i_P2_sw_down,
	
	input [9:0] i_P1_top,
	input [9:0] i_P1_right,
	input [9:0] i_P1_bottom,
	input [9:0] i_P2_top,
	input [9:0] i_P2_left,
	input [9:0] i_P2_bottom,
	
	output [9:0] o_left,
	output [9:0] o_right,
	output [9:0] o_top,
	output [9:0] o_bottom,
	output reg [1:0] o_game_result // 0 is undecided, 1 is P1 won, 2 is P2 won
    );
		
	parameter 	DEFAULT_TOP		= (SCREEN_HEIGHT - SIZE)/2,
				DEFAULT_BOTTOM	= (SCREEN_HEIGHT + SIZE)/2,
				DEFAULT_LEFT	= (SCREEN_WIDTH - SIZE)/2,
				DEFAULT_RIGHT	= (SCREEN_WIDTH + SIZE)/2,
				BALL_SPEED_UP	= 2000;
		
	reg [31:0] ball_X_speed_count = DEFAULT_SPEED;
	reg [31:0] ball_X_speed = DEFAULT_SPEED;
	reg ball_X_direction = 0; //0 is left, 1 is right

	reg [1:0]  ball_Y_direction = 0; //0 is straight, 1 is up, 2 is down

	reg last_win		 = 0; //0 is p1, 1 is p2

	reg [9:0] ball_top		= DEFAULT_TOP;
	reg [9:0] ball_bottom	= DEFAULT_BOTTOM;
	reg [9:0] ball_left		= DEFAULT_LEFT;
	reg [9:0] ball_right	= DEFAULT_RIGHT;
	
	assign o_left	= ball_left;
	assign o_right	= ball_right;
	assign o_top	= ball_top;
	assign o_bottom	= ball_bottom;

	always @(posedge i_Clk) begin
		if (i_enable == 1) begin
			ball_X_speed_count <= ball_X_speed_count - 1;
			
			if (ball_X_speed_count == 0) begin
				ball_X_speed_count <= ball_X_speed;
				if (ball_X_direction == 0) begin
					ball_left <= ball_left - 1;
					ball_right <= ball_right - 1;
					if (ball_left == i_P1_right && (ball_top < i_P1_bottom) && (ball_bottom > i_P1_top)) begin	// hit left paddle
						if (i_P1_sw_up ^ i_P1_sw_down) begin
							if (i_P1_sw_up) begin
								if (ball_Y_direction == 0) begin
									ball_Y_direction <= 1;
								end else if (ball_Y_direction == 2) begin
									ball_Y_direction <= 0;
								end
							end else begin
								if (ball_Y_direction == 0) begin
									ball_Y_direction <= 2;
								end else if (ball_Y_direction == 1) begin
									ball_Y_direction <= 0;
								end					
							end
						end
						ball_X_direction <= 1;
						ball_X_speed <= ball_X_speed - BALL_SPEED_UP;
					end
					if (ball_left == 0) begin
						last_win <= 1;
						o_game_result <= 2;
					end
				end else begin
					ball_left <= ball_left + 1;
					ball_right <= ball_right + 1;
					if (ball_right == i_P2_left && (ball_top < i_P2_bottom) && (ball_bottom > i_P2_top)) begin	// hit right paddle
						if (i_P2_sw_up ^ i_P2_sw_down) begin
							if (i_P2_sw_up) begin
								if (ball_Y_direction == 0) begin
									ball_Y_direction <= 1;
								end else if (ball_Y_direction == 2) begin
									ball_Y_direction <= 0;
								end
							end else begin
								if (ball_Y_direction == 0) begin
									ball_Y_direction <= 2;
								end else if (ball_Y_direction == 1) begin
									ball_Y_direction <= 0;
								end					
							end
						end
						ball_X_direction <= 0;
						ball_X_speed <= ball_X_speed - BALL_SPEED_UP;
					end
					if (ball_right == SCREEN_WIDTH - 1) begin
						last_win <= 0;
						o_game_result <= 1;
					end
				end
				
				if (ball_Y_direction == 1) begin
					ball_top <= ball_top - 1;
					ball_bottom <= ball_bottom- 1;
					if (ball_top == 0) begin	// hit top
						ball_Y_direction <= 2; //0 is straight, 1 is up, 2 is down
					end
				end else if (ball_Y_direction == 2) begin
					ball_top <= ball_top + 1;
					ball_bottom <= ball_bottom + 1;
					if (ball_bottom == SCREEN_HEIGHT - 1) begin	// hit bottom
						ball_Y_direction <= 1;
					end
				end else begin
					ball_top <= ball_top;
					ball_bottom <= ball_bottom;
				end
			end
			
		end else begin
			ball_top	<= DEFAULT_TOP;
			ball_bottom	<= DEFAULT_BOTTOM;
			ball_left	<= DEFAULT_LEFT;
			ball_right	<= DEFAULT_RIGHT;
			ball_X_speed_count 	<= DEFAULT_SPEED;
			ball_X_speed		<= DEFAULT_SPEED;
			ball_Y_direction	<= 0;
			if (last_win == 1)
				ball_X_direction <= 0;
			else
				ball_X_direction <= 1;
			o_game_result <= 0;
		end
	end


endmodule
