module PC (input wire [31:0]in,
           input wire clk,
			  input wire Stall,
			  output reg [31:0]out);

always @ (posedge clk) begin
       if (!Stall) begin
		     out <= in;
		 end
end

endmodule 