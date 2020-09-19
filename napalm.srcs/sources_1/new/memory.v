`timescale 1ns / 1ps


module memory (
   input clk,
   input rst,
   input  [31:0] _wd, // 要写入的数据
   input _memWriteEn, // 要写入么？
   input [31:0] _res, // alu的运算结果，同时也是访存的地址
   input [4:0]   _reg_wa_m, // 给写回阶段的，写回到哪个寄存器——reg_file.wa
   output reg [31:0] data_rd, // 读出的数据
   output reg [4:0]  reg_wa // 给写回的，和_reg_wa_m差一个周期
   ) ;

   reg [31:0] wd, res;
   reg memWriteEn;

   always @(posedge clk) begin
      if (rst) begin
         res <= 32'b0;
         reg_wa <= 5'b0;
         wd <= 32'b0;
         memWriteEn <= 1'b0;
      end else begin
         res <= _res;
         reg_wa <= _reg_wa_m;
         wd <= _wd;
         memWriteEn <= _memWriteEn;
      end
   end

   data_mem DATA_MEM(
    .clk(clk),
    .addr(res),
    .wd(wd),
    .we(memWriteEn),
    .rd(data_rd)
   );

endmodule // memory
