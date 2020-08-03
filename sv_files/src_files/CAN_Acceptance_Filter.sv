//////////////////////////////////////////////////////////////////////////////////
/*--------------------------------------------------------------------------------
  Project: CAN Controllor 
  Module: Acceptance_Filter
  Author:Pengfei He
  Date:July/24/2020
  Module Description: Acceptance Filter is used to accept or drop 128 bits 
                     input data by comparing [127:96] of input data.
  ---------------------------------------------------------------------------------*/


module CAN_Acceptanbce_Filter
#( parameter integer NUMBER_OF_ACCEPTANCE_FILTRES = 0)
  (
// signals input from configuration register
    input logic i_sys_clk,
    input logic i_reset,
    input logic i_rx_full,
    input logic [31:0] i_afmr1,
    input logic [31:0] i_afmr2,
    input logic [31:0] i_afmr3,
    input logic [31:0] i_afmr4,
    input logic [31:0] i_afir1,
    input logic [31:0] i_afir2,
    input logic [31:0] i_afir3,
    input logic [31:0] i_afir4,
    input logic i_uaf1,
    input logic i_uaf2,
    input logic i_uaf3,
    input logic i_uaf4,
// signals output to configuration register   
    output logic o_rx_w_en,
    output logic [127:0] o_rx_fifo_w_data,
    output logic o_acfbsy,
// signals input from bit stream processor     
    input logic i_can_clk,
    input logic i_can_ready,
    input logic [127:0] i_rx_message
    );



// ----- internal signals bgein -------//
  
  logic afr_acfbsy1; //acfbsy signal of first acceptence filter
  logic afr_acfbsy2; //acfbsy signal of second acceptence filter
  logic afr_acfbsy3; //acfbsy signal of third acceptence filter
  logic afr_acfbsy4; //acfbsy signal of fourth acceptence filter
  logic acfbsy_bus;  //acfbsy signal internal bus wire
  logic afr_pass1;   //pass signal of first acceptence filter
  logic afr_pass2;   //pass signal of second acceptence filter
  logic afr_pass3;   //pass signal of third acceptence filter
  logic afr_pass4;   //pass signal of fourth acceptence filter
  logic pass_bus;    //pass signal internal bus wire
  logic afr_uaf_bus; //uaf signal internal bus wire
  logic syn_can_ready; // Synchronous 'i_can_ready' signal

// ----- internal signals end -------//
  
 CAN_ACF_Synchronizer Synchronizer(.i_sys_clk,     
                               .i_can_clk,     
                               .i_reset,       
                               .i_can_ready,   
                               .o_can_ready(syn_can_ready));               

