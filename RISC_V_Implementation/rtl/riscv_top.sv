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
    output logic [CPU_WIDTH-1:0]  prog_cnt_wire,
    output logic [CPU_WIDTH-1:0]  out_instr,
    output logic [CPU_WIDTH-1:0]  read1_out,
    output logic [CPU_WIDTH-1:0]  read2_out,
    output logic [CPU_WIDTH-1:0]  cur_result,
    output logic                  mem_enable_alu_out,
    output logic [4:0]            write_address,
    output logic [4:0]            read1_address,
    output logic [CPU_WIDTH-1:0]  jump_debug,
    output logic                  je_debug
);

    logic [31:0] prog_point;
    logic [CPU_WIDTH-1:0] curr_instr;
    logic [CPU_WIDTH-1:0] read1;
    logic [CPU_WIDTH-1:0] read2;

   
    logic [CPU_WIDTH-1:0] alu_result;

    // Pipeline registers for instruction to alu and dmem
    logic [CPU_WIDTH-1:0] alu_op;
    logic [CPU_WIDTH-1:0] dmem_instr; 

    // Pipeline registers for pc
    logic [CPU_WIDTH-1:0] prog_point1;
    logic [CPU_WIDTH-1:0] prog_point2;
    logic [CPU_WIDTH-1:0] pc_alu;
    // Pipeline registers for rf outputs
    logic [CPU_WIDTH-1:0] read1_alu;
    logic [CPU_WIDTH-1:0] read2_alu;

    logic [CPU_WIDTH-1:0] mem_read; // Read from dmem

    // Signals for writing to rf
    logic mem_enable_alu;
    logic mem_enable_dmem;

    logic jump;
    logic pc_not_relative;
    logic [CPU_WIDTH-1:0] jump_address;

    program_counter pc(
        .clk(clk),
        .rst(rst),
        .not_relative_pc(pc_not_relative),
        .jump(jump),
        .jump_address(jump_address),
        .output_pc(prog_point)
    );

   imem32 imem(
       .clk(clk),
       .rst(rst),
       .addr(prog_point[6:2]), // word aligned
       .instr(curr_instr)
   );


   register_file rfile(
       .clk(clk),
       .rst(rst),
       .we(mem_enable_alu | mem_enable_dmem),
       .raddr1(curr_instr[19:15]),
       .raddr2(curr_instr[24:20]),
       .waddr(alu_op[11:7]),
       .rdata1(read1),
       .rdata2(read2),
       .wdata(mem_enable_dmem ? mem_read : alu_result)
   );


    // Pipeline register for Alu / dmem
   always_ff @(posedge clk) begin
       if (rst) begin
            alu_op <= 32'h00000013;
            dmem_instr <= 32'h00000013;
            prog_point1 <= 32'h00000000;
            prog_point2 <= 32'h00000000;
            pc_alu <= 32'h00000000;
            read1_alu <= 32'h00000000;
            read2_alu <= 32'h00000000;

       end else begin
            alu_op <= dmem_instr; 
            dmem_instr <= curr_instr;
            prog_point1 <= prog_point;
            prog_point2 <= prog_point1;
            pc_alu <= prog_point2;
            read1_alu <= read1;
            read2_alu <= read2;
       end
   end

    logic mem_alignment_err;
   dmem dmem(
       .clk(clk),
       .en(1'b1), // Always enabled for now

       .instr(dmem_instr), 
       .addr(read1),
       .di(read2),
       .dmem_select(mem_enable_dmem),
       .dout(mem_read), // muxed to rd
       .err(mem_alignment_err) 
   );


    logic invalid_instruction;
   alu_r32 main_alu( // It should be investigated to move the pipeline stage into the ALU.
        .clk(clk),
        .rst(rst),
        .data1(read1_alu),
        .data2(read2_alu),
        .alu_op(alu_op),
        .pc(pc_alu),

        .pc_jump(jump),
        .not_relative_pc(pc_not_relative),
        .jump_offset(jump_address),

        .w_mem(mem_enable_alu),
        .result(alu_result),
        
        .err(invalid_instruction)
   );

    // Limited error register for now
    logic csr_data [1:0];
    always_ff @(posedge clk) begin : Limited_ERROR_REGISTER
        if (rst) begin
            csr_data[0] <= 1'b0; 
            csr_data[1] <= 1'b0;
        end else begin
            if (mem_alignment_err) begin
                csr_data[0] <= 1'b1; 
            end
            if (invalid_instruction) begin
                csr_data[1] <= 1'b1; 
            end
        end
    end


   // Signals for debugging
    assign cur_result = alu_result;
    assign mem_enable_alu_out = mem_enable_alu;
    assign write_address = alu_op[11:7];
    assign read1_address = curr_instr[19:15];
    assign read1_out = read1;
    assign read2_out = read2;
    assign out_instr = curr_instr;
    assign prog_cnt_wire[31:0] = prog_point;
    assign jump_debug = jump_address;
    assign je_debug = jump;
    //assign prog_cnt_wire[CPU_WIDTH-1:16] = 0;



endmodule
