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
    input clk,
    input reset, //todo: refactor?
    input [31:0] instr,
    input instr_valid,
    output logic [14:0] decoded_sig, //todo: does this really need to connect to both register_write and register modules?
    output logic [1:0] jb, //EX 00 not jump or branch, 01 jump, 10 jump register, 11 branch //todo: should only need to go to PC?
    output logic [4:0] alu_select, //MSB flags immediate operations; [3:0] is ALU opcode
    output logic [31:0] imm, //sign-extended immediate output
    output logic imm_select, //EX mux the second input to the ALU
    output logic [3:0] mem_strb,
    output logic mem_valid, //EX
    output logic load_signed, //EX for sign extending of lb/lh
    output logic write_from_alu, //EX
    output logic trap//EX
    );
    reg trap_reg;//Todo: refactor trap
    assign trap = trap_reg;
    always @(posedge reset) begin
        trap_reg <= 0; //note: I think this and below need blocking assignment
    end
    always @(posedge clk) begin //default zero outputs
        imm_select <= 0;
        mem_valid <= 0;
        write_from_alu <= 0;
        load_signed <= 0;
        jb <= 2'b0;
    end
    always_comb begin //decode logic //note: needs error check
        case (instr[6:0])
            7'b0110111: begin //LUI
                decoded_sig[5:0] = instr[11:7];
                alu_select = 4'b1010;
                imm = {instr[31:12], 12'b0};
                imm_select = 1;
                write_from_alu = 1;
            end 
            7'b0010111: begin //AUIPC not supported, no need foreseen
                trap_reg = 1;
            end
            7'b1101111: begin //JAL
                
            end
            7'b0010111: begin //JALR
                
            end
            7'b0010111: begin //branch
                
            end
            7'b0010111: begin //load
                
            end
            7'b0010111: begin //store
                
            end
            7'b0010111: begin //arithmetic immediate
                
            end
            7'b0010111: begin //arithmetic
                
            end
            7'b0010111: begin //fence/pause
                
            end
            7'b0010111: begin //ecall/ebreak
                
            end
            
        endcase
    end
    
endmodule
