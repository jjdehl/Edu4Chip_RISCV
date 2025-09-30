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
    parameter MEM_DEPTH = 128;
    parameter ADDR_WIDTH = 7;

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

        // // Example instructions, can be modified as needed
        // // Load immediate values into registers x1 and x2
        // instr_reg[0] = 32'h00000113; // ADDI x3, x0, 0 (initialize x3 to 0)
        // instr_reg[1] = 32'h00100213; // ADDI x4, x0, 1 (load 1 into x4)
        // instr_reg[2] = 32'h00200293; // ADDI x5, x0, 2 (load 2 into x5)

        // // Add the values in x4 and x5, store result in x3
        // instr_reg[3] = 32'h00000013; // STALL (but not the correct one)
        
        // instr_reg[5] = 32'h005201B3; // ADD x3, x4, x5

        // // Add x3 and x4, store result in x5
        // instr_reg[6] = 32'h00000013; // STALL (but not the correct one)
        // instr_reg[8] = 32'h004182B3; // ADD x5, x3, x4

        // //instr_reg[10]  = 32'h02800167; //32'h028001EF; // This is JALR to 0x0028
        // instr_reg[10] = 32'hFF9FF06F;//hFE2FF0EF;

        // // End of program marker (NOP instruction)
        // //instr_reg[6] = 32'h00000013; // NOP - same as default at reset


// Working example with adding two numbers:
        // instr_reg[0] = 32'hfe010113;
        // instr_reg[1] = 32'h00112e23;
        // instr_reg[2] = 32'h00812c23;
        // instr_reg[3] = 32'h02010413;
        // instr_reg[4] = 32'h00500793;
        // instr_reg[5] = 32'hfef42623;
        // instr_reg[6] = 32'h00a00793;
        // instr_reg[7] = 32'hfef42423;
        // instr_reg[8] = 32'hfec42703;
        // instr_reg[9] = 32'hfe842783;
        // instr_reg[10] = 32'h00f707b3;
        // instr_reg[11] = 32'hfef42223;
        // instr_reg[12] = 32'h00000793;
        // instr_reg[13] = 32'h00078513;
        // instr_reg[14] = 32'h01c12083;
        // instr_reg[15] = 32'h01812403;
        // instr_reg[16] = 32'h02010113;
        // instr_reg[17] = 32'h00008067;


// GCD + 1 of 1000 and 250, main at 0x70
        // instr_reg[0] = 32'hfe010113;
        // instr_reg[1] = 32'h00112e23;
        // instr_reg[2] = 32'h00812c23;
        // instr_reg[3] = 32'h02010413;
        // instr_reg[4] = 32'hfea42623;
        // instr_reg[5] = 32'hfeb42423;
        // instr_reg[6] = 32'h0340006f;
        // instr_reg[7] = 32'hfec42703;
        // instr_reg[8] = 32'hfe842783;
        // instr_reg[9] = 32'h00e7dc63;
        // instr_reg[10] = 32'hfec42703;
        // instr_reg[11] = 32'hfe842783;
        // instr_reg[12] = 32'h40f707b3;
        // instr_reg[13] = 32'hfef42623;
        // instr_reg[14] = 32'h0140006f;
        // instr_reg[15] = 32'hfe842703;
        // instr_reg[16] = 32'hfec42783;
        // instr_reg[17] = 32'h40f707b3;
        // instr_reg[18] = 32'hfef42423;
        // instr_reg[19] = 32'hfec42703;
        // instr_reg[20] = 32'hfe842783;
        // instr_reg[21] = 32'hfcf714e3;
        // instr_reg[22] = 32'hfec42783;
        // instr_reg[23] = 32'h00078513;
        // instr_reg[24] = 32'h01c12083;
        // instr_reg[25] = 32'h01812403;
        // instr_reg[26] = 32'h02010113;
        // instr_reg[27] = 32'h00008067;
        // instr_reg[28] = 32'hfe010113;
        // instr_reg[29] = 32'h00112e23;
        // instr_reg[30] = 32'h00812c23;
        // instr_reg[31] = 32'h02010413;
        // instr_reg[32] = 32'h3e800793;
        // instr_reg[33] = 32'hfef42623;
        // instr_reg[34] = 32'h0fa00793;
        // instr_reg[35] = 32'hfef42423;
        // instr_reg[36] = 32'hfec42783;
        // instr_reg[37] = 32'h0007d863;
        // instr_reg[38] = 32'hfec42783;
        // instr_reg[39] = 32'h40f007b3;
        // instr_reg[40] = 32'hfef42623;
        // instr_reg[41] = 32'hfe842783;
        // instr_reg[42] = 32'h0007d863;
        // instr_reg[43] = 32'hfe842783;
        // instr_reg[44] = 32'h40f007b3;
        // instr_reg[45] = 32'hfef42423;
        // instr_reg[46] = 32'hfe842583;
        // instr_reg[47] = 32'hfec42503;
        // instr_reg[48] = 32'hf41ff0ef;
        // instr_reg[49] = 32'hfea42223;
        // instr_reg[50] = 32'hfe442783;
        // instr_reg[51] = 32'h00178793;
        // instr_reg[52] = 32'hfef42223;
        // instr_reg[53] = 32'h00000793;
        // instr_reg[54] = 32'h00078513;
        // instr_reg[55] = 32'h01c12083;
        // instr_reg[56] = 32'h01812403;
        // instr_reg[57] = 32'h02010113;
        // instr_reg[58] = 32'h00008067;

