`timescale 1ns / 1ps
module br_unit (
           input clk,
           input rst_n,
           input[31:0] pc,
           input[25:0] instr_index,
           input[15:0] offset,
           input[31:0] rd1,
           input[31:0] rd2,
           input cu_jump,
           input cu_beq,
           output[31:0] pc_next
       );

reg[31:0] jump_hint;
always @(posedge clk) begin
    if (~rst_n) begin
        jump_hint <= {32{1'b1}}; // `INST_NUM小于32个1，所以这个处置必定是正常跳转无法达到的
    end
    else if (cu_jump) begin
        jump_hint <= {pc[31:28], instr_index, 2'b0};
    end
    else if (cu_beq & rd1 == rd2) begin
        jump_hint <= pc + 4 + {{14{offset[15]}}, offset, 2'b0};
    end
    else if (~ cu_beq) begin
        jump_hint <= {32{1'b1}}; // 如果既不是beq也不是jump，给jump_hint设不可能的值
    end
end

assign pc_next = (jump_hint != {32{1'b1}})? jump_hint : pc + 4;
endmodule
