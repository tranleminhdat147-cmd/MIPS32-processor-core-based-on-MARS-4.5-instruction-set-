module mem_wb (
         //control
			input wire memtoreg_mem,
			input wire regwrite_mem,
			
			//data
			input wire	[31:0] dmem_data_mem,
			input wire	[31:0] alu_result_mem,
			input wire	[4:0] rd_REG_mem,
			
		   //clock
			input wire	clk,
			
         //control
			output reg memtoreg_wb,
			output reg regwrite_wb,
			
			//data
			output reg	[31:0] dmem_data_wb,
			output reg	[31:0] alu_result_wb,
			output reg	[4:0] rd_REG_wb
			);
			
			
always @(posedge clk)
begin
	       //control
			 memtoreg_wb <= memtoreg_mem;
			 regwrite_wb <= regwrite_mem;
			
			//data
			 dmem_data_wb <= dmem_data_mem; 
			 alu_result_wb <= alu_result_mem;
			 rd_REG_wb <= rd_REG_mem;

end
endmodule 