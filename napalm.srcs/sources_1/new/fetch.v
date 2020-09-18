module fetch (/*AUTOARG*/
   // Outputs
   pcp4d, inst,
   // Inputs
   clk, rst
   ) ;
   input  clk, rst;
   output [31:0] pcp4d = pc_now + 32'h4;
   output [31:0] inst;

   wire [31:0]   pc_now, pc_next;

   pc PC (.clk(clk), .rst(rst), .pc_now(pc_now), .pc_next(pc_next));

   inst_mem INST_MEM(.clk(clk), .pc(pc_now), inst(inst));
   
endmodule // fetch
