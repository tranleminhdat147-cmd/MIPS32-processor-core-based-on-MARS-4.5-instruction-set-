module branch_selector (input wire branch_mem,
                        input wire bne_mem,
					         input wire zero_mem,
					         output wire branch_sel);
								
assign branch_sel = (branch_mem & zero_mem) | (~zero_mem & bne_mem);

endmodule