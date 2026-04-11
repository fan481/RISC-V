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


module instruction_memory( //todo: change reg to logic in all modules
    input [31:0] pc_addr,
    output [31:0] instr,
    output instr_valid
    );

    reg [31:0] pc_data [255:0];

    assign instr_valid = 1; //todo: unused for single-cycle
    assign instr = pc_data[pc_addr >> 2]; //note: imem maintains word-addressing internally for convenience

    /* simulation/testing */ //todo: refactor pc data loading
    initial begin
        pc_data[0] = 32'h00100293;
        pc_data[1] = 32'h00100313;
        pc_data[2] = 32'h00100393;
        pc_data[3] = 32'h00100413;
        pc_data[4] = 32'h00100493;
    end

endmodule
