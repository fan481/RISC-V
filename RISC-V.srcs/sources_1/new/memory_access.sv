`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2026 03:52:16 PM
// Design Name: 
// Module Name: memory_access
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


module memory_access(
    input mem_valid,
    input [1:0] mem_size,
    input [31:0] alu_out,
    input [31:0] rs2,
    output memw_valid,
    output [1:0] memw_size,
    output [31:0] memw_addr,
    output [31:0] memw_data
    );

    assign memw_valid = mem_valid;
    assign memw_size = mem_size; //note: data output is always 32 bits and identical to what was in register, mem_size provides truncation info for memory module. May need to refactor depending on memory module spec
    assign memw_addr = alu_out;
    assign memw_data = rs2;

endmodule
