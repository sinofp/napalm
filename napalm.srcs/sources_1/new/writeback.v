`timescale 1ns / 1ps
`include "def.vh"


module writeback (
    input             clk,
    input             rst,
    input      [31:0] _mem_data,  // 从内存中读出的数据
    input      [31:0] _alu_alu_res,  // 从alu得到的结果
    input      [31:0] _imm_ext,  // lui的立即数
    input             _jump_link,  // 跳转的link addr
    input      [ 2:0] _reg_write_data_nux,  // cu的srcReg，用上面哪个数据写回
    input      [ 4:0] _reg_write_addr,  // 写到哪个寄存器
    input             _reg_we,  // write enable
    output reg        reg_we,
    output reg [ 4:0] reg_write_addr,  // 同上，但慢一个周期
    output     [31:0] reg_write_data
);

  reg [31:0] mem_data, alu_res, imm_ext, jump_link;
  reg [2:0] reg_write_data_nux;

  always @(posedge clk) begin
    if (rst) begin
      reg_we <= 0;  // 别写入就得了，剩下数据随意
    end else begin
      reg_we <= _reg_we;
      mem_data <= _mem_data;
      alu_res <= _alu_alu_res;
      imm_ext <= _imm_ext;
      jump_link <= _jump_link;
      reg_write_data_nux <= _reg_write_data_nux;
      reg_write_addr <= _reg_write_addr;
    end
  end

  assign reg_write_data = (reg_write_data_nux == `SRC_WRITE_REG_IMM)? imm_ext:
                    (reg_write_data_nux == `SRC_WRITE_REG_ALU)? alu_res:
                    (reg_write_data_nux == `SRC_WRITE_REG_MEM)? mem_data:
                    (reg_write_data_nux == `SRC_WRITE_REG_MEM)? mem_data:
                    (reg_write_data_nux == `SRC_WRITE_REG_JDST)? jump_link:
                    32'bx; // 不应该有这种情况——或者说这种情况并不用写回
  //TODO 给decode的register file
endmodule  // writeback
