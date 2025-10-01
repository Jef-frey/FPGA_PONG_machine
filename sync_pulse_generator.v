module sync_pulse_generator
 #(parameter total_col = 800,
             total_row = 525,
             active_col = 640,
             active_row = 480)
  (input i_Clk,
   output o_H_Sync,
   output o_V_Sync,
   output [9:0] o_X_Cursor,
   output [9:0] o_Y_Cursor
  );

  reg [9:0] r_X_Cursor = 0;
  reg [9:0] r_Y_Cursor = 0;

  reg r_H_Sync = 1;
  reg r_V_Sync = 1;

  always @ (posedge i_Clk) begin
    r_X_Cursor <= r_X_Cursor + 1;

    if (r_X_Cursor == total_col - 1) begin
      r_X_Cursor <= 0;
      r_Y_Cursor <= r_Y_Cursor + 1;
    end

    if (r_Y_Cursor == total_row - 1 && r_X_Cursor == total_col - 1) begin
      r_Y_Cursor <= 0;
    end
  end

  assign o_H_Sync = (r_X_Cursor < active_col) ? 1 : 0;
  assign o_V_Sync = (r_Y_Cursor < active_row) ? 1 : 0;
  assign o_X_Cursor = r_X_Cursor;
  assign o_Y_Cursor = r_Y_Cursor;

endmodule
