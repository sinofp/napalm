`timescale 1ns / 1ps
module pc (
         input clk,
         input[31:0] pc_next,
         output[31:0] pc_now
       );

always @(posedge clk)
  begin
    pc_now <= pc_next;
  end

endmodule
