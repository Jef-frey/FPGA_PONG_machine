module display_to_screen (
	input i_Clk,
	input [1:0] i_device_state,
	input [5:0] i_p1_score,
	input [5:0] i_p2_score,
	input [9:0] i_P1_left,
	input [9:0] i_P1_right,
	input [9:0] i_P1_top,
	input [9:0] i_P1_bottom,
	input [9:0] i_P2_left,
	input [9:0] i_P2_right,
	input [9:0] i_P2_top,
	input [9:0] i_P2_bottom,
	input [9:0] i_B_left,
	input [9:0] i_B_right,
	input [9:0] i_B_top,
	input [9:0] i_B_bottom,
	input [9:0] i_X_cursor,
	input [9:0] i_Y_cursor,
	output [2:0] o_VGA_Red,
	output [2:0] o_VGA_Grn,
	output [2:0] o_VGA_Blu
);

	parameter 	w_w = 46, 	// word width
				s_w = 4,	// space width
				u_h = 46,	// unit height
				b_h = 23,	// word lower half height
				ste = 8,	// stroke size
				X_OFFSET = (640-(5*w_w+4*s_w))/2,
				Y_OFFSET = (480-(2*u_h+b_h))/2;
	
	
	wire [8:0] start_output;
	reg start_output_flag = 0;
	assign start_output = (start_output_flag == 1) ? 9'b111111111 : 9'b000000000; // this logic is necessary, otherwise it will form a combinational loop and output will be chaotic

	wire [8:0] game_output;

	wire [8:0] score_output;
	wire [8:0] p1_score;
	wire [8:0] p2_score;

	wire [8:0] finish_output;
	reg finish_output_flag = 0;
	wire [8:0] w_rand_RGB;
	LFSR rand_RGB (.i_Clk(i_Clk), .i_state(i_device_state), .o_reg(w_rand_RGB));
	// assign finish_output = (finish_output_flag == 1) ? 9'b111111111 : 9'b000000000;
	assign finish_output = (finish_output_flag == 1) ? w_rand_RGB : 9'b000000000;

	assign {o_VGA_Red, o_VGA_Grn, o_VGA_Blu} = 	
		(i_device_state == 0) ? start_output :
		(i_device_state == 1) ? game_output :
		(i_device_state == 2) ? score_output :
		(i_device_state == 3) ? finish_output :
		0;
	
	always @(posedge i_Clk) begin // display "ready"
		if (
			(i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+u_h) && (i_X_cursor == X_OFFSET+4*w_w+3*s_w-ste || i_X_cursor == X_OFFSET+4*w_w+3*s_w)			// 'd' top stroke
			||(i_Y_cursor>Y_OFFSET+u_h/2 && i_Y_cursor<=Y_OFFSET+u_h/2+ste) && (i_X_cursor == X_OFFSET+2*w_w+2*s_w+ste || i_X_cursor == X_OFFSET+3*w_w+2*s_w)	// 'a' top strokes
			||(i_Y_cursor>Y_OFFSET+u_h/2+ste && i_Y_cursor<=Y_OFFSET+u_h) && (i_X_cursor == X_OFFSET+3*w_w+2*s_w-ste || i_X_cursor == X_OFFSET+3*w_w+2*s_w)
			||(i_Y_cursor>Y_OFFSET+u_h && i_Y_cursor<=Y_OFFSET+u_h+ste) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+w_w || i_X_cursor == X_OFFSET+w_w+s_w || 			//'ready' middle strokes
				i_X_cursor == X_OFFSET+2*w_w+s_w || i_X_cursor == X_OFFSET+2*w_w+2*s_w || i_X_cursor == X_OFFSET+3*w_w+2*s_w || i_X_cursor == X_OFFSET+3*w_w+3*s_w || 
				i_X_cursor == X_OFFSET+4*w_w+3*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w+ste || i_X_cursor == X_OFFSET+5*w_w+4*s_w-ste ||
				i_X_cursor == X_OFFSET+5*w_w+4*s_w )
			||(i_Y_cursor>Y_OFFSET+u_h+ste && i_Y_cursor<=Y_OFFSET+u_h+b_h-ste/2) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+ste || i_X_cursor == X_OFFSET+w_w+s_w || 
				i_X_cursor == X_OFFSET+w_w+s_w+ste || i_X_cursor == X_OFFSET+2*w_w+s_w-ste || i_X_cursor == X_OFFSET+2*w_w+s_w || i_X_cursor == X_OFFSET+2*w_w+2*s_w || 
				i_X_cursor == X_OFFSET+2*w_w+2*s_w+ste || i_X_cursor == X_OFFSET+3*w_w+2*s_w-ste || i_X_cursor == X_OFFSET+3*w_w+2*s_w || i_X_cursor == X_OFFSET+3*w_w+3*s_w || 
				i_X_cursor == X_OFFSET+3*w_w+3*s_w+ste || i_X_cursor == X_OFFSET+4*w_w+3*s_w-ste || i_X_cursor == X_OFFSET+4*w_w+3*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w || 
				i_X_cursor == X_OFFSET+4*w_w+4*s_w+ste || i_X_cursor == X_OFFSET+5*w_w+4*s_w-ste || i_X_cursor == X_OFFSET+5*w_w+4*s_w )
			||(i_Y_cursor>Y_OFFSET+u_h+b_h-ste/2 && i_Y_cursor<=Y_OFFSET+u_h+b_h+ste/2) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+ste || i_X_cursor == X_OFFSET+w_w+s_w || 
				i_X_cursor == X_OFFSET+2*w_w+s_w || i_X_cursor == X_OFFSET+2*w_w+2*s_w || i_X_cursor == X_OFFSET+2*w_w+2*s_w+ste || i_X_cursor == X_OFFSET+3*w_w+2*s_w-ste || 
				i_X_cursor == X_OFFSET+3*w_w+2*s_w || i_X_cursor == X_OFFSET+3*w_w+3*s_w || i_X_cursor == X_OFFSET+3*w_w+3*s_w+ste || i_X_cursor == X_OFFSET+4*w_w+3*s_w-ste || 
				i_X_cursor == X_OFFSET+4*w_w+3*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w+ste || i_X_cursor == X_OFFSET+5*w_w+4*s_w-ste || 
				i_X_cursor == X_OFFSET+5*w_w+4*s_w )
			||(i_Y_cursor>Y_OFFSET+u_h+b_h+ste/2 && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+ste || i_X_cursor == X_OFFSET+w_w+s_w || 
				i_X_cursor == X_OFFSET+w_w+s_w+ste || i_X_cursor == X_OFFSET+2*w_w+2*s_w || 
				i_X_cursor == X_OFFSET+2*w_w+2*s_w+ste || i_X_cursor == X_OFFSET+3*w_w+2*s_w-ste || i_X_cursor == X_OFFSET+3*w_w+2*s_w || i_X_cursor == X_OFFSET+3*w_w+3*s_w || 
				i_X_cursor == X_OFFSET+3*w_w+3*s_w+ste || i_X_cursor == X_OFFSET+4*w_w+3*s_w-ste || i_X_cursor == X_OFFSET+4*w_w+3*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w || 
				i_X_cursor == X_OFFSET+4*w_w+4*s_w+ste || i_X_cursor == X_OFFSET+5*w_w+4*s_w-ste || i_X_cursor == X_OFFSET+5*w_w+4*s_w )								
			||(i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+ste || i_X_cursor == X_OFFSET+w_w+s_w || 
				i_X_cursor == X_OFFSET+2*w_w+s_w || i_X_cursor == X_OFFSET+2*w_w+2*s_w || i_X_cursor == X_OFFSET+3*w_w+2*s_w || i_X_cursor == X_OFFSET+3*w_w+3*s_w || 
				i_X_cursor == X_OFFSET+4*w_w+3*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w || i_X_cursor == X_OFFSET+5*w_w+4*s_w )
			||(i_Y_cursor>Y_OFFSET+2*u_h && i_Y_cursor<=Y_OFFSET+2*u_h+b_h-ste) && (i_X_cursor == X_OFFSET+5*w_w+4*s_w-ste || i_X_cursor == X_OFFSET+5*w_w+4*s_w)	// 'y' bottom strokes
			||(i_Y_cursor>Y_OFFSET+2*u_h+b_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h+b_h) && (i_X_cursor == X_OFFSET+4*w_w+4*s_w || i_X_cursor == X_OFFSET+5*w_w+4*s_w) 	
		) 
			start_output_flag <= ~start_output_flag;
		else
			start_output_flag <= start_output_flag;
	    end
	
	assign game_output = ((i_X_cursor > i_P1_left && i_X_cursor < i_P1_right && i_Y_cursor > i_P1_top && i_Y_cursor < i_P1_bottom) ||
						  (i_X_cursor > i_P2_left && i_X_cursor < i_P2_right && i_Y_cursor > i_P2_top && i_Y_cursor < i_P2_bottom) ||
						  (i_X_cursor > i_B_left && i_X_cursor < i_B_right && i_Y_cursor > i_B_top && i_Y_cursor < i_B_bottom)
							) ? 9'b111111111 : 9'b000000000;

	assign score_output = game_output | p1_score | p2_score;
	print_score #(.X_OFFSET((640-(3*w_w+2*s_w))/2), .Y_OFFSET((480-(2*u_h))/2)) player_1 
		(.i_Clk(i_Clk), .i_score_val(i_p1_score), .i_X_cursor(i_X_cursor), .i_Y_cursor(i_Y_cursor), .o_score_RGB(p1_score));
	print_score #(.X_OFFSET((640-(3*w_w+2*s_w))/2+2*w_w+2*s_w), .Y_OFFSET((480-(2*u_h))/2)) player_2
		(.i_Clk(i_Clk), .i_score_val(i_p2_score), .i_X_cursor(i_X_cursor), .i_Y_cursor(i_Y_cursor), .o_score_RGB(p2_score));
		
	always @(posedge i_Clk) begin // display "P1 won" or "P2 won"
		if (
			(i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+w_w)			// 'P' top strokes
			||(i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+u_h) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+ste || i_X_cursor == X_OFFSET+w_w-ste || i_X_cursor == X_OFFSET+w_w)
			||(i_Y_cursor>Y_OFFSET+u_h && i_Y_cursor<=Y_OFFSET+u_h+ste) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+w_w || 
				i_X_cursor == X_OFFSET+3*w_w+3*s_w || i_X_cursor == X_OFFSET+3*w_w+3*s_w+ste || i_X_cursor == X_OFFSET+3*w_w+3*s_w+w_w/2-ste/2 || i_X_cursor == X_OFFSET+3*w_w+3*s_w+w_w/2+ste/2 ||
				i_X_cursor == X_OFFSET+4*w_w+3*s_w-ste || i_X_cursor == X_OFFSET+4*w_w+3*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w || i_X_cursor == X_OFFSET+5*w_w+4*s_w ||
				i_X_cursor == X_OFFSET+5*w_w+5*s_w || i_X_cursor == X_OFFSET+6*w_w+5*s_w)
			||(i_Y_cursor>Y_OFFSET+u_h+ste && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+ste || 
				i_X_cursor == X_OFFSET+3*w_w+3*s_w || i_X_cursor == X_OFFSET+3*w_w+3*s_w+ste || i_X_cursor == X_OFFSET+3*w_w+3*s_w+w_w/2-ste/2 || i_X_cursor == X_OFFSET+3*w_w+3*s_w+w_w/2+ste/2 ||
				i_X_cursor == X_OFFSET+4*w_w+3*s_w-ste || i_X_cursor == X_OFFSET+4*w_w+3*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w+ste ||
				i_X_cursor == X_OFFSET+5*w_w+4*s_w-ste ||i_X_cursor == X_OFFSET+5*w_w+4*s_w || i_X_cursor == X_OFFSET+5*w_w+5*s_w || i_X_cursor == X_OFFSET+5*w_w+5*s_w+ste || 
				i_X_cursor == X_OFFSET+6*w_w+5*s_w-ste || i_X_cursor == X_OFFSET+6*w_w+5*s_w)
			||(i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor == X_OFFSET+0 || i_X_cursor == X_OFFSET+ste || 
				i_X_cursor == X_OFFSET+3*w_w+3*s_w || i_X_cursor == X_OFFSET+4*w_w+3*s_w || i_X_cursor == X_OFFSET+4*w_w+4*s_w || i_X_cursor == X_OFFSET+5*w_w+4*s_w || 
				i_X_cursor == X_OFFSET+5*w_w+5*s_w || i_X_cursor == X_OFFSET+5*w_w+5*s_w+ste || i_X_cursor == X_OFFSET+6*w_w+5*s_w-ste || i_X_cursor == X_OFFSET+6*w_w+5*s_w)

			|| ((i_p1_score > i_p2_score) && ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+2*w_w+s_w-ste || i_X_cursor==X_OFFSET+2*w_w+s_w)))	// if player1 won, print 1
			|| ((i_p1_score < i_p2_score) && ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor==X_OFFSET+w_w+s_w+0 || i_X_cursor==X_OFFSET+w_w+s_w+w_w)		// if player2 won, print 2
				|| (i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+u_h-ste/2) && (i_X_cursor==X_OFFSET+w_w+s_w+w_w-ste || i_X_cursor==X_OFFSET+w_w+s_w+w_w)
				|| (i_Y_cursor>Y_OFFSET+u_h-ste/2 && i_Y_cursor<=Y_OFFSET+u_h+ste/2) && (i_X_cursor==X_OFFSET+w_w+s_w+0 || i_X_cursor==X_OFFSET+w_w+s_w+w_w)
				|| (i_Y_cursor>Y_OFFSET+u_h+ste/2 && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor==X_OFFSET+w_w+s_w+0 || i_X_cursor==X_OFFSET+w_w+s_w+ste)
				|| (i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+w_w+s_w+0 || i_X_cursor==X_OFFSET+w_w+s_w+w_w)))
		) 
		finish_output_flag <= ~finish_output_flag;
	else
		finish_output_flag <= finish_output_flag;
	end
		
