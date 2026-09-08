module flush (input wire jump_id,
              input wire branch_sel,
				  output wire flush_ifid,
				  output wire flush_idex,
				  output wire flush_exmem);

assign flush_ifid = jump_id | branch_sel;
assign flush_idex = branch_sel;
assign flush_exmem = branch_sel;

endmodule