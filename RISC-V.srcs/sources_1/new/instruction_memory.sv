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
        pc_data[0] = 32'h00100293; //addi x5, x0, 1
        pc_data[1] = 32'h00001337; //lui x6, 1 
        pc_data[2] = 32'h008000ef; //jal x1, 8 //skip below
        pc_data[3] = 32'b1111111; //invalid instruction (flag trap)
        pc_data[4] = 32'h018000e7; //jalr x1, 24(x0) //skip below
        pc_data[5] = 32'b1111111; //invalid instruction (flag trap)
        pc_data[6] = 32'h00629463; //bne x5, x6, 8 //skip below
        pc_data[7] = 32'b1111111; //invalid instruction (flag trap)
        pc_data[8] = 32'h00512023; //sw x5, 0(x2) //x2 is $sp, init to top of stack
        pc_data[9] = 32'h00012383; //lw x7, 0(x2)
        pc_data[10] = 32'h00628433; //add x8, x5, x6
    end

endmodule
