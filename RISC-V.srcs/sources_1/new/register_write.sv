`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 01:57:50 PM
// Design Name: 
// Module Name: register_write
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


module register_write(
    input mem_ready,
    input [31:0] mem_rdata,
    input load_signed,
    input [14:0] decoded_sig,
    input [31:0] alu_out,
    input [3:0] mem_strb,
    output [31:0] reg_sel_write,
    output [31:0] regw_data
    );
endmodule
