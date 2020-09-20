`timescale 1ns / 1ps


module cpu (
    input clk,
    input rst_n
);
  wire rst = ~rst_n;

  wire [31:0] df_pc_jump;
  wire df_jump;
  wire [31:0] fd_pcp4;
  wire [31:0] fd_inst;

  fetch FETCH (
    .clk(clk),
    .rst(rst),
    ._pc_jump(df_pc_jump),
    ._jump(df_jump),
    .pcp4d(fd_pcp4),
    .inst(fd_inst)
  );

  wire [31:0] de_rd1, de_rd2;
  wire [31:0] de_imm_ext;

  wire wd_we;
  wire [31:0] wd_wd;
  wire [4:0] wd_wa;

  wire [3:0] de_alu_op;
  wire de_alu_src;
  wire [31:0] de_pcp4;

  wire de_reg_we, de_mem_we;
  // TODO jumpOp不应该输出，下一个commit把brunit移回到decode
  wire [2:0] de_jump_op;
  wire [1:0] de_extend_op;
  wire [1:0] de_wb_dst_mux;
  wire [2:0] de_wb_src_mux;

  wire [4:0] de_shamt;
  // TODO execute sa
  decode DECODE (
    .clk(clk),
    .rst(rst),
    ._pcp4d(fd_pcp4),
    ._inst(fd_inst),
    .rd1(de_rd1),
    .rd2(de_rd2),
    .imm_ext(de_imm_ext),
    ._wb_we(wd_we),
    ._wb_wd(wd_wd),
    ._wb_wa(wd_wa),
    .aluOp(de_alu_op),
    .srcAlu(de_alu_src),
    .pcp4d(de_pcp4),
    .regWriteEn(de_reg_we),
    .memWriteEn(de_mem_we),
    .jumpOp(de_jump_op),
    .extendOp(de_extend_op),
    .writeRegDst(de_wb_dst_mux),
    .srcReg(de_wb_src_mux)  // 貌似是写回的数据来源，选哪条路
  );

  wire [31:0] em_res;
  wire [2:0] em_wb_dst_mux;
  wire [31:0] em_mem_wd;

  wire overflow; // 这玩意，现在不输出给任何人

  wire em_reg_we, em_mem_we;

  // TODO de_extend_op de_wb_src_mux
  execute EXECUTE (
    .clk(clk),
    .rst(rst),
    ._aluOp(de_alu_op),
    ._srcAlu(de_alu_src),
    ._rd1(de_rd1),
    ._rd2(de_rd2),
    ._imm_ext(de_imm_ext),
    ._pcp4f(de_pcp4),
    .sa(de_shamt),
    ._regWriteEn(de_reg_we),
    ._memWriteEn(de_mem_we),
    .res(em_res),
    .data_wd_e(em_mem_wd),
    .writeRegDst(em_wb_dst_mux), // TODO 这玩意没输入啊de_wb_dst_mux
    .pc_jump(df_pc_jump), // ↓
    .jump(df_jump), // TODO move back to decode
    .overflow(overflow),
    .regWriteEn(em_reg_we),
    .memWriteEn(em_mem_we)  // 这条指令要不要写入data mem
  );

  // TODO em_reg_we _reg_wa_m
  wire [4:0] mw_wb_wa;

  wire [31:0] mw_mem_data;

  wire [31:0] me_res;

  memory MEMORY (
    .clk(clk),
    .rst(rst),
    ._wd(em_mem_wd),
    ._memWriteEn(em_mem_we), // TODO 这怎么不输出？
    ._res(em_res), // TODO 还得原样输出一个res给writeback
    ._reg_wa_m(),
    .data_rd(mw_mem_data),
    .reg_wa(mw_wb_wa)  // 给写回的，和_reg_wa_m差一个周期
  );

  writeback WRITEBACK (    
    .clk(clk),
    .rst(rst),
    ._data_rd(mw_mem_data),
    ._res(me_res),
    ._upper_imm(), // TODO 这玩意哪里来
    ._jump_link(), // TODO
    ._reg_wd_src(), 
    ._reg_wa(),
    ._reg_we(),
    .reg_we(wd_we),
    .reg_wa(wd_wa),
    .reg_wd(wd_wd)
  );
endmodule
