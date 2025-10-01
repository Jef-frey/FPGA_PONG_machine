module vga_sync_porch
 #(parameter total_col = 800,
             total_row = 525,
             active_col = 640,
             active_row = 480,
             H_F_Porch = 18,
             H_B_Porch = 50,
             V_F_Porch = 10,
             V_B_Porch = 33
  )
  (
   input [9:0] i_X_Cursor,
   input [9:0] i_Y_Cursor,
   output o_H_Sync,
   output o_V_Sync
  );

  assign o_H_Sync = (i_X_Cursor < active_col + H_F_Porch || i_X_Cursor > total_col - H_B_Porch) ? 1 : 0;
  assign o_V_Sync = (i_Y_Cursor < active_row + V_F_Porch || i_Y_Cursor > total_row - V_B_Porch) ? 1 : 0;

endmodule
