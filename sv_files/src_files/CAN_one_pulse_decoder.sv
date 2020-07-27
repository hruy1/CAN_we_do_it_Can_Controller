//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: can_one_pulse_decoder --- submodule of Microcontroller Interface
  Author:Pengfei He
  Date:July/22/2020
  Module Description: read or write address one pulse decoder. Submodule of Microcontroller Interface.
  Internal state mashine has five states: idle, rd(read operation state), wr(write operation state), 
  rd_done(read operation is finished), wr(write operation is finished))
  ---------------------------------------------------------------------------------*/

module can_one_pulse_decoder(
     input  logic i_sys_clk,
     input  logic i_reset,
     input  logic i_r_neg_w,
     input  logic i_cs,
     input  logic [30:0] rd_dec_addr,
     input  logic [30:0] wr_dec_addr,
     output logic [30:0] o_rs_vector
    );
  
typedef enum logic [2:0] {idle,rd,wr,rd_done,wr_done} State;
State currentState, nextState = idle;  
    
always_ff@(posedge i_sys_clk, posedge i_reset) 
 begin
  if(i_reset) begin
   currentState <= idle;
  end else begin
   currentState <= nextState;
  end
 end
 
 always_comb
  case(currentState)
  
  idle:begin
    if(i_cs == 1'b1 && i_r_neg_w == 1'b1) begin
     nextState = rd;
    end else if(i_cs == 1'b1 && i_r_neg_w == 1'b0) begin
     nextState = wr;
    end else begin
     nextState = idle;
    end
   end
   
   rd:begin
      nextState  = rd_done;
    end
   
   wr:begin
      nextState  = wr_done;
     end
 
   rd_done:begin
      if(i_cs == 1'b0 && i_r_neg_w == 1'b0) begin
      nextState =idle;
      end else if(i_cs == 1'b1 && i_r_neg_w == 1'b0) begin
      nextState = wr;
      end else begin
      nextState  = rd_done;
      end
     end
     
   wr_done:begin
      if(i_cs == 1'b0 && i_r_neg_w == 1'b0) begin
      nextState =idle;
      end else if(i_cs == 1'b1 && i_r_neg_w == 1'b1) begin
      nextState = rd;
      end else begin
      nextState  = wr_done;
      end
     end
        
   default:begin
         nextState = idle;
          end
 endcase;

 always_comb
  case(currentState)
  
  idle:begin
    o_rs_vector = 31'b0;
   end
   
   rd:begin
     o_rs_vector = rd_dec_addr;
    end
    
   wr:begin
     o_rs_vector = wr_dec_addr;
    end
 
   rd_done:begin
     o_rs_vector = 31'b0;
   end
   
   wr_done:begin
     o_rs_vector = 31'b0;
   end
   
   default:begin
     o_rs_vector = 31'b0;
   end
 endcase;
 
    
endmodule
