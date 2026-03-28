# ALU Opcodes
| alu_op | Operation         | Description / Output                                      |    |
| ------ | ----------------- | --------------------------------------------------------- | -- |
| 0000   | ADD               | Y = A + B (used for LB/LW address calc)                   |    |
| 0001   | SUB               | Y = A - B (used for branches: BEQ/BNE)                    |    |
| 0010   | AND               | Y = A & B                                                 |    |
| 0011   | OR                | Y = A | B                                                 |    |
| 0100   | XOR               | Y = A ^ B                                                 |    |
| 0101   | SLL               | Y = A << B[4:0] (logical left shift)                      |    |
| 0110   | SRL               | Y = A >> B[4:0] (logical right shift)                     |    |
| 0111   | SRA               | Y = A >>> B[4:0] (arithmetic right shift, preserves sign) |    |
| 1000   | SLT               | Y = (A < B) ? 1 : 0 (signed comparison)                   |    |
| 1001   | SLTU              | Y = (A < B) ? 1 : 0 (unsigned comparison)                 |    |
| 1010   | Pass B            | Y = B (used in LUI / AUIPC)                               |    |
| 1011   | Pass A            | Y = A (sometimes used for simple moves or NOP)            |    |
| 1100   | NOR               | Y = ~(A                                                   | B) |
| 1101   | NAND              | Y = ~(A & B)                                              |    |
| 1110   | XNOR              | Y = ~(A ^ B)                                              |    |
| 1111   | Reserved / Custom | Optional for user-defined ops                             |    |
