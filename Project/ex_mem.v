module ex_mem (
         //control
			input wire branch_ex,
			input wire bne_ex,
			input wire memread_ex,
			input wire memtoreg_ex,
			input wire memwrite_ex,
			input wire regwrite_ex,
			
			//data
			input wire	[31:0] branch_offset_ex,
			input wire zero_ex,
			input wire	[31:0] alu_result_ex,
			input wire	[31:0] rt_REG_ex,
			input wire	[4:0] rd_REG_ex,
			
		   //clock
			input wire	clk,
			
         //control
			output reg branch_mem,
			output reg bne_mem,
			output reg memread_mem,
			output reg memtoreg_mem,
			output reg memwrite_mem,
			output reg regwrite_mem,
			
			//data
			output reg	[31:0] branch_offset_mem,
			output reg zero_mem,
			output reg	[31:0] alu_result_mem,
			output reg	[31:0] rt_REG_mem,
			output reg	[4:0] rd_REG_mem
			);
			
			
always @(posedge clk)
begin
	       //control

			 branch_mem <= branch_ex;
			 bne_mem <= bne_ex;
			 memread_mem <= memread_ex;
			 memtoreg_mem <= memtoreg_ex;
			 memwrite_mem <= memwrite_ex;
			 regwrite_mem <= regwrite_ex;
			
			//data
			 branch_offset_mem <= branch_offset_ex; 
			 zero_mem <= zero_ex;
			 alu_result_mem <= alu_result_ex;
			 rt_REG_mem <= rt_REG_ex;
			 rd_REG_mem <= rd_REG_ex;

end
endmodule 