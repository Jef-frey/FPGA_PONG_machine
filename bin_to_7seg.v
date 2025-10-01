module bin_to_7seg
  (
    input  [7:0] i_bin,
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
    output o_Segment2_G
  );

  wire [6:0] w_Segment1;
  wire [6:0] w_Segment2;

  assign o_Segment1_A = w_Segment1[6];
  assign o_Segment1_B = w_Segment1[5];
  assign o_Segment1_C = w_Segment1[4];
  assign o_Segment1_D = w_Segment1[3];
  assign o_Segment1_E = w_Segment1[2];
  assign o_Segment1_F = w_Segment1[1];
  assign o_Segment1_G = w_Segment1[0];

  assign o_Segment2_A = w_Segment2[6];
  assign o_Segment2_B = w_Segment2[5];
  assign o_Segment2_C = w_Segment2[4];
  assign o_Segment2_D = w_Segment2[3];
  assign o_Segment2_E = w_Segment2[2];
  assign o_Segment2_F = w_Segment2[1];
  assign o_Segment2_G = w_Segment2[0];

  assign w_Segment1 = encode(i_bin[7:4]);
  assign w_Segment2 = encode(i_bin[3:0]);
	
	function [6:0] encode;
		input [3:0] i_bin_val;
		encode =	(i_bin_val[3:0] == 4'b0000) ? ~7'b1111110 :
					(i_bin_val[3:0] == 4'b0001) ? ~7'b0110000 :
					(i_bin_val[3:0] == 4'b0010) ? ~7'b1101101 :
					(i_bin_val[3:0] == 4'b0011) ? ~7'b1111001 :
					(i_bin_val[3:0] == 4'b0100) ? ~7'b0110011 :
					(i_bin_val[3:0] == 4'b0101) ? ~7'b1011011 :
					(i_bin_val[3:0] == 4'b0110) ? ~7'b1011111 :
					(i_bin_val[3:0] == 4'b0111) ? ~7'b1110000 :
					(i_bin_val[3:0] == 4'b1000) ? ~7'b1111111 :
					(i_bin_val[3:0] == 4'b1001) ? ~7'b1111011 :
					(i_bin_val[3:0] == 4'b1010) ? ~7'b1110111 :
					(i_bin_val[3:0] == 4'b1011) ? ~7'b0011111 :
					(i_bin_val[3:0] == 4'b1100) ? ~7'b1001110 :
					(i_bin_val[3:0] == 4'b1101) ? ~7'b0111101 :
					(i_bin_val[3:0] == 4'b1110) ? ~7'b1001111 :
					(i_bin_val[3:0] == 4'b1111) ? ~7'b1000111 :
											      ~7'b0000000;
	
	endfunction

endmodule
