module Sign_Extend (
    input [15:0] in,
    output reg [31:0] out
);
always @(*) begin
    if (in[15] == 1'b1) begin
        out = {16'hFFFF, in}; 
    end else begin
        out = {16'h0000, in};
    end
end

endmodule