// GCD of 2520 and 1980 main at 0x70 (result in 180 or 0xb4 +1 ) Appears to be broken.,...
        // instr_reg[0] = 32'hfe010113;
        // instr_reg[1] = 32'h00112e23;
        // instr_reg[2] = 32'h00812c23;
        // instr_reg[3] = 32'h02010413;
        // instr_reg[4] = 32'hfea42623;
        // instr_reg[5] = 32'hfeb42423;
        // instr_reg[6] = 32'h0340006f;
        // instr_reg[7] = 32'hfec42703;
        // instr_reg[8] = 32'hfe842783;
        // instr_reg[9] = 32'h00e7dc63;
        // instr_reg[10] = 32'hfec42703;
        // instr_reg[11] = 32'hfe842783;
        // instr_reg[12] = 32'h40f707b3;
        // instr_reg[13] = 32'hfef42623;
        // instr_reg[14] = 32'h0140006f;
        // instr_reg[15] = 32'hfe842703;
        // instr_reg[16] = 32'hfec42783;
        // instr_reg[17] = 32'h40f707b3;
        // instr_reg[18] = 32'hfef42423;
        // instr_reg[19] = 32'hfec42703;
        // instr_reg[20] = 32'hfe842783;
        // instr_reg[21] = 32'hfcf714e3;
        // instr_reg[22] = 32'hfec42783;
        // instr_reg[23] = 32'h00078513;
        // instr_reg[24] = 32'h01c12083;
        // instr_reg[25] = 32'h01812403;
        // instr_reg[26] = 32'h02010113;
        // instr_reg[27] = 32'h00008067;
        // instr_reg[28] = 32'hfe010113;
        // instr_reg[29] = 32'h00112e23;
        // instr_reg[30] = 32'h00812c23;
        // instr_reg[31] = 32'h02010413;
        // instr_reg[32] = 32'h000017b7;
        // instr_reg[33] = 32'h9d878793;
        // instr_reg[34] = 32'hfef42623;
        // instr_reg[35] = 32'h7bc00793;
        // instr_reg[36] = 32'hfef42423;
        // instr_reg[37] = 32'hfec42783;
        // instr_reg[38] = 32'h0007d863;
        // instr_reg[39] = 32'hfec42783;
        // instr_reg[40] = 32'h40f007b3;
        // instr_reg[41] = 32'hfef42623;
        // instr_reg[42] = 32'hfe842783;
        // instr_reg[43] = 32'h0007d863;
        // instr_reg[44] = 32'hfe842783;
        // instr_reg[45] = 32'h40f007b3;
        // instr_reg[46] = 32'hfef42423;
        // instr_reg[47] = 32'hfe842583;
        // instr_reg[48] = 32'hfec42503;
        // instr_reg[49] = 32'hf3dff0ef;
        // instr_reg[50] = 32'hfea42223;
        // instr_reg[51] = 32'hfe442783;
        // instr_reg[52] = 32'h00178793;
        // instr_reg[53] = 32'hfef42223;
        // instr_reg[54] = 32'h00000793;
        // instr_reg[55] = 32'h00078513;
        // instr_reg[56] = 32'h01c12083;
        // instr_reg[57] = 32'h01812403;
        // instr_reg[58] = 32'h02010113;
        // instr_reg[59] = 32'h00008067;
        // instr_reg[60] = 32'h00000013; // NOP

