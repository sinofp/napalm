module top (
           input clk,
           input rst_n
       );

wire[31:0] pc_now;
wire[31:0] pc_next;

wire[31:0] inst;
wire[4:0] rs = inst[25:21];
wire[4:0] rt = inst[20:16];
wire[4:0] rd = inst[15:11];
wire[25:0] instr_index = inst[25:0];
wire[15:0] imm = inst[15:0];

wire cu_jump;
wire cu_write2rt;
wire cu_imm2alu;
wire cu_write_imm;
wire cu_read_data;
wire cu_reg_we;
wire cu_mem_we;
wire cu_alu_op;

wire[31:0] rd1, rd2;

wire[31:0] res;
wire[31:0] load_data;

pc PC(.clk(clk), .rst_n(rst_n), .pc_next(pc_next), .pc_now(pc_now));

cu CU(.inst(inst),
      .cu_jump(cu_jump),
      .cu_write2rt(cu_write2rt),
      .cu_imm2alu(cu_imm2alu),
      .cu_write_imm(cu_write_imm),
      .cu_read_data(cu_read_data),
      .cu_reg_we(cu_reg_we),
      .cu_mem_we(cu_mem_we),
      .cu_alu_op(cu_alu_op));

br_unit BR_UNIT(.pc(pc_now),
                .instr_index(instr_index),
                .offset(imm),
                .rd1(rd1),
                .rd2(rd2),
                .cu_jump(cu_jump),
                .pc_next(pc_next));

reg_heap REG_HEAP(.clk(clk),
                  .ra1(rs),
                  .ra2(rt),
                  .wa(cu_write2rt? rt: rd),
                  .we(cu_reg_we),
                  .wd(cu_write_imm? {imm, 16'b0}: cu_read_data? load_data: res),
                  .rd1(rd1),
                  .rd2(rd2));

data_mem DATA_MEM(.clk(clk),
                  .addr(res),
                  .wd(rd2),
                  .we(cu_mem_we),
                  .rd(load_data));

inst_mem INST_MEM(.clk(clk),
                  .pc(pc_now),
                  .inst(inst));

alu ALU(.alu_op(cu_alu_op),
        .num1(rd1),
        .num2(cu_imm2alu? { {16{imm[15]}}, imm }: rd2),
        .res(res));
endmodule
