`timescale 1ns / 1ps


module cpu (
    input clk,
    input rst_n
);
  wire rst = ~rst_n;

  wire [31:0] df_pc_jump;
  wire df_jump;
  wire stall;
  wire [31:0] fd_pcp4;
  wire [31:0] fd_inst;

  fetch FETCH (
      .clk(clk),
      .rst(rst),
      ._pc_jump(df_pc_jump),
      ._jump(df_jump),
      ._stall(stall),
      .pcp4(fd_pcp4),
      .inst(fd_inst)
  );

  wire [31:0] de_rd1, de_rd2;
  wire [31:0] de_imm_ext;

  wire [3:0] de_alu_op;
  wire de_alu_src;
  wire [31:0] de_pcp8;

  wire de_reg_we, de_mem_we;
  wire [4:0] de_reg_wa;
  wire [2:0] de_wd_mux;
  wire [2:0] de_jump_op;
  wire [1:0] de_extend_op;
  wire [1:0] de_wb_dst_mux;
  wire [2:0] de_wb_src_mux;

  wire [4:0] de_shamt;

  // for hazard unit
  wire ed_we, md_we, wd_we;
  wire [4:0] ed_wa, md_wa, wd_wa;
  wire [31:0] ed_wd, md_wd, wd_wd;

  wire [5:0] de_opcode;

  decode DECODE (
      .clk(clk),
      .rst(rst),
      ._pcp4(fd_pcp4),
      ._inst(fd_inst),
      //**************************Hazard Unit**************************************  
      ._exe_we(ed_we),
      ._exe_wa(ed_wa),
      ._exe_wd(ed_wd),
      ._mem_we(md_we),
      ._mem_wa(md_wa),
      ._mem_wd(md_wd),
      ._writeback_we(wd_we),
      ._writeback_wa(wd_wa),
      ._writeback_wd(wd_wd),
      //**************************Hazard Unit**************************************  
      .rd1(de_rd1),  // 从寄存器堆输出的第一个data
      .rd2(de_rd2),  // 从寄存器堆输出的第二个data
      .imm_ext(de_imm_ext), // 扩展后的imm，在execute里选择到底用imm还是rd2放到alu里
      .alu_op(de_alu_op),  // alu做什么运算
      .alu_src(de_alu_src),  // 选择哪个是alu的操作数
      .pcp8(de_pcp8),  // 输出的pc + 8，用于link写入$31
      .reg_we(de_reg_we),  // 写入reg的使能
      .mem_we(de_mem_we),  // 写入内存的使能
      .reg_write_addr(de_reg_wa),  // 写回哪个寄存器
      .reg_wd_mux(de_wd_mux),  // 写回的数据来源，选哪条路
      // To instruction fetch
      .pc_jump(df_pc_jump),
      .jump(df_jump),
      .opcode(de_opcode),
      .stall(stall)
  );

  wire [31:0] em_res;
  wire [2:0] em_wb_dst_mux;
  wire [31:0] em_mem_wd;

  wire overflow;  // 这玩意，现在不输出给任何人

  wire em_reg_we, em_mem_we;
  wire [ 4:0] em_reg_wa;
  wire [32:0] em_imm_ext;
  wire [32:0] em_alu_res;
  wire [32:0] em_rd2;
  wire [ 2:0] em_wd_mux;
  wire [ 5:0] em_opcode;
  wire [32:0] em_pcp8;

  execute EXECUTE (
      .clk(clk),
      .rst(rst),
      ._alu_op(de_alu_op),
      ._alu_src(de_alu_src),
      ._rd1(de_rd1),
      ._rd2(de_rd2),
      ._imm_ext(de_imm_ext),
      ._pcp8(de_pcp8),
      ._reg_write_addr(de_reg_wa),  // 寄存器写入地址，在decode中已被计算
      ._op_code(de_opcode),  // 操作码，用于lb等访存操作
      ._reg_wd_mux(de_wd_mux),  // reg写回的数据来源
      ._reg_we(de_reg_we),  // 新来的指令要不要写入寄存器
      ._mem_we(de_mem_we),  // 新来的指令要不要写入data mem
      ._stall(stall),
      .reg_write_addr(em_reg_wa),  // （传递）寄存器写入地址，在decode中已被计算
      .imm_ext(em_imm_ext),  // （传递）扩张的立即数
      .alu_res(em_alu_res),  // alu运算结果。支持乘法除法的话，应该改成64位
      .rd2(em_rd2),  // （传递）可能给reg_wd
      .reg_wd_mux(em_wd_mux),  // （传递）reg写回的数据来源
      .op_code(em_opcode),  // （传递）操作码，用于lb等访存操作
      .pcp8(em_pcp8),
      .overflow(overflow),
      .reg_we(em_reg_we),
      .mem_we(em_mem_we)
  );

  wire [31:0] mw_mem_data;

  wire [31:0] mw_alu_res;
  wire [31:0] mw_imm_ext;
  wire mw_reg_we;
  wire [2:0] mw_wd_mux;
  wire [4:0] mw_reg_wa;
  wire [31:0] mw_pcp8;

  memory MEMORY (
      .clk(clk),
      .rst(rst),
      ._rd2(em_rd2),
      ._reg_write_addr(em_reg_wa),
      ._reg_wd_mux(em_wd_mux),
      ._alu_res(em_alu_res),
      ._mem_we(em_mem_we),
      ._reg_we(em_reg_we),
      ._imm_ext(em_imm_ext),
      ._pcp8(em_pcp8),
      ._opcode(em_opcode),
      .reg_we(mb_reg_we),
      .mem_data(mw_mem_data),
      .alu_res(mw_alu_res),
      .imm_ext(mw_imm_ext),
      .reg_wd_mux(mw_wd_mux),
      .reg_write_addr(mw_reg_wa),
      .pcp8(mw_pcp8)
  );

  writeback WRITEBACK (
      .clk(clk),
      .rst(rst),
      ._mem_data(mw_mem_data),  // 从内存中读出的数据
      ._alu_res(mw_alu_res),  // 从alu得到的结果
      ._imm_ext(mw_imm_ext),  // lui的立即数
      ._pcp8(mw_pcp8),  // 跳转的link addr
      ._reg_wd_mux(mw_wd_mux),  // cu的srcReg，用上面哪个数据写回
      ._reg_write_addr(mw_reg_wa),  // 写到哪个寄存器
      ._reg_we(mb_reg_we),  // write enable
      .reg_we(wd_we),
      .reg_write_addr(wd_wa),  // 同上，但慢一个周期
      .reg_write_data(wd_wd)
  );
endmodule
