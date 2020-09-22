`timescale 1ns / 1ps
`include "def.vh"


module alu (
    input [31:0] _num1,
    input [31:0] _num2,
    input [3:0] _alu_op,
    output [31:0] alu_res,
    output reg overflow
);


  reg [32:0] alu_reg;
  //reg[32:0] alu_hi;
  //reg[32:0] alu_lo;
  assign alu_res = alu_reg[31:0];
  //assign hi = alu_hi[31:0];//for DIV, MULT
  //assign lo = alu_lo[31:0];//32 bits

  wire [4:0] _sa;
  assign _sa = _num1[4:0];
  always @(*) begin
    case (_alu_op)
      `ALU_OP_PLUS:// +
		begin
        alu_reg <= _num1 + _num2;
        if (alu_reg < 0) begin
          overflow <= 1'b1;
        end else begin
          overflow <= 1'b0;  // no overflow
        end
      end
      `ALU_OP_AND://&
			alu_reg <= _num1 & _num2;
      /*	    `ALU_OP_DIV:// / %
		begin
			begin
				alu_hi <= _num1 % _num2;
			end
			begin
				alu_lo <= _num1 / _num2;
			end
				if(_num2 == 0)
				begin
					overflow <= 1'b1;
				end
				else if((_num1 >= 0) && (_num2 < 0) && (alu_hi > 0))
				begin
					overflow <= 1'b1;
				end
				else if((_num1 < 0) && (_num2 > 0) && (alu_hi >= 0))
				begin
					overflow <= 1'b1;
				end
				else if((_num1 <= 0) && (_num2 < 0) && (alu_hi < 0))
				begin
					overflow <= 1'b1;
				end
				else if((_num1 >= 0) && (_num2 > 0) && (alu_hi < 0))
				begin
					overflow <= 1'b1;
				end
				
				else if((_num1 >= 0) && (_num2 < 0) && (alu_lo > 0))
				begin
					overflow <= 1'b1;
				end
				else if((_num1 < 0) && (_num2 > 0) && (alu_lo >= 0))
				begin
					overflow <= 1'b1;
				end
				else if((_num1 <= 0) && (_num2 < 0) && (alu_lo < 0))
				begin
					overflow <= 1'b1;
				end
				else if((_num1 >= 0) && (_num2 > 0) && (alu_lo < 0))
				begin
					overflow <= 1'b1;
				end
				
				else
				begin
					overflow <= 1'b0;// no overflow
				end
		end
        `ALU_OP_MULT://
        begin
            {alu_hi[31:0],alu_lo[31:0]} <= _num1 * _num2;
            if((_num1 >= 0) && (_num2 < 0) && ({alu_hi[31:0],alu_lo[31:0]} > 0))
            begin
				overflow <= 1'b1;
			end
			
			else if((_num1 < 0) && (_num2 >= 0) && ({alu_hi[31:0],alu_lo[31:0]} > 0))
			begin
				overflow <= 1'b1;
			end
			
			else if((_num1 <= 0) && (_num2 <= 0) && ({alu_hi[31:0],alu_lo[31:0]} < 0))
			begin
				overflow <= 1'b1;
			end
			
			else if((_num1 >= 0) && (_num2 >= 0) && ({alu_hi[31:0],alu_lo[31:0]} < 0))
			begin
				overflow <= 1'b1;
			end
			
			else
			begin
				overflow <= 1'b0;// no overflow
			end
		end
*/

      `ALU_OP_OR:// |
            alu_reg <= _num1 | _num2;
      `ALU_OP_SLL:// <<
            alu_reg <= _num2 << _sa;// logic
      `ALU_OP_SLLV:// shift left logical variable
            alu_reg <= _num2 << _sa;// logic
      `ALU_OP_SLTU:// set on less than
            alu_reg <= (_num1 < _num2) ? 1 : 0;
      `ALU_OP_SRA:// >>
            alu_reg <= _num2 >>> _sa;// arithmetic	alu_result = ($signed(operandB)) >>> operandA
      `ALU_OP_SRL:// >>
            alu_reg <= _num2 >> _sa;// logic
      `ALU_OP_SRLV:// shift right logical variable
            alu_reg <= _num2 >> _sa;// logic
      `ALU_OP_MINUS:// -
        begin
        alu_reg <= _num1 - _num2;
        if ((_num1 >= 0) && (_num2 < 0) && (alu_reg < 0)) begin
          overflow <= 1'b1;
        end else if ((_num1 < 0) && (_num2 > 0) && (alu_reg >= 0)) begin
          overflow <= 1'b1;
        end else begin
          overflow <= 1'b0;  // no overflow
        end
      end
      `ALU_OP_XOR:// xor
            alu_reg <= _num1 ^ _num2;
      `ALU_OP_NOR:// nor
            alu_reg <= ~(_num1 | _num2);


	  //add SLTI,SLTIU
	  //传入的_imm 为 (低16位扩展而来的32位的立即数)
      `ALU_OP_SLT:// 有符号比较 rt <- rs < imm   rs中的值与扩展后的立即数imm比较 结果放入rt中
            begin
			case({_num2[31],_num1[31]})
			2'b01:// _imm 为正 _num1 为负
				begin
				alu_reg <= 1;
				end
			2'b10:// _imm 为负 _num1 为正
				begin
				alu_reg <= 0;
				end
			2'b00:// _imm,_num1 均为正,比较后31位
				begin
					if(_num2[30:0] >= _num1[30:0])
					begin
						alu_reg <= 1;
					end
					else
					begin
						alu_reg <= 0;
					end
				end
			2'b11:// _imm,_num1 均为负,比较后31位
				begin
					if(_num2[30:0] >= _num1[30:0])
					begin
						alu_reg <= 1;
					end
					else
					begin
						alu_reg <= 0;
					end
				end
			endcase
			end
    //   `ALU_OP_SLTIU:// 无符号比较 rt <- rs < imm   rs中的值与扩展后的立即数imm比较 结果放入rt中
    //         alu_reg <= (_num2 > _num1) ? 1 : 0;
      `ALU_OP_DEFAULT: alu_reg <= {_num2[31], _num2};
    endcase
  end



endmodule
