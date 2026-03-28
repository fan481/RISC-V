`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2026 10:57:21 AM
// Design Name: 
// Module Name: rv32_decoder
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


module rv32_decoder(
    input [31:0] imem,
    input decoder_en,
    input [31:0] mem_rdata,
    output [14:0] decoded_sig,
    output [3:0] decoded_inst_ALU
    );
endmodule
