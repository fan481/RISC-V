`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 11:17:54 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] op1, //operand always from registers
    input [31:0] op2, //operand from registers or immediate
    input [3:0] alu_opcode,
    output logic [31:0] alu_out
    );
    
    always_comb begin
        case (alu_opcode) //note: needs error check
            4'b0000: alu_out = op1 + op2;
            4'b0001: alu_out = op1 - op2;
            4'b0010: alu_out = op1 & op2;
            4'b0011: alu_out = op1 | op2;
            4'b0100: alu_out = op1 ^ op2;
            4'b0101: alu_out = op1 << op2[4:0];
            4'b0110: alu_out = op1 >> op2[4:0];
            4'b0111: alu_out = $signed(op1) >>> op2[4:0];
            4'b1000: alu_out = ($signed(op1) < $signed(op2)) ? 1 : 0;
            4'b1001: alu_out = (op1 < op2) ? 1 : 0;
            4'b1010: alu_out = op2;
            4'b1011: alu_out = op1;
            4'b1100: alu_out = ~(op1 | op2);
            4'b1101: alu_out = ~(op1 & op2);
            4'b1110: alu_out = ~(op1 ^ op2);
            4'b1111: alu_out = 32'b0;
        endcase
    end
    
endmodule
