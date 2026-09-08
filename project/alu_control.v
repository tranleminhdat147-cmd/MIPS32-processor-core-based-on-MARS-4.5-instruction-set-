module alu_control (
    input  [2:0] alu_op,   
    input  [5:0] funct,    
    output reg [5:0] alu_out 
);

    always @(*) begin
        case (alu_op)
            3'b000:  alu_out = funct;  
            3'b001:  alu_out = 6'h20;  
            3'b010:  alu_out = 6'h24;  
            3'b011:  alu_out = 6'h25;  
            3'b100:  alu_out = 6'h26;  
            3'b101:  alu_out = 6'h2A;  
            3'b110:  alu_out = 6'h22;  
            3'b111:  alu_out = 6'h03;  
            default: alu_out = 6'h20;  
        endcase
    end

endmodule