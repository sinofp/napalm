# Napalm

32 位 5 级流水线 MIPS CPU

## 特性

1. 5 级流水线
2. 41 条指令（不算 nop 的话，40 条）
3. 支持从执行、访存、写回阶段进行数据前推
4. 支持 load stall
5. 分支处理在解码阶段，所以不用分支预测
6. 完善的测试代码

## 支持指令

|     | Inst   | Type |
| --- | ------ | ---- |
| 1   | add    | R    |
| 2   | addi   | I    |
| 3   | addiu  | I    |
| 4   | addu   | R    |
| 5   | and    | R    |
| 6   | andi   | I    |
| 7   | beq    | I    |
| 8   | bgez   | IBR  |
| 9   | bgezal | IBR  |
| 10  | bgtz   | I    |
| 11  | blez   | I    |
| 12  | bltz   | IBR  |
| 13  | bltzal | IBR  |
| 14  | bne    | I    |
| 15  | j      | J    |
| 16  | jal    | J    |
| 17  | jr     | R    |
| 18  | lb     | I    |
| 19  | lui    | I    |
| 20  | lw     | I    |
| 21  | nop    | NOP  |
| 22  | or     | R    |
| 23  | ori    | I    |
| 24  | sb     | I    |
| 25  | sll    | R    |
| 26  | sllv   | R    |
| 27  | slt    | R    |
| 28  | slti   | I    |
| 29  | sltiu  | I    |
| 30  | sltu   | R    |
| 31  | sra    | R    |
| 32  | srl    | R    |
| 33  | srlv   | R    |
| 34  | sub    | R    |
| 35  | subu   | R    |
| 36  | sw     | I    |
| 37  | xor    | R    |
| 38  | nor    | R    |
| 39  | xori   | I    |
| 40  | lh     | I    |
| 41  | sh     | I    |
