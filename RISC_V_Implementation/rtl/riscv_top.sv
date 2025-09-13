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


// parameter INSTRUCTION_MEM_DEPTH = 10;
parameter CPU_WIDTH = 32;

module riscv_top(
   input logic                   clk,
   input logic                   rst,
   input logic                   run,
   output logic [CPU_WIDTH-1:0]  prog_cnt_wire,
   output logic [CPU_WIDTH-1:0]  out_instr,
   output logic [CPU_WIDTH-1:0]  read1,
   output logic [CPU_WIDTH-1:0]  read2
   );

   logic [15:0] prog_point;
   logic [CPU_WIDTH-1:0] curr_instr;

   logic jump;
   logic [CPU_WIDTH-1:0] jump_address;

   program_counter pc(
       .clk(clk),
       .rst(rst),
       .run(run),
       .jump(1'b0),
       .jump_address(32'b0),
       .pc(prog_point)
   );

   imem32 imem(
       .clk(clk),
       .rst(rst),
       .addr(prog_point[4:0]),
       .instr(curr_instr)
   );


   assign out_instr = curr_instr;
   assign prog_cnt_wire[15:0] = prog_point;
   assign prog_cnt_wire[CPU_WIDTH-1:16] = 0;

   register_file rfile(
       .clk(clk),
       .rst(rst),
       .we(1'b0),
       .raddr1(curr_instr[19:15]),
       .raddr2(curr_instr[24:20]),
       .waddr(curr_instr[11:7]),
       .rdata1(read1),
       .rdata2(read2),
       .wdata(32'b0)
   );


   logic [CPU_WIDTH-1:0] alu_result;
   logic [CPU_WIDTH-1:0] alu_op;

   always_ff @(posedge clk) begin
       if (rst) begin
           alu_op <= 32'h00000013;
       end else begin
           // ALU operation
           alu_op <= curr_instr;
       end
   end

   alu_r32 main_alu(
       .clk(clk),
       .rst(rst),
       .data1(read1),
       .data2(read2),
       .alu_op(alu_op),
       .result(alu_result)
   );

   // Program counter logic:


endmodule
