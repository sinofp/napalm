`timescale 1ns / 1ps
`include "def.vh"

module data_mem (
    input         clk,
    input  [31:0] _addr,  // 写入/读取的地址
    input  [31:0] _wd,  // write_data
    input         _we,  // write_enable
    input  [ 5:0] _opcode,
    output [31:0] rd  // read_data
);

  reg [7:0] mem[255:0];

  assign rd = (_opcode == `LB_OP)? {{24{mem[_addr][7]}}, mem[_addr]}: // load 8 位，符号扩展到 32 位
              (_opcode == `LH_OP)? {{16{mem[_addr+1][7]}}, mem[_addr+1], mem[_addr]}:
                                   {mem[_addr+3], mem[_addr+2], mem[_addr+1], mem[_addr]};

  always @(posedge clk) begin
    if (_we) begin
      mem[_addr+3] <= (_opcode == `LB_OP)? {8{_wd[7]}}: (_opcode == `LH_OP)? {8{_wd[15]}}: _wd[31:24];
      mem[_addr+2] <= (_opcode == `LB_OP)? {8{_wd[7]}}: (_opcode == `LH_OP)? {8{_wd[15]}}: _wd[23:16];
      mem[_addr+1] <= (_opcode == `LB_OP) ? {8{_wd[7]}} : _wd[15:8];
      mem[_addr] <= _wd[7:0];
    end
  end
endmodule  // data_mem
