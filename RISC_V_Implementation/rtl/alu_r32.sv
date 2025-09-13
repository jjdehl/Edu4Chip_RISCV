`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 10:10:47 AM
// Design Name: 
// Module Name: alu
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

module alu_r32#(
    parameter INSTR_LENGTH = 32
    )(
    input  logic                    clk,
    input  logic                    rst,
    input  logic [INSTR_LENGTH-1:0] data1,
    input  logic [INSTR_LENGTH-1:0] data2,
    input  logic [INSTR_LENGTH-1:0] alu_op,
    output logic [INSTR_LENGTH-1:0] result
    );

    logic [6:0] opcode = alu_op[6:0];

    always_comb @(*) begin
        case (opcode)
        
        7'b0010011': begin // I-type ALU operations
            case (alu_op[14:12]) // funct3 field
                logic [11:0] inplace = alu_op[31:20];
                3'b000: result = data1 + inplace; // ADDI
                3'b010: result = (data1 < inplace) ? 1 : 0; // SLTI
                3'b111: result = data1 & inplace; // ANDI
                default: result = {INSTR_LENGTH{1'b0}}; // Default case
            endcase
        end

        7'b0110011' : begin
            case (alu_op[14:12])    
                3'b000: begin
                    case (alu_op[31:25]) // Can be optimized a lot...
                        7'b0000000: result = data1 + data2; // ADD
                        7'b0100000: result = data1 - data2; // SUB
                        default: result = {INSTR_LENGTH{1'b0}}; // Default case
                    endcase
                end
            endcase
        end


        default: begin
            result = {INSTR_LENGTH{1'b0}};
        end
        endcase
    end



endmodule