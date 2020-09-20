`timescale 1ns / 1ps


module decode (
    input clk,
    input rst,
    input [31:0] _pcp4d,  // 输入的pc + 4
    input [31:0] _inst,  // 输入的inst
    output [31:0] rd1,  // 从寄存器堆输出的第一个data
    output [31:0] rd2,  // 从寄存器堆输出的第二个data
    output [31:0] imm_ext, // 扩展后的imm，在execute里选择到底用imm还是rd2放到alu里
    input _wb_we,
    input [31:0] _wb_wd,
    input [4:0] _wb_wa,
    output [3:0] aluOp,  // alu做什么运算
    output srcAlu,  // 选择哪个是alu的操作数
    output reg [31:0] pcp4d,  // 输出的pc + 4，这个和_pcp4d有一个周期的延迟
    // output [4:0] sa, // alu的偏移量
    output regWriteEn,  // 写入reg的使能
    output memWriteEn,  // 写入内存的使能
    // output        link, // 把pc_next写入$31，其实br unit可以放在decode里，不用等alu
    output [2:0] jumpOp,  // 给br unit，告诉它走哪种跳转
    output [1:0] extendOp,  // 符号扩展怎么扩展，据说有好几种
    output [1:0]  writeRegDst, // 写回哪个寄存器，rt还是rd还是$31——所以link可以消失了
    output [2:0] srcReg  // 貌似是写回的数据来源，选哪条路
);

  wire[4:0] rs = inst[25:21];
  wire[4:0] rt = inst[20:16];

  reg  [31:0] inst;
  reg wb_we;
  reg [31:0] wb_wd;
  reg [4:0] wb_wa;

  always @(posedge clk) begin
    if (rst) begin
      inst <= 32'b0;
      pcp4d <= 32'b0;
      wb_we <= 1'b0;
    end else begin
      inst <= _inst;
      pcp4d <= _pcp4d;
      wb_we <= _wb_we;
      wb_wd <= _wb_we;
      wb_wa <= _wb_wa;
    end
  end

  cu CU (
      .inst(inst),
      .jumpOp(jumpOp),
      .extendOp(extendOp),
      .regWriteEn(regWriteEn),
      .memWriteEn(memWriteEn),
      .aluOp(aluOp),
      .writeRegDst(reg_wa),
      .srcAlu(srcAlu),
      .srcReg(srcReg),
      .saveRetAddrEn(link)
  );

  reg_file REG_FILE (
      .clk(clk),
      .ra1(rs),
      .ra2(rt),
      .wa (wb_wa),
      .we (wb_we),
      .wd (wb_wd),
      .rd1(rd1),
      .rd2(rd2)
  );

endmodule  // decode
