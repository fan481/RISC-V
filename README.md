# RISC-V Notes
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