`timescale 1ns / 1ps
module cu (
           input[31:0] inst,
           output cu_jump,
           output cu_beq,
           output cu_write2rt,
           output cu_imm2alu,
           output cu_write_imm,
           output cu_read_data,
           output cu_reg_we,
           output cu_mem_we,
           output cu_alu_op
       );

wire[5:0] opcode = inst[31:26];
wire[4:0] rs = inst[25:21];
wire[4:0] rt = inst[20:16];
wire[4:0] rd = inst[15:11];
wire[4:0] shamt = inst[10:6];
wire[5:0] funct = inst[5:0];
wire[15:0] imm = inst[15:0];
wire[25:0] instr_index = inst[25:0];

wire rtype = opcode == 6'b0;
wire jtype = opcode == 6'h2 || opcode == 6'h3;
wire itype = ~ (rtype | jtype);

assign cu_jump = jtype;
assign cu_write2rt = itype;
assign cu_imm2alu = itype;
assign cu_beq = opcode == 6'b000100;
assign cu_write_imm = opcode == 6'b001111; // lui
assign cu_read_data = opcode == 6'b100011; // lw
assign cu_reg_we = ~ (jtype | cu_mem_we); // R-type & I-type 除了 sw
assign cu_mem_we = opcode == 6'b101011; // sw
assign cu_alu_op = opcode == 6'b001100; // 0 -> +, 1 -> &
endmodule
