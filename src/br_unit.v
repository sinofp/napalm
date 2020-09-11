`timescale 1ns / 1ps
module br_unit (
           input[31:0] pc,
           input[25:0] instr_index,
           input[15:0] offset,
           input[31:0] rd1,
           input[31:0] rd2,
           input cu_jump,
           input cu_beq,
           output[31:0] pc_next
       );
assign pc_next = cu_jump? {pc[31:28], instr_index, 2'b0}:
       pc + ((cu_beq & rd1 == rd2)? {{14{offset[15]}}, offset, 2'b0} : 32'h4);
endmodule
