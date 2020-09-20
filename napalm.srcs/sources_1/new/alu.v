`timescale 1ns / 1ps
//`include "def.vh"

`define ALU_OP_DEFAULT 4'b0000 		// Default
`define ALU_OP_PLUS 4'b0001 		// +
`define ALU_OP_AND 4'b0010 		// &
`define ALU_OP_DIV 4'b0011 		// / and %
`define ALU_OP_MULT 4'b0100 		// *
`define ALU_OP_OR 4'b0101 		// |
`define ALU_OP_SLL 4'b0110 		// <<
`define ALU_OP_SLT 4'b0111 		// set on less than
`define ALU_OP_SRA 4'b1000 		// >>
`define ALU_OP_SRL 4'b1001 		// >>
`define ALU_OP_SRLV 4'b1010 		// shift right logical variable
`define ALU_OP_MINUS 4'b1011 		// -
`define ALU_OP_XOR 4'b1100 		// xor
`define ALU_OP_NOR 4'b1101 		// nor
`define ALU_OP_SLLV 4'b1110 		// shift left logical variable

module alu (
    input [31:0] num1,
    input [31:0] num2,
	input [4:0] sa,
	input [3:0] aluOp,
    output [31:0] res,
    output reg overflow
);


reg[32:0] alu_reg;
reg[32:0] alu_hi;
reg[32:0] alu_lo;
assign res = alu_reg[31:0];
assign hi = alu_hi[31:0];//for DIV, MULT
assign lo = alu_lo[31:0];//32 bits

always @ (*) begin
    case (aluOp)
        `ALU_OP_PLUS:// +
		begin
            alu_reg <= num1 + num2;
			if((num1 >= 0) && (num2 >= 0) && (alu_reg < 0))
			begin
				overflow <= 1'b1;
			end
			else if((num1 < 0) && (num2 < 0) && (alu_reg >= 0))
			begin
				overflow <= 1'b1;
			end
			else
			begin
				overflow <= 1'b0;// no overflow
			end
		end
        `ALU_OP_AND://&
            alu_reg <= num1 & num2;

	    `ALU_OP_DIV:// / %
		begin
			begin
				alu_hi <= num1 % num2;
			end
			begin
				alu_lo <= num1 / num2;
			end
				if(num2 == 0)
				begin
					overflow <= 1'b1;
				end
				else if((num1 >= 0) && (num2 < 0) && (alu_hi > 0))
				begin
					overflow <= 1'b1;
				end
				else if((num1 < 0) && (num2 > 0) && (alu_hi >= 0))
				begin
					overflow <= 1'b1;
				end
				else if((num1 <= 0) && (num2 < 0) && (alu_hi < 0))
				begin
					overflow <= 1'b1;
				end
				else if((num1 >= 0) && (num2 > 0) && (alu_hi < 0))
				begin
					overflow <= 1'b1;
				end
				
				else if((num1 >= 0) && (num2 < 0) && (alu_lo > 0))
				begin
					overflow <= 1'b1;
				end
				else if((num1 < 0) && (num2 > 0) && (alu_lo >= 0))
				begin
					overflow <= 1'b1;
				end
				else if((num1 <= 0) && (num2 < 0) && (alu_lo < 0))
				begin
					overflow <= 1'b1;
				end
				else if((num1 >= 0) && (num2 > 0) && (alu_lo < 0))
				begin
					overflow <= 1'b1;
				end
				
				else
				begin
					overflow <= 1'b0;// no overflow
				end
		end

        `ALU_OP_MULT://*
        begin
            {alu_hi[31:0],alu_lo[31:0]} <= num1 * num2;
            if((num1 >= 0) && (num2 < 0) && ({alu_hi[31:0],alu_lo[31:0]} > 0))
            begin
				overflow <= 1'b1;
			end
			
			else if((num1 < 0) && (num2 >= 0) && ({alu_hi[31:0],alu_lo[31:0]} > 0))
			begin
				overflow <= 1'b1;
			end
			
			else if((num1 <= 0) && (num2 <= 0) && ({alu_hi[31:0],alu_lo[31:0]} < 0))
			begin
				overflow <= 1'b1;
			end
			
			else if((num1 >= 0) && (num2 >= 0) && ({alu_hi[31:0],alu_lo[31:0]} < 0))
			begin
				overflow <= 1'b1;
			end
			
			else
			begin
				overflow <= 1'b0;// no overflow
			end
		end
        `ALU_OP_OR:// |
            alu_reg <= num1 | num2;
        `ALU_OP_SLL:// <<
            alu_reg <= num1 << sa;// logic
		`ALU_OP_SLLV:// shift left logical variable
            alu_reg <= num2 << num1[4:0];// logic
        `ALU_OP_SLT:// set on less than
            alu_reg <= (num1 < num2) ? 1 : 0;
        `ALU_OP_SRA:// >>
            alu_reg <= num2 >>> sa;// arithmetic	Result = ($signed(operandB)) >>> operandA
        `ALU_OP_SRL:// >>
            alu_reg <= num2 >> sa;// logic
        `ALU_OP_SRLV:// shift right logical variable
            alu_reg <= num2 << num1[4:0];// logic
        `ALU_OP_MINUS:// -
        begin
            alu_reg <= num1 - num2;
			if((num1 >= 0) && (num2 < 0) && (alu_reg < 0))
			begin
				overflow <= 1'b1;
			end
			else if((num1 < 0) && (num2 > 0) && (alu_reg >= 0))
			begin
				overflow <= 1'b1;
			end
			else
			begin
				overflow <= 1'b0;// no overflow
			end
        end
        `ALU_OP_XOR:// xor
            alu_reg <= num1 ^ num2;
        `ALU_OP_NOR:// nor
            alu_reg <= ~(num1 | num2);

        `ALU_OP_DEFAULT:
            alu_reg <= {num2[31], num2};
    endcase
end



endmodule
