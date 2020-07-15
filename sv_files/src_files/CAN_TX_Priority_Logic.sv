/*-------------------------------------------------------------------------------
Project: CAN Controller
Module: TX Priority Logic
Author: Waseem Orphali
Date: 07/13/2020
Module Description: This module implements the TX priority logic module as described
in the specifications doc and Xilinx data sheet. It also synchronizes signals between
sys_clk and can_clk. 
  
---------------------------------------------------------------------------------*/

module CAN_TX_Priority_Logic
    (
    input   logic           i_sys_clk,
    input   logic           i_can_clk,
    input   logic           i_reset,
    input   logic           i_hpbfull,
    input   logic   [127:0] i_hpb_data,
    input   logic           i_cen,
    input   logic           i_tx_empty,
    input   logic   [127:0] i_fifo_data,
    input   logic           i_busy_can,
    
    output  logic   [127:0] o_send_data,
    output  logic           o_send_en,
    output  logic           o_hpb_r_en,
    output  logic           o_fifo_r_en
    );
    
    localparam   IDLE        = 3'b000;
    localparam   PREPARE     = 3'b001;
    localparam   SEND_HPB    = 3'b011;
    localparam   SEND_FIFO   = 3'b010;
    localparam   SEND        = 3'b110;
        
    logic   [2:0]   state   = IDLE;
    logic   [2:0]   n_state = IDLE;

    logic           latch_fifo = 1'b0;
    logic           latch_hpb = 1'b0;
    logic   [127:0] latch_data = 128'b0;
// Synchronization signals (t: temp, s: synchronized):
    logic   [127:0] t_send_data = 128'b0;
    logic   [127:0] s_send_data = 128'b0;
    logic           t_busy_can  = 1'b0;
    logic           s_busy_can  = 1'b0;
    logic           t_send_en   = 1'b0;
    logic           s_send_en   = 1'b0;
    
    
// Synchronizing signals coming from CAN clock:
    always @(posedge i_sys_clk) begin
        t_busy_can <= i_busy_can;
        s_busy_can <= t_busy_can;
    end

// Synchronizing signals going to CAN clock:
    always @(posedge i_can_clk or posedge i_reset) begin
        if (i_reset) begin
            o_send_data <= 128'b0;
            o_send_en   <= 1'b0;
        end
        else begin
            t_send_data <= s_send_data;
            o_send_data <= t_send_data;
            
            t_send_en   <= s_send_en;
            o_send_en   <= t_send_en;
        end
    end
        
// Sequential state transition process:
    always @(posedge i_sys_clk or posedge i_reset) begin
        if (i_reset == 1'b1)
            state <= IDLE;
        else
            state <= n_state;
    end
    
// Combinational state action process
    always @(state or i_hpbfull or i_hpb_data or i_cen or i_tx_empty or i_fifo_data or s_busy_can) begin
        s_send_data = 128'b0;
        s_send_en   = 1'b0;
        o_hpb_r_en  = 1'b0;
        o_fifo_r_en = 1'b0;
        latch_fifo  = 1'b0;
        latch_hpb   = 1'b0;
        n_state     = 'bx;
        
        case (state)
            IDLE: begin
                if (i_cen == 1)                                 n_state = PREPARE;
                else                                            n_state = IDLE;
            end
            
            PREPARE: begin
                latch_hpb   = i_hpbfull;
                latch_fifo  = ~i_tx_empty;
                if (i_cen == 0)                                 n_state = PREPARE;
                else if (s_busy_can == 0 && i_hpbfull == 1)     n_state = SEND_HPB;
                else if (s_busy_can == 0 && i_tx_empty == 0)    n_state = SEND_FIFO;
                else                                            n_state = PREPARE;
            end
            SEND_HPB: begin
                o_hpb_r_en = 1'b1;
                                                                n_state = SEND; 
            end
            SEND_FIFO: begin
                o_fifo_r_en = 1'b1;
                                                                n_state = SEND;
            end
            SEND: begin
                s_send_en = 1'b1;
                s_send_data = latch_data;
                if (i_cen == 1'b0)                              n_state = SEND;
                else if (s_busy_can == 1'b1)                    n_state = PREPARE;
                else                                            n_state = SEND;
            end
        endcase
    end
    
    always @(posedge i_sys_clk or posedge i_reset) begin
        if (i_reset)
            latch_data <= 128'b0;
        else if (latch_hpb == 1'b1) 
            latch_data <= i_hpb_data;
        else if (latch_fifo == 1'b1)
            latch_data <= i_fifo_data;
    end
    
endmodule
             