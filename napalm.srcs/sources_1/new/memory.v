`timescale 1ns / 1ps


module memory (/*AUTOARG*/
   // Outputs
   data_rd, reg_wa,
   // Inputs
   clk, rst, res_m, _wd, _memWriteEn, reg_wa_m, _res
   ) ;
   input clk, rst;
   input  [31:0] res_m, _wd;
   input _memWriteEn;
   input [4:0]   reg_wa_m;
   input [31:0] _res;
   output reg [31:0] data_rd;
   output reg [4:0]       reg_wa;

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
         reg_wa <= reg_wa_m;
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
