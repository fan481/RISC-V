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
    output logic [14:0] decoded_sig, //{rs1, rs2, rd} todo: does this really need to connect to both register_write and register modules?
    output logic [2:0] pc_select, //EX Select jump/branch mode for PC- 000 not jump or branch, 001 jump, 010 jump register, 011 beq, 100 bne, 101 comparative branches 
    output logic [4:0] alu_opcode, //MSB flags immediate operations; [3:0] is ALU opcode
    output logic [31:0] imm, //sign-extended immediate output
    output logic [1:0] alu_sel, //EX mux ALU op2- 0 rs2, 1 imm
    output logic [3:0] mem_strb, //EX
    output logic mem_valid, //EX
    output logic load_signed, //EX for sign extending of lb/lh
    output logic [1:0] write_from, //EX select register_write data output- 00 memory, 01 ALU, 10 PC
    output logic trap//EX
    );
    reg trap_reg;//Todo: refactor trap
    assign trap = trap_reg;
    always @(posedge clk) begin
        if (reset) trap_reg <= 0;
    end
    always_comb begin //decode logic //note: needs error check
        /* default values */
        alu_sel = 0;
        mem_valid = 0;
        write_from = 0;
        load_signed = 0;
        pc_select = 0;
        mem_strb = 0; //todo: this line may not be necessary
        /* decode logic */
        case (instr[6:0])
            7'b0110111: begin //LUI
                decoded_sig[4:0] = instr[11:7]; //note: other modules should only need to access rd
                alu_opcode = 4'b1010;
                imm = {instr[31:12], 12'b0};
                alu_sel = 1;
                write_from = 2'b01;
            end 
            7'b0010111: begin //AUIPC not supported, no need foreseen
                trap_reg = 1;
            end
            7'b1101111: begin //JAL
                decoded_sig[4:0] = instr[11:7]; //note: other modules should only need to access rd
                pc_select = 3'b001;
                //note: alu_opcode doesn't need assignment, alu_out not used
                imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; //note: last bit zero because of RISC-V specification (16-bit instruction support, 2-byte aligned), but this implementation only supports 32-bit instructions (4-byte aligned). IMEM must contain only 4-byte aligned jumps or runtime will break.
                alu_sel = 1;
                write_from = 2'b10;
            end
            7'b1100111: begin //JALR
                decoded_sig[4:0] = instr[11:7]; //note: other modules should only need to access rd and rs1
                decoded_sig[14:10] = instr[19:15];
                pc_select = 3'b010;
                alu_opcode = 4'b0000;
                imm = {{21{instr[31]}}, instr[30:20]};
                alu_sel = 1;
                write_from = 2'b10;
            end
            7'b1100011: begin //branch
                decoded_sig = {instr[19:15], instr[24:20], 5'b0}; //todo: optimize for rd == $zero when there's nothing to write
                imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
                case (instr[14:12]) //funct3
                    3'b000: begin //beq
                        pc_select = 3'b011;
                        alu_opcode = 4'b0001;
                    end
                    3'b001: begin //bne
                        pc_select = 3'b100;
                        alu_opcode = 4'b0001;
                    end
                    3'b100: begin //blt
                        pc_select = 3'b101;
                        alu_opcode = 4'b1000;
                    end
                    3'b101: begin //bge
                        pc_select = 3'b110;
                        alu_opcode = 4'b1000; //pc checks ~alu_out[0]
                    end
                    3'b110: begin //bltu
                        pc_select = 3'b101;
                        alu_opcode = 4'b1001;
                    end
                    3'b111: begin //bgeu
                        pc_select = 3'b110;
                        alu_opcode = 4'b1001; //pc checks ~alu_out[0]
                    end
                endcase
            end
            7'b0000011: begin //load
                
            end
            7'b0100011: begin //store
                
            end
            7'b0010011: begin //arithmetic immediate
                
            end
            7'b0110011: begin //arithmetic
                
            end
            7'b0001111: begin //fence/pause
                
            end
            7'b1110011: begin //ecall/ebreak
                
            end
            
        endcase
    end
    
endmodule
