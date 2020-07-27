//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: Microcontroller Interface
  Author:Pengfei He
  Date:July/22/2020
  Module Description: Test bench for microcontroller interface
  ---------------------------------------------------------------------------------*/

module MC_IF_TB;
//  signals from wrapper 
      logic i_sys_clk; // 100 Mhz system clock input 
      logic i_reset;  //  active high asynchronous reset
      logic [31:0] i_bus_data; // 32 bits input data from wrapper
      logic [5:0] i_addr; // 6 bits address input 
      logic i_r_neg_w; // Read operation when 'i_r_neg_w' is high or write operation when 'i_r_neg_w' is low
      logic i_cs; // Chip select signal. Active high
//  signals from MC_IF to wrapper
      logic [31:0] o_reg_data; // 32 bits data output to wrapper
      logic o_ack; // Acknowledgement signal output to wrapper
      logic o_error; // error signal outputs to wrapper 
//  signals from configuration register to MC_IF
      logic [31:0] i_reg_r_data; // 32 bits data input from configuration register
      logic i_reg_ack; // Acknowledgement signal input from configuration register
      logic i_reg_error; // Error signal input from configration register 
//  signals from MC_IF to configuration register
      logic [31:0] o_reg_w_bus; // 32 bits data outputs to configuration regsiter
      logic [30:0] o_rs_vector; // 31 bits decoded adress signal output to configuration regsiter
      logic o_r_neg_w;  // read or write operation output signal to configuration resiter
rtc_mc_if UUT (.i_sys_clk,
               .i_reset,
               .i_bus_data,
               .i_addr,.i_r_neg_w,.i_cs,.o_reg_data,.o_ack,.o_error,.i_reg_r_data,.i_reg_ack,.i_reg_error,.o_reg_w_bus,.o_rs_vector,.o_r_neg_w);

integer i = 0;

always
#5 i_sys_clk <= !i_sys_clk;


initial
begin
i_sys_clk <= 1'b0;
i_reset<=1'b1;
i_r_neg_w <= 0;
i_cs <=0;
i_bus_data<= 32'h0;
i_addr <=31'h00;
i_reg_ack <= 1'b0;
i_reg_error <=1'b0;
i_reg_r_data<=32'h0;
// test read channel with correct read addr begin//
#10
i_reset<=1'b0;
@(posedge i_sys_clk)
i_r_neg_w <= 1;
i_cs <=1;
i_addr <=31'h00;
wait (o_rs_vector == 31'h01);
@(posedge i_sys_clk)
@(posedge i_sys_clk)
@(posedge i_sys_clk)
i_reg_ack <= 1'b1;
i_reg_r_data<=32'h10;
@(posedge i_sys_clk)
i_reg_ack <= 1'b0;
i_r_neg_w <= 1'b0;
i_cs <=1'b0;
assert (o_reg_data == 32'h10) $display("------- read channel with correct read addr is passed------");
else $error ("------ read channel with correct read addr isn't passed -------");
// test read channel with correct read addr end//

// test read channel with incorrect read addr begin//
@(posedge i_sys_clk)
i_r_neg_w <= 1;
i_cs <=1;
i_addr <=31'h30;

for (i = 0; i < 2; i = i+1) begin
 @(posedge i_sys_clk);
end
 @(posedge i_sys_clk)
i_r_neg_w <= 0;
i_cs <=0;
assert (o_reg_data == 32'h0) $display("------- read channel with incorrect read addr is passed------");
else $error ("------ read channel with incorrect read addr isn't passed -------");
// test read channel with incorrect read addr end//

//test write channel with correct write addr begin//
@(posedge i_sys_clk)
i_r_neg_w <= 0;
i_cs <=1;
i_addr <=31'h20;
i_bus_data <= 32'h03;
@(posedge i_sys_clk)
@(posedge i_sys_clk)
@(posedge i_sys_clk)
i_r_neg_w <= 0;
i_cs <=0;
assert (o_reg_w_bus == 32'h03) $display("------- write channel with correct write addr is passed------");
else $error ("------ write channel with correct write addr isn't passed -------");
//test write channel with correct write addr end//

//test write channel with incorrect write addr begin//
@(posedge i_sys_clk)
i_r_neg_w <= 0;
i_cs <=1;
i_addr <=31'h30;
i_bus_data <= 32'h04;
@(posedge i_sys_clk)
@(posedge i_sys_clk)
@(posedge i_sys_clk)
i_r_neg_w <= 0;
i_cs <=0;

assert (o_reg_w_bus == 32'h03) $display("------- write channel with incorrect write addr is passed------");
else $error ("------ write channel with incorrect write addr isn't passed -------");
//test write channel with incorrect write addr end//

//test switching between read and wirte channel while 'i_cs' is 1 begin //
@(posedge i_sys_clk)
i_reset <=1'b1;
@(posedge i_sys_clk)
i_reset <=1'b0;
@(posedge i_sys_clk)
i_r_neg_w <= 1;
i_cs <=1;
i_addr <=31'h00;
wait (o_rs_vector == 31'h01);
@(posedge i_sys_clk)
@(posedge i_sys_clk)
@(posedge i_sys_clk)
i_reg_ack <= 1'b1;
i_reg_r_data<=32'h10;
@(posedge i_sys_clk)
i_reg_ack <= 1'b0;
assert (o_reg_data == 32'h10) $display("------- read channel with correct read addr is passed------");
else $error ("------ read channel with correct read addr isn't passed -------");
@(posedge i_sys_clk)
i_r_neg_w <= 1'b0;
i_cs <=1'b1;
i_addr <=31'h20;
i_bus_data <= 32'h03;

@(posedge i_sys_clk)
@(posedge i_sys_clk)
@(posedge i_sys_clk)
i_r_neg_w <= 0;
i_cs <=0;
assert (o_reg_w_bus == 32'h03) $display("------- write channel with correct write addr is passed------");
else $error ("------ write channel with correct write addr isn't passed -------");

//test switching between read and wirte channel while 'i_cs' is 1 end //
end

endmodule
