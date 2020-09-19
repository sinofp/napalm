`timescale 1ns / 1ps


module decode (
   input  clk,
   input [31:0] _pcp4d, // 输入的pc + 4
   input [31:0] _inst, // 输入的inst
   output [31:0] rd1, // 从寄存器堆输出的第一个data
   output [31:0] rd2, // 从寄存器堆输出的第二个data
   output [31:0] imm_ext, // 扩展后的imm，在execute里选择到底用imm还是rd2放到alu里
   output [3:0]  aluOp, // alu做什么运算
   output        srcAlu, // 选择哪个是alu的操作数
   output reg [31:0] pcp4d, // 输出的pc + 4，这个和_pcp4d有一个周期的延迟
   // output [4:0] sa, // alu的偏移量
   output        regWriteEn, // 写入reg的使能
   output        memWriteEn, // 写入内存的使能
   // output        link, // 把pc_next写入$31，其实br unit可以放在decode里，不用等alu
   output [2:0]  jumpOp, // 给br unit，告诉它走哪种跳转
   output [1:0]  extendOp, // 符号扩展怎么扩展，据说有好几种
   output [1:0]  writeRegDst, // 写回哪个寄存器，rt还是rd还是$31——所以link可以消失了
   output [2:0]  srcReg // 貌似是写回的数据来源，选哪条路
   ) ;

   // TODO 寄存器堆需要的，暂时没写
   wire [ 4:0]   ra1;
   wire [ 4:0]   ra2;
   wire [ 4:0]   wa;
   wire          we;
   wire [31:0]   wd;

   reg [31:0] inst;

   always @(posedge clk) begin
      if (rst) begin
         inst <= 32'b0;
         pcp4d <= 32'b0;
      end else begin
         inst <= _inst;
         pcp4d <= _pcp4d;
      end
   end
  
   cu CU (.inst(inst),
          .jumpOp(jumpOp),  
          .extendOp(extendOp),  
          .regWriteEn(regWriteEn),  
          .memWriteEn(memWriteEn),  
          .aluOp(aluOp),  
          .writeRegDst(reg_wa),  
          .srcAlu(srcAlu),  
          .srcReg(srcReg),  
          .saveRetAddrEn(link));

   reg_file REG_FILE (.clk(clk),
                      .ra1(ra1),
                      .ra2(ra2),
                      .wa(wa),
                      .we(we),
                      .wd(wd),
                      .rd1(rd1),
                      .rd2(rd2));

endmodule // decode
