//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: CAN_AFR_CU ------- Submodule of Acceptance_Filter
  Author:Pengfei He
  Date:July/24/2020
  Module Description: Acceptance Filter control unit includes four states:
                     idle,compare,pass and acf_not_ex
  ---------------------------------------------------------------------------------*/


module CAN_AFR_CU(
      input logic i_cu_sys_clk,
      input logic i_cu_reset,
      input logic i_cu_rx_full,
      input logic i_cu_uaf_bus,
      input logic i_cu_syn_can_ready,
      input logic i_cu_pass_bus,
      input logic i_cu_acfbsy_bus,
      input logic [127:0] i_cu_rx_message,
      output logic o_cu_rx_w_en,
      output logic [127:0] o_cu_rx_fifo_w_data,
      output logic o_cu_acfbsy
    );

typedef enum logic [2:0] {idle,compare,pass,acf_not_ex} State;
State current_state, next_state = idle;     

logic [127:0] rx_message_temp = 128'h0;


      
  always_ff@(posedge(i_cu_sys_clk) or posedge(i_cu_reset)) begin
    if (i_cu_reset) begin
      current_state <= idle;
    end else begin
      current_state <= next_state;
    end
  end

  always_comb begin
    case (current_state)
    idle : begin
           if (!i_cu_uaf_bus) begin
             next_state <= acf_not_ex;
           end else begin 
              if (i_cu_syn_can_ready && (!i_cu_rx_full) ) begin
                next_state = compare;
              end else begin
                next_state = idle; 
              end   
            end
          end
     compare : begin
               if (i_cu_pass_bus) begin
                 next_state <= pass;
               end else begin
                 next_state <= idle;
               end
             end
      //  State machine enters 'pass' state when ID field of input data is passed checking by ID and mask register
     pass : begin
             next_state <= idle;
            end
     // State machine enters 'acf_nox_ex' state when all uaf bits are set to 0
     acf_not_ex: begin
                  if (i_cu_uaf_bus) begin
                    next_state <= idle;
                  end else begin
                    next_state <= acf_not_ex;
                  end
                end
      
      default : begin
                next_state = idle;
                end   
           endcase;
         end

 
 always_comb begin
    case (current_state)
    idle : begin
            if (i_cu_reset) begin
              o_cu_acfbsy = 0;
              o_cu_rx_w_en = 0;
              rx_message_temp = 128'h0; 
            end else begin
               o_cu_acfbsy = i_cu_acfbsy_bus;
               o_cu_rx_w_en = 0;
            end
          end
     compare : begin
                o_cu_acfbsy = 1'b1;
                o_cu_rx_w_en = 0; 
               end
              
     pass : begin
             o_cu_acfbsy  = 1'b1;
             o_cu_rx_w_en = 1'b1; 
             rx_message_temp = i_cu_rx_message;
            end
     
     acf_not_ex: begin
                 o_cu_acfbsy  = 1'b0;
                 if (!i_cu_rx_full) begin
                   if (i_cu_syn_can_ready) begin
                     o_cu_rx_w_en = 1'b1;
                     rx_message_temp = i_cu_rx_message;
                   end else begin
                     o_cu_rx_w_en = 1'b0;
                   end
                 end else begin
                    o_cu_rx_w_en = 1'b0;
                 end    
                end
      
      default : begin
                 o_cu_acfbsy  = 1'b0;
                 o_cu_rx_w_en = 1'b0;
                end   
           endcase;
         end
 

 assign  o_cu_rx_fifo_w_data = rx_message_temp;

endmodule