// Generate acceptence filter depending on NUMBER_OF_ACCEPTANCE_FILTRES
  generate 
    if ( NUMBER_OF_ACCEPTANCE_FILTRES == 1 ) begin
      CAN_AFR_CU AFR_CU(.i_cu_sys_clk(i_sys_clk), .i_cu_reset(i_sys_reset),.i_cu_rx_full(i_rx_full),.i_cu_uaf_bus(afr_uaf_bus),.i_cu_syn_can_ready(syn_can_ready),
      .i_cu_pass_bus(pass_bus),.i_cu_acfbsy_bus(acfbsy_bus),.i_cu_rx_message(i_rx_message),.o_cu_rx_w_en(o_rx_w_en),.o_cu_rx_fifo_w_data(o_rx_fifo_w_data),.o_cu_acfbsy(o_acfbsy));
      CAN_AFR AFR1(.i_afr_uaf(i_uaf1),.i_afr_afmr(i_afmr1),.i_afr_afir(i_afir1),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy1),.o_afr_pass(afr_pass1));
    end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 2) begin
      CAN_AFR_CU AFR_CU(.i_cu_sys_clk(i_sys_clk), .i_cu_reset(i_sys_reset),.i_cu_rx_full(i_rx_full),.i_cu_uaf_bus(afr_uaf_bus),.i_cu_syn_can_ready(syn_can_ready),
      .i_cu_pass_bus(pass_bus),.i_cu_acfbsy_bus(acfbsy_bus),.i_cu_rx_message(i_rx_message),.o_cu_rx_w_en(o_rx_w_en),.o_cu_rx_fifo_w_data(o_rx_fifo_w_data),.o_cu_acfbsy(o_acfbsy));
      CAN_AFR AFR1(.i_afr_uaf(i_uaf1),.i_afr_afmr(i_afmr1),.i_afr_afir(i_afir1),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy1),.o_afr_pass(afr_pass1));
      CAN_AFR AFR2(.i_afr_uaf(i_uaf2),.i_afr_afmr(i_afmr2),.i_afr_afir(i_afir2),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy2),.o_afr_pass(afr_pass2));
    end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 3) begin
      CAN_AFR_CU AFR_CU(.i_cu_sys_clk(i_sys_clk), .i_cu_reset(i_sys_reset),.i_cu_rx_full(i_rx_full),.i_cu_uaf_bus(afr_uaf_bus),.i_cu_syn_can_ready(syn_can_ready),
      .i_cu_pass_bus(pass_bus),.i_cu_acfbsy_bus(acfbsy_bus),.i_cu_rx_message(i_rx_message),.o_cu_rx_w_en(o_rx_w_en),.o_cu_rx_fifo_w_data(o_rx_fifo_w_data),.o_cu_acfbsy(o_acfbsy));
      CAN_AFR AFR1(.i_afr_uaf(i_uaf1),.i_afr_afmr(i_afmr1),.i_afr_afir(i_afir1),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy1),.o_afr_pass(afr_pass1));
      CAN_AFR AFR2(.i_afr_uaf(i_uaf2),.i_afr_afmr(i_afmr2),.i_afr_afir(i_afir2),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy2),.o_afr_pass(afr_pass2));
      CAN_AFR AFR3(.i_afr_uaf(i_uaf3),.i_afr_afmr(i_afmr3),.i_afr_afir(i_afir3),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy3),.o_afr_pass(afr_pass3));
    end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 4) begin
      CAN_AFR_CU AFR_CU(.i_cu_sys_clk(i_sys_clk), .i_cu_reset(i_sys_reset),.i_cu_rx_full(i_rx_full),.i_cu_uaf_bus(afr_uaf_bus),.i_cu_syn_can_ready(syn_can_ready),
      .i_cu_pass_bus(pass_bus),.i_cu_acfbsy_bus(acfbsy_bus),.i_cu_rx_message(i_rx_message),.o_cu_rx_w_en(o_rx_w_en),.o_cu_rx_fifo_w_data(o_rx_fifo_w_data),.o_cu_acfbsy(o_acfbsy));   
      CAN_AFR AFR1(.i_afr_uaf(i_uaf1),.i_afr_afmr(i_afmr1),.i_afr_afir(i_afir1),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy1),.o_afr_pass(afr_pass1));
      CAN_AFR AFR2(.i_afr_uaf(i_uaf2),.i_afr_afmr(i_afmr2),.i_afr_afir(i_afir2),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy2),.o_afr_pass(afr_pass2));
      CAN_AFR AFR3(.i_afr_uaf(i_uaf3),.i_afr_afmr(i_afmr3),.i_afr_afir(i_afir3),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy3),.o_afr_pass(afr_pass3));
      CAN_AFR AFR4(.i_afr_uaf(i_uaf4),.i_afr_afmr(i_afmr4),.i_afr_afir(i_afir4),.in_rx_message(i_rx_message[127:96]),.o_afr_acfbsy(afr_acfbsy4),.o_afr_pass(afr_pass4));
    end else begin
      CAN_ACF_NOT_EXIST ACF_NOT_EXIST(.i_syn_can_ready(syn_can_ready),.i_rx_message(i_rx_message), .i_rx_full(i_rx_full),.o_rx_w_en(o_rx_w_en),.i_rx_fifo_w_data(o_rx_fifo_w_data));   
    end 
  endgenerate;
      
// Mux Selector for 'acfbsy_bus' signal
  always_comb begin
     if(i_reset) begin
       acfbsy_bus = 1'b0;
     end else begin
        if (NUMBER_OF_ACCEPTANCE_FILTRES == 1) begin
            acfbsy_bus = afr_acfbsy1;
        end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 2) begin
            acfbsy_bus = afr_acfbsy1 || afr_acfbsy2;
        end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 3) begin
            acfbsy_bus = afr_acfbsy1 || afr_acfbsy2 | afr_acfbsy3;
        end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 4) begin
            acfbsy_bus = afr_acfbsy1 || afr_acfbsy2 || afr_acfbsy3 || afr_acfbsy4;;
        end else begin
            acfbsy_bus = 1'b0;
        end
      end
    end
    
// Mux Selector for 'pass_bus' signal
  always_comb begin
     if(i_reset) begin
       pass_bus = 1'b0;
     end else begin
        if (NUMBER_OF_ACCEPTANCE_FILTRES == 1) begin
            pass_bus = afr_pass1;
        end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 2) begin
            pass_bus = afr_pass1 || afr_pass2;
        end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 3) begin
            pass_bus = afr_pass1 || afr_pass2 || afr_pass3;
        end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 4) begin
            pass_bus = afr_pass1 || afr_pass2 || afr_pass3 || afr_pass4;
        end else begin
            pass_bus = 1'b0;
        end
      end
    end

// Mux Selector for 'uaf_bus' signal    
  always_comb begin
     if(i_reset) begin
       afr_uaf_bus = 1'b0;
     end else begin
        if (NUMBER_OF_ACCEPTANCE_FILTRES == 1) begin
            afr_uaf_bus = i_uaf1;
        end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 2) begin
            afr_uaf_bus = i_uaf1 || i_uaf2;
        end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 3) begin
            afr_uaf_bus = i_uaf1 || i_uaf2 || i_uaf3;
        end else if(NUMBER_OF_ACCEPTANCE_FILTRES == 4) begin
            afr_uaf_bus = i_uaf1 || i_uaf2 || i_uaf3 || i_uaf4;;
        end else begin
            afr_uaf_bus = 1'b0;
        end
      end
    end

endmodule
