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
    


    integer test_errors = 0;
    logic unexpected_trap = 0;

    task automatic check_reg(
        input integer reg_index,
        input logic [31:0] expected,
        input string instruction_name
    );
        if (cpu_inst.register_file_inst.reg_data[reg_index] !== expected) begin
            $error("%s failed: x%0d = %h, expected %h",
                   instruction_name, reg_index,
                   cpu_inst.register_file_inst.reg_data[reg_index], expected);
            test_errors = test_errors + 1;
        end
    endtask

    // A trap before the final AUIPC means a branch reached an invalid sentinel.
    always @(negedge clk) begin
        if (!reset && trap && cpu_inst.pc_inst.pc_addr != 32'h000000c8)
            unexpected_trap = 1;
    end

    initial begin
        wait (cpu_inst.pc_inst.pc_addr == 32'h000000c8);
        @(negedge clk);
        #1;

        check_reg(1,  32'h00000014, "JAL/JALR");
        check_reg(3,  32'hffffff80, "SH/LH");
        check_reg(4,  32'h0000ff80, "LHU");
        check_reg(5,  32'h00000001, "ADDI");
        check_reg(6,  32'h00001000, "LUI");
        check_reg(7,  32'h00000001, "SW/LW");
        check_reg(8,  32'h00001001, "ADD");
        check_reg(9,  32'hfffffff8, "ADDI negative immediate");
        check_reg(10, 32'hfffffff8, "SW/LW full-width");
        check_reg(11, 32'h00000001, "SUB");
        check_reg(12, 32'h00000004, "SLL");
        check_reg(13, 32'h00000001, "SLT");
        check_reg(14, 32'h00000000, "SLTU");
        check_reg(15, 32'hfffffff9, "XOR");
        check_reg(16, 32'h3ffffffe, "SRL");
        check_reg(17, 32'hfffffffe, "SRA");
        check_reg(18, 32'hfffffff9, "OR");
        check_reg(19, 32'h00000000, "AND");
        check_reg(20, 32'h00000001, "SLTI");
        check_reg(21, 32'h00000001, "SLTIU");
        check_reg(22, 32'h00000007, "XORI");
        check_reg(23, 32'h0000000a, "ORI");
        check_reg(24, 32'h00000008, "ANDI");
        check_reg(25, 32'h00000010, "SLLI");
        check_reg(26, 32'h3ffffffe, "SRLI");
        check_reg(27, 32'hfffffffe, "SRAI");
        check_reg(28, 32'hffffff80, "ADDI signed byte operand");
        check_reg(29, 32'hffffff80, "SB/LB");
        check_reg(30, 32'h00000080, "LBU");

        if (trap !== 1'b1) begin
            $error("AUIPC failed: trap = %b, expected 1", trap);
            test_errors = test_errors + 1;
        end

        if (unexpected_trap) begin
            $error("An instruction trapped or a branch reached an invalid sentinel");
            test_errors = test_errors + 1;
        end

        if (test_errors == 0)
            $display("PASS: all instructions behaved as expected");
        else
            $fatal(1, "FAIL: %0d instruction checks failed", test_errors);
        $finish;
    end

endmodule
