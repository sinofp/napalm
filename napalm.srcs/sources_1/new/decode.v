`timescale 1ns / 1ps
`include "def.vh"


module decode (
    input clk,
    input rst,

    input [31:0] _pcp4,  // 输入的pc + 4
    input [31:0] _inst,  // 输入的inst
    //**************************Hazard Unit***************************************
    // execute阶段的写入使能、写入地址、写入数据
    input _exe_we,
    input [4:0] _exe_wa,
    input [31:0] _exe_wd,
    // memory阶段的写入使能、写入地址、写入数据
    input _mem_we,
    input [4:0] _mem_wa,
    input [31:0] _mem_wd,
    // writeback阶段的写入使能、写入地址、写入数据
    input _writeback_we,
    input [4:0] _writeback_wa,
    input [31:0] _writeback_wd,
    // 上面这些用于解决数据冲突时，不用做成reg缓存一个周期。因为冲突发生在当前周期。
    //**************************Hazard Unit***************************************

    output [31:0] rd1,  // 从寄存器堆输出的第一个data
    output [31:0] rd2,  // 从寄存器堆输出的第二个data
    output [31:0] imm_ext, // 扩展后的imm，在execute里选择到底用imm还是rd2放到alu里
    output [3:0] alu_op,  // alu做什么运算
    output alu_src,  // 选择哪个是alu的操作数
    output reg [31:0] pcp8,  // 输出的pc + 8，用于link写入$31

    // output [4:0] sa, // alu的偏移量
    output reg_we,  // 写入reg的使能
    output mem_we,  // 写入内存的使能
    // output        link, // 把pc_next写入$31，其实br unit可以放在decode里，不用等alu
    // DELETED output [2:0] jumpOp,  // 给br unit，告诉它走哪种跳转
    //output [1:0] extend_op,  // 符号扩展怎么扩展，据说有好几种
    output [4:0] reg_write_addr,  // 写回哪个寄存器
    output [2:0] reg_wd_mux,  // 写回的数据来源，选哪条路

    // To instruction fetch
    output [31:0] pc_jump,
    output jump,
    output [5:0] opcode,
    output stall
);

  wire [2:0] forward1, forward2;

  reg [31:0] inst;
  reg wb_we;
  reg [31:0] wb_wd;
  reg [4:0] wb_wa;
  reg [5:0] prev_op;

  wire [4:0] rs = inst[25:21];
  wire [4:0] rt = inst[20:16];
  wire [4:0] rd = inst[15:11];
  assign opcode = inst[31:26];

  always @(posedge clk) begin
    if (rst) begin
      inst <= 32'b0;
      pcp8 <= 32'b0;
      wb_we <= 1'b0;
      prev_op <= 6'b0;
    end else if (stall) begin
      // 用上一周期的值
      inst <= inst;
      pcp8 <= pcp8;
      wb_we <= wb_we;
      wb_wd <= wb_we;
      wb_wa <= wb_wa;
      // stall完了，prev op就不应该再是让它stall的load了
      prev_op <= 6'b0;
    end else begin
      inst <= _inst;
      pcp8 <= _pcp4 + 4;
      wb_we <= _writeback_we;
      wb_wd <= _writeback_we;
      wb_wa <= _writeback_wd;
      prev_op <= inst[31:26];
    end
  end

  wire [`BR_OP_LEN - 1 : 0] br_op;
  wire [1:0] write_reg_dst;
  // cu_reg_we is not final reg_we. It should be or with linkable
  // linkable is (jump && (write_reg_dst == `WRITE_REG_DST_31))
  wire cu_reg_we;
  cu CU (
      ._inst(inst),

      .reg_we(cu_reg_we),
      .mem_we(mem_we),
      .alu_op(alu_op),
      .write_reg_dst(write_reg_dst),
      .alu_src(alu_src),
      .reg_write_data_mux(reg_wd_mux),
      .br_op(br_op),
      .imm_ext(imm_ext)
  );

  wire linkable;
  assign linkable = (jump && (write_reg_dst == `WRITE_REG_DST_31));
  assign reg_we = cu_reg_we || linkable;

  // 通过write_reg_dst获取寄存器地址
  // `WRITE_REG_DST_RD: RD
  // `WRITE_REG_DST_RT: RT
  // `WRITE_REG_DST_31: $31
  // `WRITE_REG_DST_DEFAULT: 
  assign reg_write_addr = (write_reg_dst == `WRITE_REG_DST_RD) ? rd :
  (write_reg_dst == `WRITE_REG_DST_RT) ? rt :
  (write_reg_dst == `WRITE_REG_DST_31) ? 5'd31 : 5'd0;

  wire [31:0] reg_rd1;
  wire [31:0] reg_rd2;
  reg_file REG_FILE (
      .clk(clk),
      .ra1(rs),
      .ra2(rt),
      .wa (wb_wa),
      .we (wb_we),
      .wd (wb_wd),
      .rd1(reg_rd1),
      .rd2(reg_rd1)
  );

  assign rd1 = (forward1 == `FORWARD_EXE) ? _exe_wd : 
  (forward1 == `FORWARD_MEM) ? _mem_wd : 
  (forward1 == `FORWARD_WB) ? _writeback_wd : reg_rd1;
  assign rd2 = (forward2 == `FORWARD_EXE) ? _exe_wd : 
  (forward2 == `FORWARD_MEM) ? _mem_wd : 
  (forward2 == `FORWARD_WB) ? _writeback_wd : reg_rd2;

  br_unit BR_UNIT (
      .clk(clk),
      .rd1(rd1),
      .rd2(rd2),
      .mode(br_op),
      .pcp4(_pcp4d),
      .imm_ext(imm_ext),
      .jump(jump),
      .pc_jump(pc_jump)
  );

  hazard_unit HAZARD_UNIT (
      ._read_addr1(rs),
      ._read_addr2(rt),
      ._exe_we(_exe_we),
      ._exe_wa(_exe_wa),
      ._mem_we(_mem_we),
      ._mem_wa(_mem_wa),
      ._writeback_we(_writeback_we),
      ._writeback_wa(_writeback_wa),
      .prev_op(prev_op),
      .forward1(forward1),
      .forward2(forward2),
      .stall(stall)
  );

endmodule  // decode
