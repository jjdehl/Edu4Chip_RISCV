# Edu4Chip_RISCV

## Prelim plan:
- Research the topic and the design requirements
- Design a few instructions - minimal working example.
- Verify the functionality of the minimal design
- Pipeline the CPU
- Run a program on the implementation
- FPGA?


Instruction set:
https://msyksphinz-self.github.io/riscv-isadoc/

Example progression
https://github.com/BrunoLevy/learn-fpga/blob/master/FemtoRV/TUTORIALS/FROM_BLINKER_TO_RISCV/README.md


## Notes on instruction set:
- [6:0] is the opcode
- [11:7] is the result register
- [19:15] is rs1
- [24:20] is rs2
  
Bits 31:7 are constructed based on the opcode.

Only the bits outlined above are passed on to the register file.

Initially, the following instructions are implemented:
lui
addi
add

And no data memory is included.

The instruction memory is initially static and hardcoded.
