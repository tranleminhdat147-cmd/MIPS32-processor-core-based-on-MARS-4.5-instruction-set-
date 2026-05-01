module EXU (
    input [31:0] a,
    input [31:0] b,
    input [4:0]  shamt,
    input [5:0]  alu_control,
    output       zero,
    output [31:0] result
);
    wire [31:0] alu_result;
    wire [31:0] div_result;
    wire zero_alu;

    wire is_div = (alu_control == 6'h1A); 

    alu alu0 (
        .a(a),
        .b(b),
        .shamt(shamt),
        .alu_control(alu_control),
        .zero(zero_alu),
        .alu_result(alu_result)
    );

    comb_div div_inst (
        .a(a),  
        .b(b),
        .quotient(div_result)
    );

    assign result = is_div ? div_result : alu_result;
    assign zero   = zero_alu; 

endmodule