`timescale 1ns / 1ps

module fetch (
    input clk,
    input rst,
    input [31:0] _pc_jump,
    input _jump,
    input _stall,
    output [31:0] pcp4,
    output [31:0] inst
);
  wire [31:0] pc_now;
  assign pcp4 = pc_now + 32'h4;

  reg [31:0] pc_jump;
  reg jump;

  always @(posedge clk) begin
    if (rst) begin
      jump <= 0;
    end else if (_stall) begin
      // 用上�?周期的�??
      pc_jump <= pc_jump;
      jump <= jump;
    end else begin
      pc_jump <= _pc_jump;
      jump <= _jump;
    end
  end

  pc PC (
      .clk(clk),
      .rst(rst),
      .pc_now(pc_now),
      .pc_next(_stall ? pc_now : jump ? pc_jump : pcp4)
  );

  inst_mem INST_MEM (
      .clk (clk),
      .pc  (pc_now),
      .inst(inst)
  );

endmodule  // fetch
