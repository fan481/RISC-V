# RISC-V Notes
https://docs.riscv.org/reference/isa/_attachments/riscv-unprivileged.pdf
## ALU Opcodes (not necessarily risc-v standard)

| alu_op | Operation         | Description / Output                                              |
|--------|------------------|------------------------------------------------------------------|
| 0000   | ADD              | alu_out = op1 + op2 (used for LB/LW address calculation)              |
| 0001   | SUB              | alu_out = op1 - op2 (used for branches: BEQ/BNE)                      |
| 0010   | AND              | alu_out = op1 & op2                                                   |
| 0011   | OR               | alu_out = op1 \| op2                                                  |
| 0100   | XOR              | alu_out = op1 ^ op2                                                   |
| 0101   | SLL              | alu_out = op1 << op2[4:0] (logical left shift)                        |
| 0110   | SRL              | alu_out = op1 >> op2[4:0] (logical right shift)                       |
| 0111   | SRA              | alu_out = op1 >>> op2[4:0] (arithmetic right shift, preserves sign)   |
| 1000   | SLT              | alu_out = (op1 < op2) ? 1 : 0 (signed comparison)                     |
| 1001   | SLTU             | alu_out = (op1 < op2) ? 1 : 0 (unsigned comparison)                   |
| 1010   | Pass op2         | alu_out = op2 (used in LUI / AUIPC)                                   |
| 1011   | Pass op1         | alu_out = op1 (sometimes used for simple moves or NOP)                |
| 1100   | NOR              | alu_out = ~(op1 \| op2)                                               |
| 1101   | NAND             | alu_out = ~(op1 & op2)                                                |
| 1110   | XNOR             | alu_out = ~(op1 ^ op2)                                                |
| 1111   | Reserved / Custom| Optional for user-defined operations                            |
## RISC-V Register Conventions

| Name       | ABI Mnemonic | Calling Convention     | Preserved Across Calls? |
|------------|--------------|----------------------|------------------------|
| x0         | zero         | Zero                 | n/a                    |
| x1         | ra           | Return address       | No                     |
| x2         | sp           | Stack pointer        | Yes                    |
| x3         | gp           | Global pointer       | n/a                    |
| x4         | tp           | Thread pointer       | n/a                    |
| x5-x7      | t0-t2        | Temporary registers  | No                     |
| x8-x9      | s0-s1        | Saved registers      | Yes                    |
| x10-x17    | a0-a7        | Argument registers   | No                     |
| x18-x27    | s2-s11       | Saved registers      | Yes                    |
| x28-x31    | t3-t6        | Temporary registers  | No                     |
## RISC-V Base Instruction Set (Excl. FENCE/PAUSE/ECALL/EBREAK)
| Type   | Bits 31:25            | Bits 24:20 | Bits 19:15 | Bits 14:12 | Bits 11:7   | Bits 6:0 |
| ------ | --------------------- | ---------- | ---------- | ---------- | ----------- | -------- |
| R-type | funct7                | rs2        | rs1        | funct3     | rd          | opcode   |
| I-type | imm[11:0]             | —          | rs1        | funct3     | rd          | opcode   |
| S-type | imm[11:5]             | rs2        | rs1        | funct3     | imm[4:0]    | opcode   |
| B-type | imm[12|10:5]          | rs2        | rs1        | funct3     | imm[4:1|11] | opcode   |
| U-type | imm[31:12]            | —          | —          | —          | rd          | opcode   |
| J-type | imm[20|10:1|11|19:12] | —          | —          | —          | rd          | opcode   |
| Bits 31:25 / imm      | Bits 24:20 | Bits 19:15 | Bits 14:12 | Bits 11:7   | Opcode  | Instruction |
| --------------------- | ---------- | ---------- | ---------- | ----------- | ------- | ----------- |
| imm[31:12]            | —          | —          | —          | rd          | 0110111 | LUI         |
| imm[31:12]            | —          | —          | —          | rd          | 0010111 | AUIPC       |
| imm[20|10:1|11|19:12] | —          | —          | —          | rd          | 1101111 | JAL         |
| imm[11:0]             | —          | rs1        | 000        | rd          | 1100111 | JALR        |
| imm[12|10:5]          | rs2        | rs1        | 000        | imm[4:1|11] | 1100011 | BEQ         |
| imm[12|10:5]          | rs2        | rs1        | 001        | imm[4:1|11] | 1100011 | BNE         |
| imm[12|10:5]          | rs2        | rs1        | 100        | imm[4:1|11] | 1100011 | BLT         |
| imm[12|10:5]          | rs2        | rs1        | 101        | imm[4:1|11] | 1100011 | BGE         |
| imm[12|10:5]          | rs2        | rs1        | 110        | imm[4:1|11] | 1100011 | BLTU        |
| imm[12|10:5]          | rs2        | rs1        | 111        | imm[4:1|11] | 1100011 | BGEU        |
| imm[11:0]             | —          | rs1        | 000        | rd          | 0000011 | LB          |
| imm[11:0]             | —          | rs1        | 001        | rd          | 0000011 | LH          |
| imm[11:0]             | —          | rs1        | 010        | rd          | 0000011 | LW          |
| imm[11:0]             | —          | rs1        | 100        | rd          | 0000011 | LBU         |
| imm[11:0]             | —          | rs1        | 101        | rd          | 0000011 | LHU         |
| imm[11:5]             | rs2        | rs1        | 000        | imm[4:0]    | 0100011 | SB          |
| imm[11:5]             | rs2        | rs1        | 001        | imm[4:0]    | 0100011 | SH          |
| imm[11:5]             | rs2        | rs1        | 010        | imm[4:0]    | 0100011 | SW          |
| imm[11:0]             | —          | rs1        | 000        | rd          | 0010011 | ADDI        |
| imm[11:0]             | —          | rs1        | 010        | rd          | 0010011 | SLTI        |
| imm[11:0]             | —          | rs1        | 011        | rd          | 0010011 | SLTIU       |
| imm[11:0]             | —          | rs1        | 100        | rd          | 0010011 | XORI        |
| imm[11:0]             | —          | rs1        | 110        | rd          | 0010011 | ORI         |
| imm[11:0]             | —          | rs1        | 111        | rd          | 0010011 | ANDI        |
| 0000000               | shamt      | rs1        | 001        | rd          | 0010011 | SLLI        |
| 0000000               | shamt      | rs1        | 101        | rd          | 0010011 | SRLI        |
| 0100000               | shamt      | rs1        | 101        | rd          | 0010011 | SRAI        |
| 0000000               | rs2        | rs1        | 000        | rd          | 0110011 | ADD         |
| 0100000               | rs2        | rs1        | 000        | rd          | 0110011 | SUB         |
| 0000000               | rs2        | rs1        | 001        | rd          | 0110011 | SLL         |
| 0000000               | rs2        | rs1        | 010        | rd          | 0110011 | SLT         |
| 0000000               | rs2        | rs1        | 011        | rd          | 0110011 | SLTU        |
| 0000000               | rs2        | rs1        | 100        | rd          | 0110011 | XOR         |
| 0000000               | rs2        | rs1        | 101        | rd          | 0110011 | SRL         |
| 0100000               | rs2        | rs1        | 101        | rd          | 0110011 | SRA         |
| 0000000               | rs2        | rs1        | 110        | rd          | 0110011 | OR          |
| 0000000               | rs2        | rs1        | 111        | rd          | 0110011 | AND         |
