`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 02:42:19 PM
// Design Name: 
// Module Name: test_system
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


module test_system(
        input clk,
        input reset
    );

    wire trap; //todo: consider renaming _cpuout and/or these wire declarations
    wire [31:0] memr_data;
    wire memr_valid;
    wire [31:0] memr_addr;
    wire memw_valid;
    wire [1:0] memw_size;
    wire [31:0] memw_addr;
    wire [31:0] memw_data;

    RV32_CPU cpu_inst (
        //inputs
        .clk(clk),
        .reset(reset),
        .memr_data(memr_data),
        .memr_valid(memr_valid),
        //outputs
        .memr_addr_cpuout(memr_addr),
        .memw_valid_cpuout(memw_valid),
        .memw_size_cpuout(memw_size),
        .memw_addr_cpuout(memw_addr),
        .memw_data_cpuout(memw_data),
        .trap_cpuout(trap)
    );
    stack stack_inst (
        //inputs
        .clk(clk),
        .memr_addr(memr_addr),
        .memw_valid(memw_valid),
        .memw_size(memw_size),
        .memw_addr(memw_addr),
        .memw_data(memw_data),
        //outputs
        .memr_data(memr_data),
        .memr_valid(memr_valid)
    );

endmodule
