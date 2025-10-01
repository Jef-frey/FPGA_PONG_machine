module paddle 
	#( parameter
	SCREEN_HEIGHT = 480,
	SCREEN_WIDTH = 640,
	PADDLE_HEIGHT = 80,
	PADDLE_WIDTH = 10,
	SW_STEP_COUNT = 52000,	//determines the speed of paddle, lower value == faster
	X_center = SCREEN_HEIGHT/2
	)
	(
	input i_Clk,
	input i_up,
	input i_down,
	input i_enable,
	output reg o1,
	output reg o2,
	output [9:0] o_left,
	output [9:0] o_right,
	output [9:0] o_top,
	output [9:0] o_bottom
	);
	
	reg [31:0] r_up_sw_counter = 32'h0000;	//counter cycles at 52000
	reg [31:0] r_down_sw_counter = 32'h0000;

	reg [9:0] X_START = X_center - PADDLE_WIDTH/2;
	reg [9:0] X_END   = X_center + PADDLE_WIDTH/2;
	
	reg [9:0] Y_start = (SCREEN_HEIGHT - PADDLE_HEIGHT)/2;
	reg [9:0] Y_end   = (SCREEN_HEIGHT + PADDLE_HEIGHT)/2;
	
	assign o_left	= X_START;
	assign o_right	= X_END;
	assign o_top	= Y_start;
	assign o_bottom	= Y_end;

	always @(posedge i_Clk) begin
		if (i_enable == 1) begin
			if (i_up == 1'b1 && i_down == 1'b0) begin
				r_up_sw_counter <= r_up_sw_counter + 1;
				if (r_up_sw_counter == SW_STEP_COUNT) begin
					r_up_sw_counter <= 0;
					if (Y_start != 0) begin
						Y_start <= Y_start - 1;
						Y_end	<= Y_end - 1;
					end
				end else begin
					o1 <= 1'b1;
				end
			end else if (i_up == 1'b0 && i_down == 1'b1) begin
				r_down_sw_counter <= r_down_sw_counter + 1;
				if (r_down_sw_counter == SW_STEP_COUNT) begin
					r_down_sw_counter <= 0;
					if (Y_end != SCREEN_HEIGHT - 1) begin
						Y_start <= Y_start + 1;
						Y_end	<= Y_end + 1;
					end
				end else begin
					o2 <= 1'b1;
				end
			end else begin
				r_up_sw_counter <= 0;
				r_down_sw_counter <= 0;
				o1 <= 1'b0;
				o2 <= 1'b0;
				Y_start <= Y_start;
				Y_end	<= Y_end;
			end	
		end else begin
			Y_start <= (SCREEN_HEIGHT - PADDLE_HEIGHT)/2;
			Y_end	<= (SCREEN_HEIGHT + PADDLE_HEIGHT)/2;
		end
	end


endmodule
