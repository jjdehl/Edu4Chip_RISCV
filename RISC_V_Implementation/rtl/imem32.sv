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
// IMPLEMENTED AS A ROM INITIALLY.
//////////////////////////////////////////////////////////////////////////////////
    parameter INSTR_LENGTH = 32; // Cannot be changed, but is defined as a constant for convenience
    parameter MEM_DEPTH = 32;
    parameter ADDR_WIDTH = 5;

module imem32(
    input  logic clk,
    input  logic rst,
    input  logic [ADDR_WIDTH-1:0] addr,
    output logic [INSTR_LENGTH-1:0] instr
    );
    integer i;

    logic [INSTR_LENGTH-1:0] instr_reg[MEM_DEPTH];

    always_ff @(posedge clk) begin
        if (rst) begin
            instr <= {INSTR_LENGTH{1'b0}};
        end else begin
            instr <= instr_reg[addr];
        end
    end 

    // SET ROM
    initial begin
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            instr_reg[i] = 32'h00000013; // Might not be needed.
        end

        // Example instructions, can be modified as needed
        // Load immediate values into registers x1 and x2
        instr_reg[0] = 32'h00000113; // ADDI x3, x0, 0 (initialize x3 to 0)
        instr_reg[1] = 32'h00100213; // ADDI x4, x0, 1 (load 1 into x4)
        instr_reg[2] = 32'h00200293; // ADDI x5, x0, 2 (load 2 into x5)

        // Add the values in x4 and x5, store result in x3
        instr_reg[3] = 32'h00000013; // STALL (but not the correct one)
        
        instr_reg[5] = 32'h005201B3; // ADD x3, x4, x5

        // Add x3 and x4, store result in x5
        instr_reg[6] = 32'h00000013; // STALL (but not the correct one)
        instr_reg[8] = 32'h004182B3; // ADD x5, x3, x4

        //instr_reg[10]  = 32'h02800167; //32'h028001EF; // This is JALR to 0x0028
        instr_reg[10] = 32'hFF9FF06F;//hFE2FF0EF;

        // End of program marker (NOP instruction)
        //instr_reg[6] = 32'h00000013; // NOP - same as default at reset
    end


endmodule