// GCD of 1980 and 486 - should be 18 +1 or 0x12 + 1
        instr_reg[0] = 32'hfe010113;
        instr_reg[1] = 32'h00112e23;
        instr_reg[2] = 32'h00812c23;
        instr_reg[3] = 32'h02010413;
        instr_reg[4] = 32'hfea42623;
        instr_reg[5] = 32'hfeb42423;
        instr_reg[6] = 32'h0340006f;
        instr_reg[7] = 32'hfec42703;
        instr_reg[8] = 32'hfe842783;
        instr_reg[9] = 32'h00e7dc63;
        instr_reg[10] = 32'hfec42703;
        instr_reg[11] = 32'hfe842783;
        instr_reg[12] = 32'h40f707b3;
        instr_reg[13] = 32'hfef42623;
        instr_reg[14] = 32'h0140006f;
        instr_reg[15] = 32'hfe842703;
        instr_reg[16] = 32'hfec42783;
        instr_reg[17] = 32'h40f707b3;
        instr_reg[18] = 32'hfef42423;
        instr_reg[19] = 32'hfec42703;
        instr_reg[20] = 32'hfe842783;
        instr_reg[21] = 32'hfcf714e3;
        instr_reg[22] = 32'hfec42783;
        instr_reg[23] = 32'h00078513;
        instr_reg[24] = 32'h01c12083;
        instr_reg[25] = 32'h01812403;
        instr_reg[26] = 32'h02010113;
        instr_reg[27] = 32'h00008067;
        instr_reg[28] = 32'hfe010113;
        instr_reg[29] = 32'h00112e23;
        instr_reg[30] = 32'h00812c23;
        instr_reg[31] = 32'h02010413;
        instr_reg[32] = 32'h1e600793;
        instr_reg[33] = 32'hfef42623;
        instr_reg[34] = 32'h7bc00793;
        instr_reg[35] = 32'hfef42423;
        instr_reg[36] = 32'hfec42783;
        instr_reg[37] = 32'h0007d863;
        instr_reg[38] = 32'hfec42783;
        instr_reg[39] = 32'h40f007b3;
        instr_reg[40] = 32'hfef42623;
        instr_reg[41] = 32'hfe842783;
        instr_reg[42] = 32'h0007d863;
        instr_reg[43] = 32'hfe842783;
        instr_reg[44] = 32'h40f007b3;
        instr_reg[45] = 32'hfef42423;
        instr_reg[46] = 32'hfe842583;
        instr_reg[47] = 32'hfec42503;
        instr_reg[48] = 32'hf41ff0ef;
        instr_reg[49] = 32'hfea42223;
        instr_reg[50] = 32'hfe442783;
        instr_reg[51] = 32'h00178793;
        instr_reg[52] = 32'hfef42223;
        instr_reg[53] = 32'h00000793;
        instr_reg[54] = 32'h00078513;
        instr_reg[55] = 32'h01c12083;
        instr_reg[56] = 32'h01812403;
        instr_reg[57] = 32'h02010113;
        instr_reg[58] = 32'h00008067;


    end
endmodule

