`timescale 1ns / 1ps
`include "def.vh"

module hazard_unit(
                   input [4:0]  reg_ra1,
                   input [4:0]  reg_ra2,
                   input [4:0]  reg_wa_alu,
                   input [4:0]  reg_wa_mem,
                   input        reg_we_alu, // alu的res要写入寄存器
                   input        reg_we_mem, // mem的rd要写入寄存器
                   input [5:0] optype,
                   output [1:0] forward1,
                   output [1:0] forward2,
                   output       stall_if, // if 停止一周期，保留当前值
                   output       stall_id, // id 停止一周期，保留当前值
                   output       flush_ex // ex 之后的随便来
                   );

  assign forward1 = (reg_we_alu & (reg_ra1 != 0) & (reg_ra1 == reg_wa_alu))? 2'b10:
                    (reg_we_mem & (reg_ra1 != 0) & (reg_ra1 == reg_wa_mem))? 2'b01:
                    2'b11;

   assign forward2 = (reg_we_alu & (reg_ra1 != 0) & (reg_ra1 == reg_wa_alu))? 2'b10:
                     (reg_we_mem & (reg_ra2 != 0) & (reg_ra1 == reg_wa_mem))? 2'b01:
                     2'b11;

   wire                        load_stall = ((forward1 != 2'b11) | (forward1 != 2'b11)) & (optype == `LW_OP);
   assign stall_if = load_stall;
   assign stall_id = load_stall;
   assign flush_ex = load_stall;
endmodule // hazard_unit
