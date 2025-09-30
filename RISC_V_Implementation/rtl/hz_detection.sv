`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 10:10:47 AM
// Design Name: 
// Module Name: riscv_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hz_detection(
    input logic clk,
    input logic rst,
    input logic [32-1:0] instr,


    output logic stall,
    output logic [32-1:0] instr_out,
    output logic is_branch

    );
    logic [6:0] opcode;
    logic [1:0] stall_cnt;
    logic [1:0] stall_cnt_next;
    logic stall_ow; 
    logic [4:0] prev_writes [2];
    logic prev_stall;
    logic stall_next_cycle;
    //logic is_branch;

    always_comb begin
        opcode = instr[6:0];
        // latch removal
        stall_cnt_next = 2'b00;
        stall_ow = 1'b0;
        is_branch = 1'b0;
        stall_next_cycle = 1'b0;


        if (prev_stall != 1'b1) begin
        
            if ((instr[19:15] ==  prev_writes[0] || instr[24:20] == prev_writes[0] && prev_writes[0]) != 5'b00000) begin // just used
                stall_cnt_next = 2'b01;
                stall_ow = 1'b1;
            end
            else if ((instr[19:15] ==  prev_writes[1] || instr[24:20] == prev_writes[1] && prev_writes[1]) != 5'b00000) begin // used 2 cycles ago
                // No next stall, but ow stalls 1 cycle
                stall_ow = 1'b1;
            end
        end

        if ((opcode == 7'b1100011 || opcode == 7'b1101111 || opcode == 7'b1100111) && stall == 1'b0) begin // if branch or jump instruction - should stall before next instruction instead of before this instruction
            stall_next_cycle = 1'b1;
            is_branch = 1'b1;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            stall_cnt <= 1'b0;
            prev_writes[0] <= 5'b00000;
            prev_writes[1] <= 5'b00000;
            prev_stall <= 1'b0;
        end else if (stall_next_cycle) begin
            stall_cnt <= 2'b10;
            prev_writes[0] <= 5'b00000;
            prev_writes[1] <= 5'b00000;
            prev_stall <= 1'b1;

        end else if (stall) begin
            prev_writes[0] <= 5'b00000;
            prev_writes[1] <= 5'b00000;
            prev_stall <= 1'b1;
            if (stall_ow) begin 
                stall_cnt <= stall_cnt_next;
            end else if (stall_cnt > 2'b00) begin
                stall_cnt <= stall_cnt - 1;
            end 

            
 
        end else begin
            // save previous writes
            prev_writes[1] <= prev_writes[0];
            prev_writes[0] <= instr[11:7];
            prev_stall <= 1'b0;


        end
    end

assign stall = (stall_cnt != 2'b00) | stall_ow;
assign instr_out = stall ? 32'h00000013 : instr; // NOP if stalled

endmodule