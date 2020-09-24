module dcm (
    input _clk,
    output reg clk
);
    initial begin
        clk = 0;
    end

    reg [22:0] cnt;

    always @(posedge _clk) begin
        if (cnt == {22{1'b1}}) begin
            clk <= ~ clk;
            cnt <= 0;
        end else begin
            cnt <= cnt + 22'b1;
        end
    end
endmodule