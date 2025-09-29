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

parameter PROGRAM_COUNTER_WIDTH = 32;

module program_counter(
    input logic clk,
    input logic rst,
    input logic jump,
    input logic not_relative_pc,
    input logic [PROGRAM_COUNTER_WIDTH-1:0] jump_address,

    output logic [PROGRAM_COUNTER_WIDTH-1:0] output_pc
    );
    logic [PROGRAM_COUNTER_WIDTH-1:0] pc;
    logic [PROGRAM_COUNTER_WIDTH-1:0] next_pc;
    logic [PROGRAM_COUNTER_WIDTH-1:0] sig1;
    logic [PROGRAM_COUNTER_WIDTH-1:0] sig2;

    assign output_pc = next_pc;

    always_comb begin : Next_PC_Logic
        sig1 = jump ? jump_address : 4;
        sig2 = not_relative_pc ? 0 : pc;
        next_pc = sig1 + sig2;
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            pc <= {PROGRAM_COUNTER_WIDTH{1'b0}};
        end else begin
            pc <= next_pc;
        end
    end
endmodule