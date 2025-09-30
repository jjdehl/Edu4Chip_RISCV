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
  logic clk;
  logic reset;
  logic [31:0] instr;
  logic [31:0] read1;
  logic [31:0] read2;
  logic [31:0] counter;
  logic [31:0] alu_result;
  logic mem_enable_alu;
  logic mem_enable_dmem;
  logic [4:0] write_address;
  logic [4:0] read1_address;
  logic [31:0] jump_debug;
  logic je_debug;
  logic [1:0] csr_debug;
  logic [31:0] dmem_data_out;
  logic hz;
  logic hz_is_branch;
  logic [31:0] f_addr;

  riscv_top dut (
      .clk(clk),
      .rst(reset),

      .prog_cnt_wire(counter),
      .out_instr(instr),
      .read1_out(read1),
      .read2_out(read2),
      .cur_result(alu_result),
      .mem_enable_alu_out(mem_enable_alu),
      .write_address(write_address),
      .read1_address(read1_address),
      .jump_debug(jump_debug),
      .je_debug(je_debug),
      .csr_debug(csr_debug),
      .dmem_data_out(dmem_data_out),
      .mem_enable_dmem_out(mem_enable_dmem),
      .hz_out(hz),
      .hz_is_branch(hz_is_branch),
      .f_addr_o(f_addr)

  );
  // clock
    initial begin
      clk = 1'b0;
      forever #1 clk = ~clk;
    end

   initial begin
      reset = 1'b1;
      #5 reset = 1'b0;
      
   end

  // reg clk;
  // reg reset;
  // reg sel;
  // reg [31:0] instr;
    // wire [31:0] test;
    
    // riscv_top dut (
    // .clk (clk),
    // .rst (reset),
    // .sel (sel),
    // .instr (instr),
    // .test (test)
    // );
    // // clock
    // initial begin
    //   clk = 1'b0;
    //   forever #1 clk = ~clk;
    // end
    
    // // test stim
    // initial begin
    // sel = 1'b0;
    // instr = 32'b1;
    // #20
    // sel = 1'b1;
    // instr = 32'b1;
    // #20
    // sel = 1'b1;
    // instr = 32'b1010101010101010;
    // #20 
    // sel = 1'b0;
    // end
    
endmodule
