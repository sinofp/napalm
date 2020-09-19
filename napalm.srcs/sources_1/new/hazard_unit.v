`timescale 1ns / 1ps
`include "def.vh"

module hazard_unit(
                   input [4:0]  reg_ra1, // 寄存器的读地址1
                   input [4:0]  reg_ra2,
                   input [4:0]  reg_wa_alu, // alu的运算结果，要写回的数据地址
                   input [4:0]  reg_wa_mem, // 内存读出结果，要写回的地址
                   input        reg_we_alu, // alu的res要写入寄存器
                   input        reg_we_mem, // mem的rd要写入寄存器
                   input [5:0] optype,
                   output [1:0] forward1, // 前推mux选择
                   output [1:0] forward2,
                   // 用于lw/lh stall
                   output       stall_if, // if 停止一周期，保留当前值
                   output       stall_id, // id 停止一周期，保留当前值
                   output       flush_ex // ex 之后的随便来
                   );

  assign forward1 = (reg_we_alu & (reg_ra1 != 0) & (reg_ra1 == reg_wa_alu))? 2'b10: // alu的结果要写回，这个地址和我要读的一样 —— 我直接从alu那里读
                    (reg_we_mem & (reg_ra1 != 0) & (reg_ra1 == reg_wa_mem))? 2'b01: // mem的结果要写回，这个地址和我要读的一样 —— 我直接从mem那里读
                    2'b11; // 不前推

   assign forward2 = (reg_we_alu & (reg_ra1 != 0) & (reg_ra1 == reg_wa_alu))? 2'b10:
                     (reg_we_mem & (reg_ra2 != 0) & (reg_ra1 == reg_wa_mem))? 2'b01:
                     2'b11;

   // 本该前推，但遇到了lw/lh
   wire load_stall = ((forward1 != 2'b11) | (forward1 != 2'b11)) & (optype == `LW_OP); // TODO 这里还有lh
   assign stall_if = load_stall;
   assign stall_id = load_stall;
   assign flush_ex = load_stall;
endmodule // hazard_unit
