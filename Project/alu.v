module alu (
    input  [31:0] a,           
    input  [31:0] b,  
    input  [4:0] shamt,	 
    input  [5:0]  alu_control, 
	 output zero,
    output reg [31:0] alu_result
);

assign zero = (alu_result == 32'b0);

    always @(*) begin
        case (alu_control)
            6'h20: alu_result = a + b;          
            6'h22: alu_result = a - b;          
            6'h24: alu_result = a & b;          
            6'h25: alu_result = a | b;          
            6'h27: alu_result = ~(a | b);       
            6'h26: alu_result = a ^ b;          
            6'h2A: alu_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; 
            6'h00: alu_result = b << shamt;    
            6'h02: alu_result = b >> shamt;      
            6'h03: alu_result = $signed(a) * $signed(b);
            default: alu_result = 32'b0;
        endcase
    end

endmodule