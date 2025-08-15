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

parameter CPU_WIDTH = 32;
// parameter INSTRUCTION_MEM_DEPTH = 10;


module riscv_top(
   input            clk,
   input            rst,
   input [CPU_WIDTH-1:0]     instr,
   input            sel,
   output [CPU_WIDTH-1:0]    test
   );
   wire [CPU_WIDTH-1:0] t_output = sel ? instr : {CPU_WIDTH{1'b0}};


   assign test = t_output;
   

   // Makes no sense, just a register example.
   reg [CPU_WIDTH-1:0] instruction_mem;
   always @(posedge clk) begin
       if (rst) begin
           instruction_mem <= {CPU_WIDTH{1'b0}};
       end else begin
           instruction_mem <= instr;
       end
   end

endmodule
