

module CAN_ACF_TB;
    logic i_sys_clk;
    logic i_reset;
    logic i_rx_full;
    logic [31:0] i_afmr1;
    logic [31:0] i_afmr2;
    logic [31:0] i_afmr3;
    logic [31:0] i_afmr4;
    logic [31:0] i_afir1;
    logic [31:0] i_afir2;
    logic [31:0] i_afir3;
    logic [31:0] i_afir4;
    logic i_uaf1;
    logic i_uaf2;
    logic i_uaf3;
    logic i_uaf4;
// signals output to configuration register   
    logic o_rx_w_en;
    logic [127:0] o_rx_fifo_w_data;
    logic o_acfbsy;
// signals from bit stream processor     
    logic i_can_clk;
    logic i_can_ready;
    logic [127:0] i_rx_message;
    
CAN_Acceptance_Filter DUT ( .i_sys_clk,
                        .i_reset,
                        .i_rx_full,            
                        .i_afmr1,      
                        .i_afmr2,      
                        .i_afmr3,      
                        .i_afmr4,      
                        .i_afir1,      
                        .i_afir2,      
                        .i_afir3,      
                        .i_afir4,      
                        .i_uaf1,              
                        .i_uaf2,              
                        .i_uaf3,              
                        .i_uaf4,              
                        .o_rx_w_en,           
                        .o_rx_fifo_w_data,
                        .o_acfbsy,            
                        .i_can_clk,           
                        .i_can_ready,         
                        .i_rx_message);
 
 
 always begin
 #5 i_sys_clk = !i_sys_clk;
 end
  
 always begin
 #20 i_can_clk = !i_can_clk;
 end
 
 initial
 begin
 // ----------- module reset start-------------//
 i_sys_clk <= 0;
 i_reset <=1;
 i_rx_full<=0;          
 i_afmr1<=32'hffff_ffff; 
 i_afmr2<=32'hffff_ffff;      
 i_afmr3<=32'hffff_ffff;      
 i_afmr4<=32'hffff_ffff;      
 i_afir1<=32'h0001_0000;      
 i_afir2<=32'h0001_0000;      
 i_afir3<=32'h0001_0000;      
 i_afir4<=32'h0001_0000;      
 i_uaf1<=0;              
 i_uaf2<=0;              
 i_uaf3<=0;              
 i_uaf4<=0;                       
 i_can_clk<=0;           
 i_can_ready<=0;        
 i_rx_message<=128'h0000_0000_0000_0000_0000_00000_0000_0000;
  // ----------- module reset end-------------//
 // All 4 accepetance filters exist
 #25
 @(posedge i_sys_clk)
 i_reset <=0;
 i_rx_full<=0;          
 i_afmr1<=32'hffff_ffff; 
 i_afmr2<=32'hffff_ffff;      
 i_afmr3<=32'hffff_ffff;      
 i_afmr4<=32'hfff0_ffff;      
 i_afir1<=32'h0001_0000;      
 i_afir2<=32'h0002_0000;      
 i_afir3<=32'h0003_0000;      
 i_afir4<=32'h0004_0000;      
 i_uaf1<=0;              
 i_uaf2<=0;              
 i_uaf3<=0;              
 i_uaf4<=0;
 // -------------------If any of uaf bit is set to 0,o_acf is set to 1 begin ----------------//       
 @(posedge i_sys_clk)
   i_uaf1<=1;   
 @(posedge i_can_clk)
 @(posedge i_can_clk)
 assert (o_acfbsy == 1'b1) $display ("----- AF_TC20 PASSED ----");
 else $error ("----- AF_TC20 FAILED ------");
 // ------------------------ If any of uaf bit is set to 0,o_acf is set to 1 end -------- //
 
 // -----------------------enable all filters begin ----------------//
 @(posedge i_sys_clk)
 i_uaf1<=1;              
 i_uaf2<=1;              
 i_uaf3<=1;              
 i_uaf4<=1;
  // ----------------------enable all filters end ---------------------- //
  
 // ----------------------- ID = 0X0001_0000  begin -----------------//   
  @(posedge i_can_clk)
  i_can_ready<=1;        
  i_rx_message<=128'h0001_0000_0000_0000_0000_0000_0000_0000;        
  @(posedge i_can_clk)                 
  i_can_ready<=0;  
  assert ( o_rx_fifo_w_data == 128'h0001_0000_0000_0000_0000_0000_0000_0000) $display ("------ AF_TC_15 PASSED ------");
  else $error ("------ AF_TC_15 FAILED -------");
//------------------------ ID = 0X0001_0000  end -----------------//

 // -------------------- ID = 0X0008_0000  begin ----------------//
  @(posedge i_can_clk)
  i_can_ready<=1;        
  i_rx_message<=128'h0005_0000_0000_0000_0000_0000_0000_0000;       
  @(posedge i_can_clk)                 
  i_can_ready<=0;  
  assert ( o_rx_fifo_w_data == 128'h0005_0000_0000_0000_0000_0000_0000_0000) $display ("------ AF_TC_8 PASSED ------");
  else $error ("------ AF_TC_8 FAILED -------");
 //--------------------- ID = 0X0008_0000  end ----------------//
 
 
 //------------------ ALL uaf bits set to 0 begin -------------//
 @(posedge i_sys_clk)
 i_uaf1<=0;              
 i_uaf2<=0;              
 i_uaf3<=0;              
 i_uaf4<=0;
 //-----------------ALL uaf bits set to 0 end---------------//
 
 //--------------- AF_TC 18 begin ---------------------//
  @(posedge i_can_clk)
  i_can_ready<=1;        
  i_rx_message<=128'h0111_0000_0000_0000_0000_0000_0000_0000;       
  @(posedge i_can_clk)                 
  i_can_ready<=0;  
  assert ( o_rx_fifo_w_data == 128'h0111_0000_0000_0000_0000_0000_0000_0000) $display ("------ AF_TC_18 PASSED ------");
  else $error ("------ AF_TC_18 FAILED -------");
 //--------------- AF_TC 18 end ---------------------//
 
 //--------------- AF_TC 16 begin ---------------------//
  @(posedge i_sys_clk)
  i_rx_full = 1;
  @(posedge i_can_clk)
  i_can_ready<=1;        
  i_rx_message<=128'h0114_0000_0000_0000_0000_0000_0000_0000;       
  @(posedge i_can_clk)                 
  i_can_ready<=0;  
  assert ( o_rx_fifo_w_data == 128'h0111_0000_0000_0000_0000_0000_0000_0000) $display ("------ AF_TC_16 PASSED ------");
  else $error ("------ AF_TC_16 FAILED -------");
 //--------------- AF_TC 16 end ---------------------//
 
  $display("FINISHED");
  $finish;
 end
endmodule
