module adder #(
    parameter N = 32
)(
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    input  wire         CIN,
    output wire [N-1:0] SUM,
    output wire         COUT
);

assign {COUT, SUM} = A + B + CIN;

endmodule