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


module rv32_decoder( //note: put default case (error) handling only in the decoder
    input clk, //todo: consider reordering in/out variables for max readability
    input reset, //todo: refactor?
    input [31:0] instr,
    input instr_valid,
    output logic [14:0] decoded_sig, //{rs1, rs2, rd} todo: does this really need to connect to both register_write and register modules?
    output logic [2:0] pc_select, //EX Select jump/branch mode for PC- 000 not jump or branch, 001 jump, 010 jump register, 011 beq, 100 bne, 101 comparative branches 
    output logic [3:0] alu_opcode, //opcodes in doc
    output logic alu_sel, //EX mux ALU op2- 0 rs2, 1 imm
    output logic [31:0] imm, //sign-extended immediate output
    output logic mem_valid, //EX
    output logic [1:0] mem_size, //EX used for both read/write- 00 word, 01 byte, 10 half
    output logic load_unsigned, //EX 0 load signed, 1 load unsigned
    output logic [1:0] write_from, //EX select register_write data output- 00 memory, 01 ALU, 10 PC
    output logic trap//EX //todo: refactor
    );

    logic trap_flag; //todo: consider refactoring trap/error

    always_ff @(posedge clk) begin
        if (reset) trap <= 0;
        else trap <= trap_flag;
    end

    always_comb begin
        trap_flag = 0;
        /* default values */ //todo: put in same order as module outputs
        alu_sel = 0; //todo: default can be 1 to reduce LoC
        mem_valid = 0;
        write_from = 0;
        mem_size = 0;
        load_unsigned = 0;
        pc_select = 0;
        decoded_sig[4:0] = 5'b0; //todo: remove redundant assignments below
        //todo: consolidate decoded_sig assignments into one top level assign; make sure garbage data in unused fields doesn't break anything + consider swapping the rs1, rs2 order in decoded_sig
        /* decode logic */ //todo: check that latches are not inferred due to default case nonassignments
        case (instr[6:0]) //todo: refactor sign extensions for imm to 'imm = $signed(x)' pattern where applicable?
            7'b0110111: begin //LUI
                decoded_sig[4:0] = instr[11:7]; //note: other modules should only need to access rd
                alu_opcode = 4'b1010;
                alu_sel = 1;
                imm = {instr[31:12], 12'b0};
                write_from = 2'b01;
            end 
            7'b0010111: begin //AUIPC not supported, no need foreseen
                trap_flag = 1;
            end
            7'b1101111: begin //JAL
                decoded_sig[4:0] = instr[11:7]; //note: other modules should only need to access rd
                pc_select = 3'b001;
                //note: alu_opcode doesn't need assignment, alu_out not used
                alu_sel = 1;
                imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; //note: last bit zero because of RISC-V specification (16-bit instruction support, 2-byte aligned), but this implementation only supports 32-bit instructions (4-byte aligned). IMEM must contain only 4-byte aligned jumps or runtime will break.
                write_from = 2'b10;
            end
            7'b1100111: begin //JALR
                decoded_sig[4:0] = instr[11:7]; //note: other modules should only need to access rd and rs1
                decoded_sig[14:10] = instr[19:15];
                pc_select = 3'b010;
                alu_opcode = 4'b0000;
                alu_sel = 1;
                imm = {{21{instr[31]}}, instr[30:20]};
                write_from = 2'b10;
            end
            7'b1100011: begin //branch
                decoded_sig = {instr[19:15], instr[24:20], 5'b0}; //todo: optimize for rd == $zero case (when there's nothing to write)
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
                    default: begin //invalid funct7/funct3 combination
                        trap_flag = 1;
                    end
                endcase
            end
            7'b0000011: begin //load
                decoded_sig[14:10] = instr[19:15];
                decoded_sig[4:0] = instr[11:7]; //only assigning rs1 and rd bits here, rs2 bits should not be needed
                alu_opcode = 4'b0000;
                alu_sel = 1;
                imm = $signed(instr[31:20]);
                case (instr[14:12])
                    3'b000: begin //lb
                        mem_size = 2'b01;
                    end
                    3'b001: begin //lh
                        mem_size = 2'b10;
                    end
                    3'b010: begin //lw
                        //mem_size and load_unsigned both assigned already, nothing to do here
                    end
                    3'b100: begin //lbu
                        mem_size = 2'b01;
                        load_unsigned = 1;
                    end
                    3'b101: begin //lhu
                        mem_size = 2'b10;
                        load_unsigned = 1;
                    end
                    default: begin //invalid funct7/funct3 combination
                        trap_flag = 1;
                    end
                endcase
            end
            7'b0100011: begin //store
                decoded_sig = {instr[19:15], instr[24:20], 5'b0};
                alu_opcode = 4'b0000;
                alu_sel = 1;
                imm = {{21{instr[31]}}, instr[30:25], instr[11:7]};
                case (instr[14:12])
                    3'b000: begin //sb
                        mem_valid = 1;
                        mem_size = 2'b01;
                    end
                    3'b001: begin //sh
                        mem_valid = 1;
                        mem_size = 2'b10;
                    end
                    3'b010: begin //sw
                        mem_valid = 1;
                        //default mem_size is word, 2'b0
                    end
                    default: begin //invalid funct7/funct3 combination
                        trap_flag = 1;
                    end
                endcase
            end
            7'b0010011: begin //arithmetic immediate
                decoded_sig = {instr[19:15], 5'b0, instr[11:7]};
                alu_sel = 1;
                imm = {{21{instr[31]}}, instr[30:20]};
                write_from = 2'b01;
                case (instr[14:12])
                    3'b000: begin //addi
                        alu_opcode = 4'b0000;
                    end
                    3'b010: begin //slti
                        alu_opcode = 4'b1000;
                    end
                    3'b011: begin //sltiu
                        alu_opcode = 4'b1001;
                    end
                    3'b100: begin //xori
                        alu_opcode = 4'b0100;
                    end
                    3'b110: begin //ori
                        alu_opcode = 4'b0011;
                    end
                    3'b111: begin //andi
                        alu_opcode = 4'b0010;
                    end
                    3'b001: begin //slli
                        //imm output needs to be shamt
                        imm = {27'b0, instr[24:20]}; //todo: best practice? the upper bits don't matter (ALU truncates), is it better to declare without upper bits zeroed?
                        alu_opcode = 4'b0101;
                    end
                    3'b101: begin //srli, srai
                        //imm output needs to be shamt
                        imm = {27'b0, instr[24:20]};
                        if (instr[30]) alu_opcode = 4'b0111; //srai
                        else alu_opcode = 4'b0110; //srli
                    end
                endcase
            end
            7'b0110011: begin //arithmetic
                decoded_sig = {instr[19:15], instr[24:20], instr[11:7]};
                imm = 32'b0; //todo: check if this line is needed (will a latch be inferred if this is removed?)
                write_from = 2'b01;
                case (instr[14:12])
                    3'b000: begin //add, sub
                        if (instr[30]) alu_opcode = 4'b0001; //sub
                        else alu_opcode = 4'b0000; //add
                    end
                    3'b001: begin //sll
                        alu_opcode = 4'b0101;
                    end
                    3'b010: begin //slt
                        alu_opcode = 4'b1000;
                    end
                    3'b011: begin //sltu
                        alu_opcode = 4'b1001;
                    end
                    3'b100: begin //xor
                        alu_opcode = 4'b0100;
                    end
                    3'b101: begin //srl, sra
                        if (instr[30]) alu_opcode = 4'b0111; //sra
                        else alu_opcode = 4'b0110; //srl
                    end
                    3'b110: begin //or
                        alu_opcode = 4'b0011;
                    end
                    3'b111: begin //and
                        alu_opcode = 4'b0010;
                    end
                endcase
            end
            7'b0001111: begin //fence/pause
                
            end
            7'b1110011: begin //ecall/ebreak
                
            end
            default: trap_flag = 1;
        endcase
    end
    
endmodule
