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
    input [2:0] pc_select, //000 not jump or branch, 001 jump, 010 jump register, 011 beq, 100 bne, 101 comparative branches 
    input [31:0] alu_out, //should either be register data for jump register (pass-thru ALU), or used as bool flag to indicate branch on beq/bne/blt/...
    input [31:0] imm, //used for j/b offset
    output logic [31:0] pc_addr,
    output [31:0] pc_incr //for storing return address
    );
    
    assign pc_incr = pc_addr + 4;
    always_ff @(posedge clk) begin
        if (reset) pc_addr <= 0;
        else begin
            case (pc_select)
                3'b000: begin //not jump or branch
                    pc_addr <= pc_incr;
                end
                3'b001: begin //jump
                    pc_addr <= pc_addr + imm;
                end
                3'b010: begin //jump register 
                    pc_addr <= alu_out; //ALU calculates register-stored address + imm //note: Not masking lower 2 bits because bad logic can silently continue execution. Sum needs to be 4-byte aligned or runtime will break.
                end
                3'b011: begin //beq
                    if (~|alu_out) pc_addr <= pc_addr + imm; //check if subtraction result == 0
                    else pc_addr <= pc_incr;
                end
                3'b100: begin //bne
                    if (|alu_out) pc_addr <= pc_addr + imm; //check if subtraction result != 0
                    else pc_addr <= pc_incr;
                end
                3'b101: begin //blt, bltu
                    if (alu_out[0]) pc_addr <= pc_addr + imm; //ALU output should be either 32'd0 or 32'd1 since ALU operation is comparison
                    else pc_addr <= pc_incr;
                end
                3'b110: begin //bge, bgeu
                    if (~alu_out[0]) pc_addr <= pc_addr + imm; //ALU output should be either 32'd0 or 32'd1 since ALU operation is comparison
                    else pc_addr <= pc_incr;
                end
                3'b111: begin
                    //todo: should never get to this state, flag trap
                    pc_addr <= pc_incr;
                end
            endcase
        end
    end
    
endmodule
