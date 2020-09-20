`timescale 1ns / 1ps

module fetch (
    input clk,
    input rst,
    input [31:0] _pc_jump,
    input _jump,
    input _stall,
    output [31:0] pcp4d,
    output [31:0] inst
);

  assign pcp4d = pc_now + 32'h4;

  wire [31:0] pc_now;

  reg [31:0] pc_jump;
  reg jump;

  always @(posedge clk) begin
    if (rst) begin
      jump <= 0;
    end else if (_stall) begin
      // 用上一周期的值
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
      .pc_next(jump ? pc_jump : pcp4d)
  );

  inst_mem INST_MEM (
      .clk (clk),
      .pc  (pc_now),
      .inst(inst)
  );

endmodule  // fetch
