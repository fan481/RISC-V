`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 01:30:55 PM
// Design Name: 
// Module Name: ALU_mux
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


module ALU_mux(
    input [31:0] rs2,
    input [31:0] imm,
    input alu_sel,
    output logic [31:0] op2
    );
    always_comb begin
        if (alu_sel) op2 = imm;
        else op2 = rs2;
    end
endmodule
