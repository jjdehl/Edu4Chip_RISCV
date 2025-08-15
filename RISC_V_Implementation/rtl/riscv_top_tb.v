`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 10:25:30 AM
// Design Name: 
// Module Name: riscv_top_tb
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


module riscv_top_tb(
    );
    reg clk;
    reg reset;
    reg sel;
    reg [31:0] instr;
    wire [31:0] test;
    
    riscv_top dut (
    .clk (clk),
    .rst (reset),
    .sel (sel),
    .instr (instr),
    .test (test)
    );
    // clock
    initial begin
      clk = 1'b0;
      forever #1 clk = ~clk;
    end
    
    // test stim
    initial begin
    sel = 1'b0;
    instr = 32'b1;
    #20
    sel = 1'b1;
    instr = 32'b1;
    #20
    sel = 1'b1;
    instr = 32'b1010101010101010;
    #20 
    sel = 1'b0;
    end
    
endmodule
