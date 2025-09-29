// Block RAM with Resettable Data Output
// File: rams_sp_rf_rst.v
// From https://docs.amd.com/r/en-US/ug901-vivado-synthesis/RAM-HDL-Coding-Guidelines

module dmem #(
    parameter MEM_SIZE = 4096 // size in bytes (must be multiple of 4)
)(
    input  logic clk,
    input  logic en,

    input  logic [31:0] instr,
    input  logic [31:0] addr, // should be connected to rs1
    input  logic [31:0] di, // should be connected to rs2
    output logic [31:0] dout, // should be muxed to rd
    output logic dmem_select,
    output logic err
);
// Memory always returns values with leading 0s for reads smaller than a word

logic [7:0] ram [MEM_SIZE-1:0];
logic [1:0]  size; //  00 = byte, 01 = halfword, 11 = word

logic [6:0] opcode;
logic [2:0] mselect;
logic       siextend;
logic       we; 
logic       dmem_select_next;
logic       dmem_select_reg;
assign dmem_select = dmem_select_reg;
logic       err_next;
logic       err_reg;
assign err = err_reg;


always_comb begin : Decode_instruction
    opcode = instr[6:0];
    mselect = instr[14:12];
    dmem_select_next = 1'b0;
    we = 1'b0;

    case (opcode)
        7'b0000011: begin // Load instructions
            case (mselect)
                3'b000: begin // LB
                    size = 2'b00;
                    siextend = 1'b1;
                end
                3'b001: begin // LH
                    size = 2'b01;
                    siextend = 1'b1;
                end
                3'b010: begin // LW
                    size = 2'b11;
                    siextend = 1'b0;
                end
                3'b100: begin // LBU
                    size = 2'b00;
                    siextend = 1'b0;
                end
                3'b101: begin // LHU
                    size = 2'b01;
                    siextend = 1'b0;
                end
                default: begin
                    size = 2'b11; // Defined to avoid latches
                    siextend = 1'b0;
                end
            endcase
        end
        7'b0100011: begin // Store instructions
            siextend = 1'b0; // Not used for stores
            dmem_select_next = 1'b1;
            we = 1'b1;
            case (mselect)
                3'b000: size = 2'b00; // SB
                3'b001: size = 2'b01; // SH
                3'b010: size = 2'b11; // SW
                default: begin
                    size = 2'b11;
                    we = 1'b0; // Disable write on undefined
                end
            endcase
        end
        default: begin
            we = 1'b0;
            size = 2'b11;
            siextend = 1'b0;
        end
    endcase
end



// Does not support unaligned accesses
always_comb begin : Alignment_check
    case (size)
        2'b00: err_next = 1'b0; //byte
        2'b01: err_next = addr[0]; //halfword
        2'b11: err_next = |addr[1:0]; //word
        default: err_next = 1'b1; //undefined
    endcase
end
// Should an exeption be raised for out of bounds access?
// When should the exceptions be raised? Pipelining


always @(posedge clk)
begin
    if (en) //optional enable
    begin
        // Control signals to be passed on
        dmem_select_reg <= dmem_select_next;
        err_reg <= err_next;

        // Memory:
        if (we) //write enable
        begin
            case (size)
                2'b00: //byte
                    ram[addr] <= di[7:0];
                2'b01: //halfword
                    {ram[addr+1], ram[addr]} <= di[15:0];
                2'b11: //word
                    {ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]} <= di;
                default: ; //undefined
            endcase
        end
        //read operation
        case (size)
            2'b00: //byte
                dout <= {{24{siextend & ram[addr][7]}}, ram[addr]};
            2'b01: //halfword
                dout <= {{16{siextend & ram[addr][7]}}, ram[addr+1], ram[addr]};
            2'b11: //word
                dout <= {ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]};
            default: dout <= 32'b0; //undefined
        endcase
    end
end

endmodule