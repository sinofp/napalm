`timescale 1ns / 1ps


module alu (
    input [31:0] num1,
    input [31:0] num2,
	input [4:0] sa,
    output [31:0] res,
    output overflow
);


reg[32:0] alu_reg;
assign res = alu_reg[31:0];

always @ (*) begin
    case (aluOp)
        `ALU_OP_PLUS:// +
            alu_reg <= num1 + num2;
			if((num1 >= 0) && (num2 >= 0) && (alu_reg < 0)) overflow <= 1'b1;
			else if((a_in < 0) && (b_in < 0) && (res_out >= 0)) overflow <= 1'b1;
			else overflow <= 1'b0;// no overflow
        `ALU_OP_AND://&
            alu_reg <= num1 & num2;
        `ALU_OP_DIV:// /
            alu_reg <= num1 / num2;
			if(num2 == 0) overflow <= 1'b1;
			else if((num1 >= 0) && (num2 < 0) && (alu_reg > 0)) o <= 1'b1;
			else if((num1 < 0) && (num2 > 0) && (alu_reg >= 0)) overflow <= 1'b1;
			else if((num1 <= 0) && (num2 < 0) && (alu_reg < 0)) overflow <= 1'b1;
			else if((num1 >= 0) && (num2 > 0) && (alu_reg < 0)) overflow <= 1'b1;
			else overflow <= 1'b0;// no overflow
        `ALU_OP_MULT://*
            alu_reg <= num1 * num2;
			if((num1 >= 0) && (num2 < 0) && (alu_reg > 0)) o <= 1'b1;
			else if((num1 < 0) && (num2 >= 0) && (alu_reg > 0)) overflow <= 1'b1;
			else if((num1 <= 0) && (num2 <= 0) && (alu_reg < 0)) overflow <= 1'b1;
			else if((num1 >= 0) && (num2 >= 0) && (alu_reg < 0)) overflow <= 1'b1;
			else overflow <= 1'b0;// no overflow
        `ALU_OP_OR:// |
            alu_reg <= num1 | num2;
        `ALU_OP_SLL:// <<
            alu_reg <= num1 << sa;// logic
		`ALU_OP_SLLV:// shift left logical variable
            alu_reg <= num2 << num1[4:0];// logic
        `ALU_OP_SLT:// set on less than
            y <= (data1 < data2) ? 1 : 0;
        `ALU_OP_SRA:// >>
            alu_reg <= num2 >>> sa;// arithmetic	Result = ($signed(operandB)) >>> operandA
        `ALU_OP_SRL:// >>
            alu_reg <= num2 >> sa;// logic
        `ALU_OP_SRLV:// shift right logical variable
            alu_reg <= num2 << num1[4:0];// logic
        `ALU_OP_MINUS:// -
            alu_reg <= num1 - num2;
			if((num1 >= 0) && (num2 < 0) && (alu_reg < 0)) o <= 1'b1;
			else if((num1 < 0) && (num2 > 0) && (alu_reg >= 0)) overflow <= 1'b1;
			else overflow <= 1'b0;// no overflow
        `ALU_OP_XOR:// xor
            alu_reg <= num1 ^ num2;
        `ALU_OP_NOR:// nor
            alu_reg <= ~(num1 | num2);

        `ALU_OP_DEFAULT:
            alu_reg <= {num2[31], num2};
    endcase
end



endmodule