# Edu4Chip_RISCV
The project aims to simulate a pipelined RISC-V CPU.


## Prelim plan:
- Research the topic and the design requirements
- Design a few instructions - minimal working example.
- Verify the functionality of the minimal design
- Pipeline the CPU
- Run a program on the implementation
- FPGA?


Instruction set with slighlty expanded explanation compared to official documentation:
https://msyksphinz-self.github.io/riscv-isadoc/


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

The instruction memory is initially static and hardcoded.
