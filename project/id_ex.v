module id_ex (
         //control
         input wire regdst_id,
			input wire branch_id,
			input wire bne_id,
			input wire memread_id,
			input wire memtoreg_id,
			input wire [2:0] aluop_id,
			input wire memwrite_id,
			input wire alusrc_id,
			input wire regwrite_id,
			
			//data
			input wire	[31:0] branch_offset_id,
			input wire	[31:0] rs_REG_id,
			input wire	[31:0] rt_REG_id,
			input wire	[31:0] imm_id,
			input wire  [4:0] shamt_id,
			input wire	[4:0] rt_mux_id,
			input wire	[4:0] rd_mux_id,
			
			//clk, stall, flush
			input wire	Stall,
			input wire	flush_IDEX,
			input wire	clk,
			
         //control
			output reg regdst_ex,
			output reg branch_ex,
			output reg bne_ex,
			output reg memread_ex,
			output reg memtoreg_ex,
			output reg [2:0] aluop_ex,
			output reg memwrite_ex,
			output reg alusrc_ex,
			output reg regwrite_ex,
			
			//data
			output reg	[31:0] branch_offset_ex,
			output reg	[31:0] rs_REG_ex,
			output reg	[31:0] rt_REG_ex,
			output reg	[31:0] imm_ex,
			output reg  [4:0] shamt_ex,
			output reg	[4:0] rt_mux_ex,
			output reg	[4:0] rd_mux_ex
			);
			
			
always @(posedge clk)
begin
    if (flush_IDEX || Stall)
    begin
        	 regdst_ex <= 0;
			 branch_ex <= 0;
			 bne_ex <= 0;
			 memread_ex <= 0;
			 memtoreg_ex <= 0;
			 aluop_ex <= 0;
			 memwrite_ex <= 0;
			 alusrc_ex <= 0;
			 regwrite_ex <= 0;

        branch_offset_ex <= 0;
        rs_REG_ex        <= 0;
        rt_REG_ex        <= 0;
        imm_ex           <= 0;
        shamt_ex         <= 0;
        rt_mux_ex        <= 0;
        rd_mux_ex        <= 0;
    end
    else 
    begin
	       //control
			 regdst_ex <= regdst_id; 
			 branch_ex <= branch_id;
			 bne_ex <= bne_id;
			 memread_ex <= memread_id;
			 memtoreg_ex <= memtoreg_id;
			 aluop_ex <= aluop_id;
			 memwrite_ex <= memwrite_id;
			 alusrc_ex <= alusrc_id;
			 regwrite_ex <= regwrite_id;
			
			//data
			 branch_offset_ex <= branch_offset_id;
			 rs_REG_ex <= rs_REG_id;
			 rt_REG_ex <= rt_REG_id;
			 imm_ex <= imm_id;
			 shamt_ex <= shamt_id;
			 rt_mux_ex <= rt_mux_id;
			 rd_mux_ex <= rd_mux_id;

    end
end
endmodule 