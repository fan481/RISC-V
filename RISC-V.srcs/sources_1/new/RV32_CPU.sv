`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2026 10:22:23 AM
// Design Name: 
// Module Name: RV32_CPU
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


module RV32_CPU(
    input clk,
    input reset,
    //input [31:0] imem, 
    //input instr_valid,
    input [31:0] memr_data,
    input memr_valid,
    output [31:0] memr_addr_cpuout,
    output memw_valid_cpuout,
    output [1:0] memw_size_cpuout,
    output [31:0] memw_addr_cpuout,
    output [31:0] memw_data_cpuout,
    output trap_cpuout
    );

    /* 
    module connection wires
    */
    /* imem */
    wire [31:0] instr;
    wire instr_valid;
    /* decoder */
    wire [14:0] decoded_sig;
    wire [2:0] pc_select;
    wire [3:0] alu_opcode; 
    wire alu_sel;
    wire [31:0] imm;
    wire mem_valid;
    wire [1:0] mem_size;
    wire load_unsigned; 
    wire [1:0] write_from;
    /* PC */
    wire [31:0] pc_addr;
    wire [31:0] pc_incr;
    /* memory_access */
    //wire memw_valid;
    //wire [1:0] memw_size;
    //wire [31:0] memw_addr;
    //wire [31:0] memw_data;
    /* ALU */
    wire [31:0] alu_out;
    /* ALU_mux */
    wire [31:0] op2;
    /* register_file */
    wire [31:0] rs1;
    wire [31:0] rs2;
    /* register_write */
    //wire [31:0] memr_addr;
    wire [31:0] reg_sel_write;
    wire [31:0] regw_data;

    instruction_memory imem_inst (
        //input
        .pc_addr(pc_addr),
        //outputs
        .instr(instr),
        .instr_valid(instr_valid)
    );
    rv32_decoder decoder_inst (
        //inputs
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .instr_valid(instr_valid),
        //outputs
        .decoded_sig(decoded_sig),
        .pc_select(pc_select),
        .alu_opcode(alu_opcode),
        .alu_sel(alu_sel),
        .imm(imm),
        .mem_valid(mem_valid),
        .mem_size(mem_size),
        .load_unsigned(load_unsigned),
        .write_from(write_from),
        .trap(trap_cpuout)
    );
    program_counter pc_inst (
        //inputs
        .clk(clk),
        .reset(reset),
        .pc_select(pc_select),
        .alu_out(alu_out),
        .imm(imm),
        //outputs
        .pc_addr(pc_addr),
        .pc_incr(pc_incr)
    );
    memory_access mem_access_inst (
        //inputs
        .mem_valid(mem_valid),
        .mem_size(mem_size),
        .alu_out(alu_out),
        .rs2(rs2),
        //outputs
        .memw_valid(memw_valid_cpuout),
        .memw_size(memw_size_cpuout),
        .memw_addr(memw_addr_cpuout),
        .memw_data(memw_data_cpuout)
    );
    ALU ALU_inst (
        //inputs
        .op1(rs1),
        .op2(op2),
        .alu_opcode(alu_opcode),
        //output
        .alu_out(alu_out)
    );
    ALU_mux ALU_mux_inst (
        //inputs
        .rs2(rs2),
        .imm(imm),
        .alu_sel(alu_sel),
        //output
        .op2(op2)
    );
    register_file register_file_inst (
        //inputs
        .clk(clk),
        .decoded_sig(decoded_sig),
        .reg_sel_write(reg_sel_write),
        .regw_data(regw_data),
        //outputs
        .rs1(rs1),
        .rs2(rs2)
    );
    register_write register_write_inst (
        //inputs
        .memr_valid(memr_valid),
        .memr_data(memr_data),
        .mem_size(mem_size),
        .load_unsigned(load_unsigned),
        .write_from(write_from),
        .decoded_sig(decoded_sig),
        .pc_incr(pc_incr),
        .alu_out(alu_out),
        //outputs
        .memr_addr(memr_addr_cpuout),
        .reg_sel_write(reg_sel_write),
        .regw_data(regw_data)
    );

endmodule
