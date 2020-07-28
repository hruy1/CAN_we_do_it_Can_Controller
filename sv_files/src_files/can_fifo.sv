/*-------------------------------------------
  Project: CAN Controller
  Module: can_fifo
  Author: Antonio Jimenez
  Date: 7/27/2020
  Module Description: A synchronous fifo that has width of 128 bits and
                      a parameterized memory depth.
-------------------------------------------*/

module can_fifo #(
  parameter MEM_DEPTH = 2
)
(
  input  logic i_sys_clk,
  input  logic i_reset,
  input  logic i_w_en,
  input  logic i_r_en,
  input  logic [127:0] i_fifo_w_data,
  output logic o_full,
  output logic o_empty,
  output logic o_underflow,
  output logic o_overflow,
  output logic [127:0] o_fifo_r_data
);

  localparam PTR_WIDTH = $clog2(MEM_DEPTH) + 1;

  logic [127:0] memory [0:MEM_DEPTH-1];
  logic [PTR_WIDTH-1:0] r_ptr;
  logic [PTR_WIDTH-1:0] w_ptr;

  // This always block deals with the write pointer and overflow logic
  // Also deals with the clearing of memory on reset
  always_ff @(posedge i_sys_clk, posedge i_reset)
  begin : w_ptr_and_overflow_logic
  
    if (i_reset) begin
      memory <= '{default:128'b0};
      w_ptr <= 'b0;
      o_overflow <= 1'b0;
      
    end
    else if (!o_full) begin
      if (i_w_en) begin
        memory[w_ptr[PTR_WIDTH-2:0]] <= i_fifo_w_data;
        w_ptr <= w_ptr + 1'b1;
        o_overflow <= 1'b0;
        
      end
    end
    else begin
      if (i_w_en) begin
        o_overflow <= 1'b1;
        
      end
      else begin
        o_overflow <= 1'b0;
      end
    end
  end
  
  // This always block deals with the read pointer and underflow logic
  always_ff @(posedge i_sys_clk, posedge i_reset)
  begin : r_ptr_and_underflow_logic
  
    if (i_reset) begin
      r_ptr <= 'b0;
      o_underflow <= 1'b0;
      
    end
    else if (!o_empty) begin
      if (i_r_en) begin
        r_ptr <= r_ptr + 1'b1;
        o_underflow <= 1'b0;
        
      end
    end
    else begin
      if (i_r_en) begin
        o_underflow <= 1'b1;
        
      end  
      else begin
        o_underflow <= 1'b0;
        
      end
    end
  end
  
  // Assigns o_fifo_r_data to the memory location value r_ptr is currently pointing to
  assign o_fifo_r_data = memory[r_ptr[PTR_WIDTH-2:0]];
  
  // These assign statments deal with the full and empty flag logic
  assign o_empty = (w_ptr == r_ptr);
  assign o_full  = ((w_ptr[PTR_WIDTH-1] != r_ptr[PTR_WIDTH-1]) &&
                   (w_ptr[PTR_WIDTH-2:0] == r_ptr[PTR_WIDTH-2:0]));

endmodule
