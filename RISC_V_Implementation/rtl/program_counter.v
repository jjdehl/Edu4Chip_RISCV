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



module program_counter(
    parameter PROGRAM_COUNTER_WIDTH = 16
    )(
    input clk,
    input rst,
    input run,
    input jump,
    input [PROGRAM_COUNTER_WIDTH-1:0] jump_address,

    output reg [PROGRAM_COUNTER_WIDTH-1:0] pc
    );

    wire [PROGRAM_COUNTER_WIDTH-1:0] next_pc = run ? (jump ? jump_address : pc + 1) : pc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= {PROGRAM_COUNTER_WIDTH{1'b0}};
        end else begin
            pc <= next_pc;
        end
    end
endmodule