`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2026 07:51:24 PM
// Design Name: 
// Module Name: testbench_
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


module testbench_;

    logic clk;
    logic reset;

    wire trap;
    wire [31:0] memr_data;
    wire memr_valid;
    wire [31:0] memr_addr;
    wire memw_valid;
    wire [1:0] memw_size;
    wire [31:0] memw_addr;
    wire [31:0] memw_data;

    RV32_CPU cpu_inst (
        // inputs
        .clk(clk),
        .reset(reset),
        .memr_data(memr_data),
        .memr_valid(memr_valid),
        // outputs
        .memr_addr_cpuout(memr_addr),
        .memw_valid_cpuout(memw_valid),
        .memw_size_cpuout(memw_size),
        .memw_addr_cpuout(memw_addr),
        .memw_data_cpuout(memw_data),
        .trap_cpuout(trap)
    );

    stack stack_inst (
        // inputs
        .clk(clk),
        .memr_addr(memr_addr),
        .memw_valid(memw_valid),
        .memw_size(memw_size),
        .memw_addr(memw_addr),
        .memw_data(memw_data),
        // outputs
        .memr_data(memr_data),
        .memr_valid(memr_valid)
    );
    
    //load instructions
    reg [31:0] tb_instructions [0:255];
    initial begin
        $readmemh("tb_instructions.mem", tb_instructions);
        for (int i = 0; i < 256; i++) begin
          cpu_inst.imem_inst.pc_data[i] = tb_instructions[i];
        end
    end
    //clk and reset
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        #20 reset = 0;
    end
    


endmodule
