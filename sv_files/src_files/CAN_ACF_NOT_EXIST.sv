//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: CAN_ACF_NOT_EXIST ----- Submodule of Acceptance_Filter
  Author:Pengfei He
  Date:July/24/2020
  Module Description: This module is used when NUMBER_OF_ACCEPTANCE_FILTRES == 0
  ---------------------------------------------------------------------------------*/


module CAN_ACF_NOT_EXIST(
     input logic i_syn_can_ready,
     input logic [127:0] i_rx_message,
     input logic i_rx_full,
     output logic o_rx_w_en,
     output logic [127:0] o_rx_fifo_w_data
    );

logic [127:0] temp_reg = 128'h0;
    
always_comb begin
 if(!i_rx_full) begin
  if(i_syn_can_ready) begin
    o_rx_w_en = 1'b1;
    temp_reg = i_rx_message;
  end else begin
    o_rx_w_en = 1'b0;
  end
 end else begin
   o_rx_w_en = 1'b0;
 end 
end

assign o_rx_fifo_w_data = temp_reg;
endmodule
