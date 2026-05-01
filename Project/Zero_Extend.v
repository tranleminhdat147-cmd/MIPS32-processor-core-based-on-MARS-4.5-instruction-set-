module Zero_Extend (
    input [15:0] in,
    output reg [31:0] out
);

always @(*) begin
    out = {16'h0000, in}; 
end

endmodule