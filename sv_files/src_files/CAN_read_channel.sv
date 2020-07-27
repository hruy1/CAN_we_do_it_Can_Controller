//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: rtc_read_channel --- submodule of Microcontroller Interface
  Author:Pengfei He
  Date:July/22/2020
  Module Description: Read channel of Microcontroller Interface. 
  ---------------------------------------------------------------------------------*/


module rtc_read_channel(
    input  logic i_rd_en, // read channel enable signal from rtc_mc_if
    input  logic i_reset,//  active high asynchronous reset from rtc_mc_if
    input  logic [5:0] i_addr, //6 bits address input from rtc_mc_if
    input  logic [31:0] i_reg_r_data, //32 bit data input from rtc_mc_if
    output logic [31:0] o_reg_data, //32 bit data output to rtc_mc_if
    input  logic i_ack,// Acknowledgement signal input from rtc_mc_if
    output logic [30:0] rd_dec_addr // 31 bits read channel register select vector output to rtc_mc_if
    );
 
 // internal signal 
 logic rd_vaild_addr;
 
 // Decoder
always_comb
begin
 if (i_rd_en) begin    
   if (i_addr == 6'h00) begin
     rd_dec_addr = 31'h01;
   end else if(i_addr == 6'h01) begin
     rd_dec_addr = 31'h02;
   end else if(i_addr == 6'h02) begin
     rd_dec_addr = 31'h04;
   end else if(i_addr == 6'h03) begin
     rd_dec_addr = 31'h08;
   end else if(i_addr == 6'h04) begin
     rd_dec_addr = 31'h10;
   end else if(i_addr == 6'h05) begin
     rd_dec_addr = 31'h20;
   end else if(i_addr == 6'h06) begin
     rd_dec_addr = 31'h40;
   end else if(i_addr == 6'h07) begin
     rd_dec_addr = 31'h80;
   end else if(i_addr == 6'h08) begin
     rd_dec_addr = 31'h100;
   end else if(i_addr == 6'h14) begin
     rd_dec_addr = 31'h40000;
   end else if(i_addr == 6'h15) begin
     rd_dec_addr = 31'h80000;
   end else if(i_addr == 6'h16) begin
     rd_dec_addr = 31'h100000;
   end else if(i_addr == 6'h17) begin
     rd_dec_addr = 31'h200000;    
   end else if(i_addr == 6'h18) begin
     rd_dec_addr = 31'h400000;
   end else if(i_addr == 6'h19) begin
     rd_dec_addr = 31'h800000;     
   end else if(i_addr == 6'h1A) begin
     rd_dec_addr = 31'h1000000;
   end else if(i_addr == 6'h1B) begin
     rd_dec_addr = 31'h2000000;
   end else if(i_addr == 6'h1C) begin
     rd_dec_addr = 31'h4000000;
   end else if(i_addr == 6'h1D) begin
     rd_dec_addr = 31'h8000000;
   end else if(i_addr == 6'h1E) begin
     rd_dec_addr = 31'h10000000;
   end else if(i_addr == 6'h1F) begin
     rd_dec_addr = 31'h20000000;             
   end else if(i_addr == 6'h20) begin
     rd_dec_addr = 31'h40000000;
   end else begin
     rd_dec_addr = 31'h0;
   end
 end else begin
   rd_dec_addr = 31'h0;
 end 
end

// Valid or invalid read address logic
always_comb begin
  if (i_reset) begin
     rd_vaild_addr = 1'b0;
  end else begin     
     if( (i_addr== 6'h00) || (i_addr== 6'h01) || (i_addr== 6'h02) || (i_addr== 6'h03) || (i_addr== 6'h04)
      || (i_addr== 6'h05) || (i_addr== 6'h06) || (i_addr== 6'h07) || (i_addr== 6'h08) || (i_addr== 6'h14)
      || (i_addr== 6'h15) || (i_addr== 6'h16) || (i_addr== 6'h17) || (i_addr== 6'h18) || (i_addr== 6'h19)
      || (i_addr== 6'h1A) || (i_addr== 6'h1B) || (i_addr== 6'h1C) || (i_addr== 6'h1D) || (i_addr== 6'h1E)
      || (i_addr== 6'h1F) || (i_addr== 6'h20)) begin
        rd_vaild_addr = 1'b1;
     end else begin
        rd_vaild_addr = 1'b0;
     end
   end
 end

// 32 bits data output logic
always_comb
begin
 if (i_rd_en && rd_vaild_addr) begin
   if (i_ack) begin
     o_reg_data <= i_reg_r_data;
   end else begin
     o_reg_data <= 32'h0000_0000;
   end
 end else begin
    o_reg_data <= 32'h0000_0000;
 end
end
endmodule


 


