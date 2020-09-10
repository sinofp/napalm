module inst_mem (
           input clk,
           input[31:0] pc,
           output[31:0] inst
       );

reg[7:0] mem[255:0];
initial begin
    $readmemb("xxx.txt", mem);
end

assign inst = {mem[pc], mem[pc+1], mem[pc+2], mem[pc+3]};
endmodule
