`timescale 1ns / 1ps
`include "def.vh"

//    时间 →
// 1. f d e m w
// 2.   f d e m w
// 3.     f d e m w
// 4.       f d e m w
// 1 的 writeback 阶段影响下面三个指令的 decode 阶段
// 换句话说，每条指令在 decode 时要看前三条指令是否影响自己，
// 所谓前三条指令，就是当前在 execute 的、memory 的、writeback 的。
// forward 确定 decode 的 read data 应该从 reg_fil来，还是从 e/m/w 来。

// load stall 是 1 是从 m 中 load 的指令，2 是需要 1 写回值的其他指令。
// 在 2 进行到 d 时，1 刚到 e，但数据要到 m 才能前推过来。
// 也就是说 2 要停一个周期，变成下图的样子：
// f1 d1 e1 m1 w1
//    f2 d2 xx xx xx
//       f2 d2 e2 m2 w2
// 第二个 d2 时，1 进行到 m，此时可以正常前推。

module hazard_unit (
    input [4:0] _read_addr1, // reg_file要读取的两个地址
    input [4:0] _read_addr2,
    input _exe_we, // execute阶段的写入使能、写入地址，下面mem、wb同理
    input [4:0] _exe_wa,
    input _mem_we,
    input [4:0] _mem_wa,
    input _writeback_we,
    input [4:0] _writeback_wa,
    input [5:0] prev_op, // 上一条指令是从mem读内存的类型么？
    output [1:0] forward1,  // 前推mux选择
    output [1:0] forward2,
    output stall
);

  assign forward1 = (_writeback_we & (_read_addr1 != 0) & (_read_addr1 == _writeback_wa))? `FORWARD_WB:
                    (_mem_we & (_read_addr1 != 0) & (_read_addr1 == _mem_wa))? `FORWARD_WB:
                    (_exe_we & (_read_addr1 != 0) & (_read_addr1 == _exe_wa))? `FORWARD_WB:
                    `FORWARD_DEFAULT;

  assign forward2 = (_writeback_we & (_read_addr2 != 0) & (_read_addr2 == _writeback_wa))? `FORWARD_WB:
                    (_mem_we & (_read_addr2 != 0) & (_read_addr2 == _mem_wa))? `FORWARD_WB:
                    (_exe_we & (_read_addr2 != 0) & (_read_addr2 == _exe_wa))? `FORWARD_WB:
                    `FORWARD_DEFAULT;

  // 本该前推，但遇到了lw/lh
  assign stall = ((forward1 != `FORWARD_DEFAULT) | (forward1 != `FORWARD_DEFAULT)) &
                 ((prev_op == `LW_OP) | (prev_op == `LB_OP));
endmodule  // hazard_unit
