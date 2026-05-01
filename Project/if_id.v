module if_id (input wire [31:0] address_jump_IF,
              input wire [31:0] address_branch_IF,
              input wire [31:0] instr_IF, 
				  input wire Stall,
				  input wire flush_IFREG,
				  input clk,
				  output reg [31:0] address_jump_ID,
				  output reg [31:0] address_branch_ID,
				  output reg [31:0] instr_ID);
				  
always @ (posedge clk) begin
       if (flush_IFREG) begin
		     address_branch_ID <= 0;
			  instr_ID <= 0;
			  address_jump_ID <= 0;
		 end
		 else if (!Stall) begin
		     address_branch_ID <= address_branch_IF;
			  instr_ID <= instr_IF;
		     address_jump_ID <= {6'b0, address_jump_IF [25:0]};
		 end
end

endmodule