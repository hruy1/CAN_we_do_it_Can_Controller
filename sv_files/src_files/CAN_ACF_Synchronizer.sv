//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: CAN_ACF_Synchronizer ---- Submodule of Acceptance_Filter
  Author:Pengfei He
  Date:July/23/2020
  Module Description: Synchronize input signals from CAN_CLK domain to SYS_CLK domain
  ---------------------------------------------------------------------------------*/


module CAN_ACF_Synchronizer(
    input i_sys_clk,
    input i_can_clk,
    input i_reset,
    input i_can_ready,
    output o_can_ready
    );
  
  logic dff1 = 1'b0;
  logic dff2 = 1'b0;
  
  always_ff@(posedge i_sys_clk or posedge i_reset) begin
   if(i_reset)begin
    dff1 <=1'b0;
    dff2 <=1'b0;
   end else begin
    dff1 <=i_can_ready;
    dff2 <=dff1;
   end
  end

 assign o_can_ready = dff1 && (!dff2);

endmodule
