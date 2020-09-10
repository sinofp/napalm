module pc (
           input clk,
           input rst_n,
           input[31:0] pc_next,
           output reg[31:0] pc_now
       );

always @(posedge clk) begin
    if (rst_n) begin
        pc_now <= 32'b0;
    end
    else begin
        pc_now <= pc_next;
    end
end
endmodule
