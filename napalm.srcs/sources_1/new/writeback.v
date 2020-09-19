`timescale 1ns / 1ps
`include "def.vh"


module writeback (
    input             clk,
    input             rst,
    input      [31:0] _data_rd, // 从内存中读出的数据
    input      [31:0] _res, // 从alu得到的结果
    input      [31:0] _upper_imm, // lui的立即数
    input             _jump_link, // 跳转的link addr
    input      [2:0]  _reg_wd_src, // cu的srcReg，用上面哪个数据写回
    input      [4:0]  _reg_wa, // 写到哪个寄存器
    input             _reg_we, // write enable
    output reg        reg_we,
    output reg [4:0]  reg_wa, // 同上，但慢一个周期
    output     [31:0] reg_wd
);

    reg [31:0] data_rd, res, upper_imm, jump_link;
    reg [2:0] reg_wd_src;

    always @(posedge clk) begin
        if (rst) begin
            reg_we <= 0; // 别写入就得了，剩下数据随意
        end else begin
            reg_we <= _reg_we;
            data_rd <= _data_rd;
            res <= _res;
            upper_imm <= _upper_imm;
            jump_link <= _jump_link;
            reg_wd_src <= _reg_wd_src;
            reg_wa <= _reg_wa;
        end 
    end

    assign reg_wd = (reg_wd_src == `SRC_WRITE_REG_IMM)? upper_imm:
                    (reg_wd_src == `SRC_WRITE_REG_ALU)? res:
                    (reg_wd_src == `SRC_WRITE_REG_MEM)? data_rd:
                    (reg_wd_src == `SRC_WRITE_REG_MEM)? data_rd:
                    (reg_wd_src == `SRC_WRITE_REG_JDST)? jump_link:
                    32'bx; // 不应该有这种情况——或者说这种情况并不用写回
  //TODO 给decode的register file
endmodule  // writeback
