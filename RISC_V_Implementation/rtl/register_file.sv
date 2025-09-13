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

    parameter RF_MEM_WIDTH = 32;
    parameter RF_MEM_DEPTH = 32;
    parameter RF_ADDR_WIDTH = 5;

module register_file(
    input  logic clk,
    input  logic rst,
    input  logic we,
    input  logic [RF_ADDR_WIDTH-1:0] raddr1,
    input  logic [RF_ADDR_WIDTH-1:0] raddr2,
    input  logic [RF_ADDR_WIDTH-1:0] waddr,

    output logic [RF_MEM_WIDTH-1:0] rdata1,
    output logic [RF_MEM_WIDTH-1:0] rdata2,
    input  logic [RF_MEM_WIDTH-1:0] wdata
    );
    integer i;

    logic [RF_MEM_WIDTH-1:0] data_reg[RF_MEM_DEPTH];

    assign rdata1 = data_reg[raddr1];
    assign rdata2 = data_reg[raddr2];


    always_ff @(posedge clk) begin
         if (rst) begin
            //for (i = 0; i < RF_MEM_DEPTH; i + 1) begin
            //     data_reg[i] <= {RF_MEM_WIDTH{1'b0}};
            // end
        end
        else if (we) begin
            if (waddr) begin // Makes sure that address 0 is always 0
                data_reg[waddr] <= wdata;
            end
        end
    end

endmodule