`timescale 1ns / 1ps

module fetch (
    input clk,
    input rst,
    output [31:0] pcp4d,
    output [31:0] inst
);

  assign pcp4d = pc_now + 32'h4;

  wire [31:0] pc_now, pc_next;  // TODO pcnext逻辑，当然还有冲刷流水线

  pc PC (
      .clk(clk),
      .rst(rst),
      .pc_now(pc_now),
      .pc_next(pc_next)
  );

  inst_mem INST_MEM (
      .clk (clk),
      .pc  (pc_now),
      .inst(inst)
  );

endmodule  // fetch
