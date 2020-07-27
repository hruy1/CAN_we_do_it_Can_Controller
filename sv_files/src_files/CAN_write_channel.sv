//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: can_write_channel --- submodule of Microcontroller Interface
  Author:Pengfei He
  Date:July/22/2020
  Module Description: Write channel of Microcontroller Interface. 
  ---------------------------------------------------------------------------------*/

module can_write_channel(
    input  logic i_wr_en, // write channel enable from rtc_mc_if
    input  logic i_reset, //active high asynchronous reset from rtc_mc_if
    input  logic [5:0] i_addr, //6 bits address input from rtc_mc_if
    input  logic [31:0] i_bus_data, //32 bit data input from rtc_mc_if
    output logic [31:0] o_reg_w_bus, //32 bit data output to rtc_mc_if
    output logic [30:0] wr_dec_addr // 31 bits write channel register select vector output to rtc_mc_if
    );

//--------internal signals begin-------//
logic wr_vaild_addr; 
logic [31:0] temp_data_reg = 32'h0;
//--------internal signals end-------//

// Decoder
always_comb
begin
 if (i_wr_en) begin    
   if (i_addr == 6'h00) begin
     wr_dec_addr = 31'h01;
   end else if(i_addr == 6'h01) begin
     wr_dec_addr = 31'h02;
   end else if(i_addr == 6'h02) begin
     wr_dec_addr = 31'h04;
   end else if(i_addr == 6'h03) begin
     wr_dec_addr = 31'h08;
   end else if(i_addr == 6'h05) begin
     wr_dec_addr = 31'h20;
   end else if(i_addr == 6'h08) begin
     wr_dec_addr = 31'h100;
   end else if(i_addr == 6'h09) begin
     wr_dec_addr = 31'h200;
   end else if(i_addr == 6'h0A) begin
     wr_dec_addr = 31'h400;
   end else if(i_addr == 6'h0B) begin
     wr_dec_addr = 31'h800;
   end else if(i_addr == 6'h0C) begin
     wr_dec_addr = 31'h1000;
   end else if(i_addr == 6'h0D) begin
     wr_dec_addr = 31'h2000;
   end else if(i_addr == 6'h0E) begin
     wr_dec_addr = 31'h4000;
   end else if(i_addr == 6'h0F) begin
     wr_dec_addr = 31'h8000;
   end else if(i_addr == 6'h10) begin
     wr_dec_addr = 31'h10000;
   end else if(i_addr == 6'h11) begin
     wr_dec_addr = 31'h20000;
   end else if(i_addr == 6'h18) begin
     wr_dec_addr = 31'h400000;
   end else if(i_addr == 6'h19) begin
     wr_dec_addr = 31'h800000;
   end else if(i_addr == 6'h1A) begin
     wr_dec_addr = 31'h1000000;
   end else if(i_addr == 6'h1B) begin
     wr_dec_addr = 31'h2000000;
   end else if(i_addr == 6'h1C) begin
     wr_dec_addr = 31'h4000000;
   end else if(i_addr == 6'h1D) begin
     wr_dec_addr = 31'h8000000;
   end else if(i_addr == 6'h1E) begin
     wr_dec_addr = 31'h10000000;
   end else if(i_addr == 6'h1F) begin
     wr_dec_addr = 31'h20000000;
   end else if(i_addr == 6'h20) begin
     wr_dec_addr = 31'h40000000;
   end else begin
     wr_dec_addr = 31'h0;
   end
 end else begin
     wr_dec_addr = 31'h0;
 end
end

// Valid or invalid write address logic
always_comb
begin
  if (i_reset) begin
    wr_vaild_addr = 1'b0;
  end else begin
     if ( (i_addr == 6'h00) || (i_addr== 6'h01) || (i_addr== 6'h02) || (i_addr== 6'h03) || (i_addr== 6'h05)
        || (i_addr== 6'h08) || (i_addr== 6'h09) || (i_addr== 6'h0A) || (i_addr== 6'h0B) || (i_addr== 6'h0C)
        || (i_addr== 6'h0D) || (i_addr== 6'h0D) || (i_addr== 6'h0E) || (i_addr== 6'h0F) || (i_addr== 6'h10)
        || (i_addr== 6'h11) || (i_addr== 6'h18) || (i_addr== 6'h19) || (i_addr== 6'h1A) || (i_addr== 6'h1B)
        || (i_addr== 6'h1C) || (i_addr== 6'h1D) || (i_addr== 6'h1E) || (i_addr== 6'h1F) || (i_addr== 6'h20)) begin
       wr_vaild_addr = 1'b1;
     end else begin
       wr_vaild_addr = 1'b0;
     end
   end
 end


// 32 bits data output logic
always_comb begin
  if (i_reset) begin
    temp_data_reg = 32'h0;
  end else begin
     if(i_wr_en && wr_vaild_addr) begin
        temp_data_reg = i_bus_data;
     end else begin
        temp_data_reg = temp_data_reg;
     end
  end
end

 assign  o_reg_w_bus = temp_data_reg;
endmodule