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
    input clk,
    input reset, //for initializing pc_addr_reg
    input [1:0] pc_select, //00 not j/b, 01 jump, 10 jump register, 11 branch
    input [31:0] alu_out, //should either be register data for jump register (pass-thru ALU), or used as bool flag to indicate branch on beq/bne/blt/...
    input [31:0] imm, //used for j/b offset
    output logic [31:0] pc_addr,
    output [31:0] pc_incr
    );
    
    assign pc_incr = pc_addr + 4;
    always @(posedge clk) begin
        if (reset) pc_addr <= 0;
        else begin
            case (pc_select)
                2'b00: begin //not jump or branch
                    pc_addr <= pc_incr;
                end
                2'b01: begin //jump
                    pc_addr <= pc_addr + imm;
                end
                2'b10: begin //jump register 
                    pc_addr <= alu_out; //ALU calculates register-stored address + imm //note: Not masking lower 2 bits because bad logic can silently continue execution. Sum needs to be 4-byte aligned or runtime will break.
                end
                2'b11: begin //branch //note: is it bad architecture for conditional logic to be driven by both ALU and decoder outputs? future pipeline considerations?
                    if (alu_out[0]) pc_addr <= pc_addr + imm; //ALU output should be either 32'd0 or 32'd1 for branch instruction
                    else pc_addr <= pc_incr;
                end
            endcase
        end
    end
    
endmodule
