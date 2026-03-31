`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 11:39:39 AM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input reset, //for initializing pc_addr_reg
    input [1:0] jb, //00 not j/b, 01 jump, 10 jump register, 11 branch
    input [31:0] alu_out, //should either be register data for jump register (pass-thru ALU), or used as bool flag to indicate branch on beq/bne/blt/...
    input [31:0] imm, //used for j/b offset
    output [31:0] pc_addr
    );
    
    reg [31:0] pc_addr_reg;
    assign pc_addr = pc_addr_reg;
    always_comb begin //todo: consider refactoring reset logic
        if (reset) pc_addr_reg = 0; //don't think blocking/nonblocking matters in this module?
        else
        case (jb)
            2'b00: begin //not jump or branch
                pc_addr_reg = pc_addr_reg + 4;
            end
            2'b01: begin //jump
                pc_addr_reg = pc_addr_reg + imm;
            end
            2'b10: begin //jump register 
                pc_addr_reg = alu_out; //register bits pass-thru ALU
            end
            2'b11: begin //branch //note: is it bad architecture for conditional logic to be driven by both ALU and decoder outputs? future pipeline considerations?
                if (alu_out[0]) pc_addr_reg = pc_addr_reg + imm; //ALU output should be either 32'd0 or 32'd1 for branch instruction
                else pc_addr_reg = pc_addr_reg + 4;
            end
        endcase
    end
    
endmodule
