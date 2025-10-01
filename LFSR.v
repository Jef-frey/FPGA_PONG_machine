module LFSR (
	input i_Clk,
	input [1:0] i_state,
	output [8:0] o_reg
);
	parameter seed =	9'b1_0110_1001;
	parameter DELAY_COUNT = 10000000;
	parameter INITIAL_VAL = 9'b1_1010_1110;
	
	reg	[8:0] r_reg = INITIAL_VAL;

	reg [31:0] delay_counter = DELAY_COUNT;

	assign o_reg = r_reg;
	
	always @(posedge i_Clk) begin
		if (i_state == 0) begin
			r_reg <= INITIAL_VAL;
		end else begin
			if (delay_counter == 0) begin
				delay_counter <= DELAY_COUNT;

				r_reg[0] <= r_reg[8];
				r_reg[1] <= seed[7] ? r_reg[0] ^ r_reg[8] : r_reg[0];
				r_reg[2] <= seed[6] ? r_reg[1] ^ r_reg[8] : r_reg[1];
				r_reg[3] <= seed[5] ? r_reg[2] ^ r_reg[8] : r_reg[2];
				r_reg[4] <= seed[4] ? r_reg[3] ^ r_reg[8] : r_reg[3];
				r_reg[5] <= seed[3] ? r_reg[4] ^ r_reg[8] : r_reg[4];
				r_reg[6] <= seed[2] ? r_reg[5] ^ r_reg[8] : r_reg[5];
				r_reg[7] <= seed[1] ? r_reg[6] ^ r_reg[8] : r_reg[6];
				r_reg[8] <= seed[0] ? r_reg[7] ^ r_reg[8] : r_reg[7];
			end else begin
				delay_counter <= delay_counter - 1;
			end
		end
	end


endmodule