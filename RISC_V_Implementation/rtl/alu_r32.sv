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


// Currently implements instructions 0110011, 0010011, 0110011, 0110111, 0010111

parameter PIPELINE_STAGES = 2;

module alu_r32 #(
    parameter INSTR_LENGTH = 32
    )(
    input  logic                    clk,
    input  logic                    rst,
    input  logic [INSTR_LENGTH-1:0] data1,
    input  logic [INSTR_LENGTH-1:0] data2,
    input  logic [INSTR_LENGTH-1:0] alu_op,
    input  logic [INSTR_LENGTH-1:0] pc, 

    
    output logic                    pc_jump,
    output logic                    not_relative_pc,
    output logic [INSTR_LENGTH-1:0] jump_offset,

    output logic                    w_mem,
    output logic [INSTR_LENGTH-1:0] result, 

    output logic [1:0]              err // 0 invalid instruction 1 non implemented function code used
    );

    logic [6:0] opcode;
    logic [11:0] inplace; // should probably be expanded use or removed

    always_comb begin
        opcode = alu_op[6:0];
        result = {INSTR_LENGTH{1'b0}}; 
        inplace = {12{1'b0}}; // Not used for all instructions
        w_mem = 1'b0; 
        pc_jump = 1'b0;
        not_relative_pc = 1'b0;
        jump_offset = {INSTR_LENGTH{1'b0}};
        err = 2'b00;

        case (opcode)
        7'b0110011 : begin
            w_mem = 1'b1;
            case (alu_op[14:12])
                3'b000: begin
                    case (alu_op[31:25]) 
                        7'b0000000: result = data1 + data2; // ADD
                        7'b0100000: result = data1 - data2; // SUB
                        default: result = {INSTR_LENGTH{1'b0}}; 
                    endcase
                end

                3'b001: begin // SLL
                    result = data1 << data2[4:0];
                end
                
                3'b010: begin // SLT
                    result = (data1 < data2) ? 1 : 0;
                end

                3'b011: begin // SLTU
                    result = ($unsigned(data1) < $unsigned(data2)) ? 1 : 0;
                end

                3'b100: begin // XOR
                    result = data1 ^ data2;
                end

                3'b101: begin // SRL and SRA
                    case (alu_op[31:25])
                        7'b0000000: result = data1 >> data2[4:0]; // SRL
                        7'b0100000: result = $signed(data1) >>> data2[4:0]; // SRA  - is $signed needed?
                        default: result = {INSTR_LENGTH{1'b0}}; 
                    endcase
                end

                3'b110: begin // OR
                    result = data1 | data2;
                end

                3'b111: begin // AND
                    result = data1 & data2;
                end

                default: err[0] = 1'b1 ; // Invalid instruction

            endcase
        end

        7'b0110111: begin // LUI
            w_mem = 1'b1;
            result = {alu_op[31:12], 12'b0};
        end

        7'b0010111: begin // AUIPC
            w_mem = 1'b1;
            result = pc + {alu_op[31:12], 12'b0}; 
        end


        7'b0010011: begin 
            w_mem = 1'b1;
            inplace = alu_op[31:20];
            case (alu_op[14:12])
                3'b000: begin // Addi
                    result = data1 + inplace; // As specified - no arithmetic overflow protection
                end
                3'b010: begin // SLTI
                    result = (data1 < inplace) ? 1 : 0;
                end
                3'b011: begin // SLTIU
                    result = ($unsigned(data1) < $unsigned(inplace)) ? 1 : 0; // does this work? - verify
                end
                3'b100: begin // XORI
                    result = data1 ^ inplace; // Sign extension should be automatic?
                end
                3'b110: begin // ORI
                    result = data1 | inplace;
                end
                3'b111: begin // ANDI
                    result = data1 & inplace;
                end
                3'b001: begin // SLLI - does not verify that 31:25 are 0000000, just ignores them
                    result = data1 << inplace[4:0];
                end
                3'b101: begin 
                    case (alu_op[31:25])
                        7'b0000000: result = data1 >>inplace[4:0]; // SRLI
                        7'b0100000: result = $signed(data1) >>> inplace[4:0]; // SRAI
                        default: result = {INSTR_LENGTH{1'b0}}; // invalid instruction
                    endcase
                end
                default: err[0] = 1'b1 ; // Invalid instruction
             endcase
        end


        7'b1100011: begin // Branch instructions
            jump_offset = { {20{alu_op[31]}}, alu_op[7], alu_op[30:25], alu_op[11:8], 1'b0} - 4; // - 4*PIPELINE_STAGES // not needed due to stall logic
            case (alu_op[14:12])
                3'b000: begin // BEQ
                    pc_jump = (data1 == data2) ? 1'b1 : 1'b0;
                end
                3'b001: begin // BNE
                    pc_jump = (data1 != data2) ? 1'b1 : 1'b0;
                end
                3'b100: begin // BLT
                    pc_jump = (data1 < data2) ? 1'b1 : 1'b0;
                end
                3'b101: begin // BGE
                    pc_jump = (data1 > data2) ? 1'b1 : 1'b0;
                end
                3'b110: begin // BLTU
                    pc_jump = ($unsigned(data1) < $unsigned(data2)) ? 1'b1 : 1'b0;
                end
                3'b111: begin // BGEU
                    pc_jump = ($unsigned(data1) > $unsigned(data2)) ? 1'b1 : 1'b0;
                    
                end
                default: err[0] = 1'b1; // Invalid instruction
            endcase
        end
        7'b1101111: begin // JAL
            pc_jump = 1'b1;
            w_mem = 1'b1;
            result = pc + 4; // Store return address in rd. +4 will depend on pipelining
            jump_offset = { {12{alu_op[31]}}, alu_op[19:12], alu_op[20], alu_op[30:21], 1'b0 } - 4; // *PIPELINE_STAGES to account for pipelining
        end

        7'b1100111: begin // JALR
            pc_jump = 1'b1;
            w_mem = 1'b1;
            not_relative_pc = 1'b1;
            result = pc + 4; // Store return address in rd. +4 will depend on pipelining
            inplace = alu_op[31:20];
            jump_offset = (data1 + inplace) & ~1; // LSB is always zero
        end

        7'b0001111: begin // FENCE AND PAUSE
            err[1] = 1'b0; //Not implemented
        end
        7'b1110011: begin // ECALL and EBREAK
            err[1] = 1'b0; //Not implemented
        end

        default: ; // Do nothing, either a memory instruction or an invalid instruction
        endcase
    end

    
endmodule