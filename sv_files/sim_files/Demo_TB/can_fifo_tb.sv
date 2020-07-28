/*-------------------------------------------
  Project: CAN Controller
  Module: can_fifo_tb
  Author: Antonio Jimenez
  Date: 7/27/2020
  Module Description: A testbench to test the synchronous fifo module
-------------------------------------------*/

module can_fifo_tb;

  logic i_sys_clk = 1'b0;           
  logic i_reset = 1'b0;
  logic i_w_en = 1'b0;              
  logic i_r_en = 1'b0;              
  logic [127:0] i_fifo_w_data = 128'b1;
  logic o_full;
  logic o_empty;             
  logic o_underflow;         
  logic o_overflow;          
  logic [127:0] o_fifo_r_data;

  can_fifo #(
    .MEM_DEPTH(8)
  )
  DUT (
    .i_sys_clk(i_sys_clk),
    .i_reset(i_reset),
    .i_w_en(i_w_en),
    .i_r_en(i_r_en),
    .i_fifo_w_data(i_fifo_w_data),
    .o_full(o_full),
    .o_empty(o_empty),
    .o_underflow(o_underflow),
    .o_overflow(o_overflow),
    .o_fifo_r_data(o_fifo_r_data)
  );
  
  initial
  begin
  
    // FIFO_00 Observe that the depth is 8
    
    // FIFO_01 Observe that o_full, o_overflow, and o_underflow are 0 when i_reset is 1
    // FIFO_02 Observe o_empty is 1 when i_reset is 1
    // FIFO_10 Observe memory locations are set to 0 when i_reset is 1
    i_reset = 1'b1; #5;
    i_reset = 1'b0; #5;
    
    // FIFO_03 Observe o_undeflow is 1 for one clock cycle when read occurs when empty
    // FIFO_04 Observe o_empty being equal to 1 when read and write pointers equal eachother
    i_r_en = 1'b1; #5;
    tick;
    i_r_en = 1'b0; #5;
    tick;
    
    // FIFO_04 Observe o_overflow is 1 when write occurs when fifo full
    // FIFO_06 Observe o_full being 1 when the write pointers msb is not the same but hte lsbs are
    // FIFO_07 Observe internal write pointer incrementing every tick when i_w_en is 1
    // FIFO_08 Observe that register is being written to where w_ptr is pointing
    i_w_en = 1'b1; #5;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    i_w_en = 1'b0; #5;
    tick;
    
    // FIFO_09 Observe read pointer being incremented when i_r_en is 1 and rising edge of i_sys_clk, except when o_empty=1
    // FIFO_10 Observe o_fifo_r_data outputting value at memory read pointer is pointing to
    i_r_en = 1'b1; #5;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    i_r_en = 1'b0; #5;
    
    i_w_en = 1'b1; #5;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    tick;
    i_w_en = 1'b0;
    i_r_en = 1'b1;
    #5;
    
    tick;
    tick;
    tick;
    i_w_en = 1'b1;
    i_r_en = 1'b0;
    #5;
    
    tick;
    tick;
    tick;
    
    
  
    $display("FINISHED");
    $finish;
  end
  
  task tick;
  begin
    i_sys_clk = 1'b1; #5;
    i_sys_clk = 1'b0; #5;
  end
  endtask
  
endmodule
