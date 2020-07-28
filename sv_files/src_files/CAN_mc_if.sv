//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: can_mc_if
  Author:Pengfei He
  Date:July/22/2020
  Module Description: Decodes input address from Microcontroller and pulses the chip select bit corresponding 
  to the register being addressed. On a low to high transition of â€˜i_csâ€?, if â€˜i_readnegwriteâ€? is high then this
  signals the start of a read operation, otherwise it starts a write operation.
  ---------------------------------------------------------------------------------*/


module can_mc_if(
//  signals from wrapper 
    input  logic i_sys_clk, // 100 Mhz system clock input 
    input  logic i_reset,  //  active high asynchronous reset
    input  logic [31:0] i_bus_data, // 32 bits input data from wrapper
    input  logic [5:0] i_addr, // 6 bits address input 
    input  logic i_r_neg_w, // Read operation when 'i_r_neg_w' is high or write operation when 'i_r_neg_w' is low
    input  logic i_cs, // Chip select signal. Active high
//  signals from MC_IF to wrapper
    output  logic [31:0] o_reg_data, // 32 bits data output to wrapper
    output  logic o_ack, // Acknowledgement signal output to wrapper
    output  logic o_error, // error signal outputs to wrapper 
//  signals from configuration register to MC_IF
    input  logic [31:0] i_reg_r_data, // 32 bits data input from configuration register
    input  logic i_reg_ack, // Acknowledgement signal input from configuration register
    input  logic i_reg_error, // Error signal input from configration register 
//  signals from MC_IF to configuration register
    output  logic [31:0] o_reg_w_bus, // 32 bits data outputs to configuration regsiter
    output  logic [30:0] o_rs_vector, // 31 bits register select signal output to configuration regsiter
    output  logic o_r_neg_w  // read or write operation output signal to configuration resiter
    );

//----------internal signals begin----------//    
logic rd_op; // read channel enable
logic wr_op; // write channel enable 

logic [30:0] rd_dec_addr;// 31 bits read channel register select signal
logic [30:0] wr_dec_addr;// 31 bits write channel register select signal
//----------internal signals end----------//  

// read channel submodule    
can_read_channel read_channel (.i_rd_en (rd_op),
                           .i_reset(i_reset),
                           .i_addr(i_addr),
                           .i_reg_r_data(i_reg_r_data),
                           .o_reg_data(o_reg_data),
                           .i_ack(i_reg_ack),
                           .rd_dec_addr(rd_dec_addr)); 
 // write channel submodule                     
can_write_channel write_channel (.i_wr_en (wr_op),
                             .i_reset(i_reset),
                             .i_addr(i_addr),
                             .i_bus_data(i_bus_data),
                             .o_reg_w_bus(o_reg_w_bus),
                             .wr_dec_addr(wr_dec_addr));  
                             
 //one pulse signal decoder submodule                            
can_one_pulse_decoder One_Pulse_Decoder(.i_sys_clk(i_sys_clk),                              
                                    .i_reset(i_reset),
                                    .i_r_neg_w(i_r_neg_w),
                                    .i_cs(i_cs),
                                    .rd_dec_addr(rd_dec_addr),
                                    .wr_dec_addr(wr_dec_addr),
                                    .o_rs_vector(o_rs_vector));
 always_comb begin
   if (i_reset) begin 
     o_ack      = 1'b0;
     o_error    = 1'b0;
     o_r_neg_w  = 1'b0;
   end else begin
     o_ack     = i_reg_ack;
     o_error   = i_reg_error;
     o_r_neg_w = i_r_neg_w; 
   end
 end 
// Write or Read Operation Select    
always_ff@(posedge i_sys_clk or  posedge i_reset)
 begin
  if(i_reset) begin
   rd_op  <=1'b0;
   wr_op  <=1'b0;
  end else if (i_cs == 1'b1 && i_r_neg_w == 1'b1) begin
   rd_op  <= 1'b1;
  end else if (i_cs == 1'b1 && i_r_neg_w == 1'b0) begin
   wr_op  <= 1'b1;
  end else begin
   rd_op  <=1'b0;
   wr_op  <=1'b0;
  end
 end
 
 


endmodule