endmodule

module print_score #(
	parameter	X_OFFSET = 0,
				Y_OFFSET = 0,
				w_w = 46, 	// word width
				s_w = 4,	// space width
				u_h = 46,	// unit height
				b_h = 23,	// word lower half height
				ste = 8	// stroke size
	)
	(
	input i_Clk,
	input [5:0] i_score_val,
	input [9:0] i_X_cursor,
	input [9:0] i_Y_cursor,
	output [8:0] o_score_RGB
	);

	reg score_flag = 0;
	assign o_score_RGB = (score_flag == 1) ? 9'b111111111 : 9'b000000000;

	always @(posedge i_Clk) begin
		case(i_score_val)
			0: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+ste || i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag;
			1: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag;
			2: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+u_h-ste/2) && (i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h-ste/2 && i_Y_cursor<=Y_OFFSET+u_h+ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h+ste/2 && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+ste)
	|| (i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag;
			3: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+u_h-ste/2) && (i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h-ste/2 && i_Y_cursor<=Y_OFFSET+u_h+ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h+ste/2 && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag; 
			4: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+u_h-ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+ste || i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h-ste/2 && i_Y_cursor<=Y_OFFSET+u_h+ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h+ste/2 && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag;
			5: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+u_h-ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+ste)
	|| (i_Y_cursor>Y_OFFSET+u_h-ste/2 && i_Y_cursor<=Y_OFFSET+u_h+ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h+ste/2 && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag;
			6: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+u_h-ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+ste)
	|| (i_Y_cursor>Y_OFFSET+u_h-ste/2 && i_Y_cursor<=Y_OFFSET+u_h+ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h+ste/2 && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+ste || i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag;
			7: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag;
			8: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+u_h-ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+ste || i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h-ste/2 && i_Y_cursor<=Y_OFFSET+u_h+ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h+ste/2 && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+ste || i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag;
			9: score_flag <= ((i_Y_cursor>Y_OFFSET+0 && i_Y_cursor<=Y_OFFSET+ste) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+ste && i_Y_cursor<=Y_OFFSET+u_h-ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+ste || i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h-ste/2 && i_Y_cursor<=Y_OFFSET+u_h+ste/2) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+u_h+ste/2 && i_Y_cursor<=Y_OFFSET+2*u_h-ste) && (i_X_cursor==X_OFFSET+w_w-ste || i_X_cursor==X_OFFSET+w_w)
	|| (i_Y_cursor>Y_OFFSET+2*u_h-ste && i_Y_cursor<=Y_OFFSET+2*u_h) && (i_X_cursor==X_OFFSET+0 || i_X_cursor==X_OFFSET+w_w)) ? ~score_flag : score_flag;
			default: score_flag <= score_flag;
		endcase
	end

endmodule
	