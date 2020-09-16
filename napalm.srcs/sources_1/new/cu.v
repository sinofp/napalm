`timescale 1ns / 1ps


module cu(
           input[31:0] inst
       );
wire [5:0]         opcode = inst[31:26];

wire rtype = opcode == 6'b0;
wire jtype = opcode == 6'h2 | opcode == 6'h3;
wire itype = ~ (rtype | jtype);

endmodule
