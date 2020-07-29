//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: AFR ------ Submodule of Acceptance_Filter
  Author:Pengfei He
  Date:July/24/2020
  Module Description: Acceptance Filter regsiter includes ID regsiter and mask regsiter
  ---------------------------------------------------------------------------------*/

module CAN_AFR(
      input logic  i_afr_uaf,
      input logic [31:0] i_afr_afmr,
      input logic [31:0] i_afr_afir,
      input logic [31:0] in_rx_message,
      output logic o_afr_acfbsy,
      output logic o_afr_pass
    );

// ----- internal signals bgein -------//

  localparam [31:0] COMPARE=32'h0000_0000;// 'o_afr_pass' is set to 1 if and only if result == COMPARE
  logic [31:0] result;                    // 'in_rx_message' is compared by'acir' and 'acmr'
  logic [31:0] acir =32'h0000_0000;       // ID regsiter
  logic [31:0] acmr =32'h0000_0000;       // Mask regsiter


// compare logic 
  always_comb begin
   if (!i_afr_uaf) begin
     acir = i_afr_afir;
     acmr = i_afr_afmr;
     o_afr_acfbsy = 1'b1;
   end else begin
     result = (in_rx_message ^ acir) & acmr;
     o_afr_acfbsy = 1'b0;
  end
end

// ID filed of input data is passed or not
  always_comb begin
    if((i_afr_uaf == 1) && ( result == COMPARE)) begin
      o_afr_pass = 1'b1;
    end else begin
      o_afr_pass = 1'b0;
    end
   end

endmodule
