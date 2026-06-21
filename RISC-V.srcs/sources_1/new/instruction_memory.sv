`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 11:44:20 AM
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(
    input [31:0] pc_addr,
    output [31:0] instr,
    output instr_valid
    );

    reg [31:0] pc_data [255:0];

    assign instr_valid = 1; //note: unused for single-cycle
    assign instr = pc_data[pc_addr >> 2]; //note: imem maintains word-addressing internally for convenience

endmodule
