module control_unit (input [5:0] opcode,
                     output reg regdst,
							output reg jmp,
							output reg branch,
							output reg bne,
							output reg memread,
							output reg memtoreg,
							output reg [2:0] aluop,
							output reg memwrite,
							output reg alusrc,
							output reg regwrite,
							output reg zero_extend,
							output reg uses_rs,
							output reg uses_rt);

always @ (*) begin 
       case (opcode) 
		 6'h00: begin   //r-type
		    regdst = 1'b1;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b000;
			 memwrite = 1'b0;
			 alusrc = 1'b0;
			 regwrite = 1'b1;
			 zero_extend = 1'b0;
			 uses_rs = 1'b1;
			 uses_rt = 1'b1;
		 end
		 6'h1C: begin   //mul
		    regdst = 1'b1;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b111;
			 memwrite = 1'b0;
			 alusrc = 1'b0;
			 regwrite = 1'b1;
			 zero_extend = 1'b0;
			 uses_rs = 1'b1;
			 uses_rt = 1'b1;
		 end
		 6'h08: begin    //addi
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b001;
			 memwrite = 1'b0;
			 alusrc = 1'b1;
			 regwrite = 1'b1;
			 zero_extend = 1'b0;
			 uses_rs = 1'b1;
			 uses_rt = 1'b0;
		 end 
		 6'h0C: begin    // andi
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b010;
			 memwrite = 1'b0;
			 alusrc = 1'b1;
			 regwrite = 1'b1;
			 zero_extend = 1'b1;
			 uses_rs = 1'b1;
			 uses_rt = 1'b0;
		 end 
		 6'h0D: begin    // ori
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b011;
			 memwrite = 1'b0;
			 alusrc = 1'b1;
			 regwrite = 1'b1;
			 zero_extend = 1'b1;
			 uses_rs = 1'b1;
			 uses_rt = 1'b0;
		 end 
		 6'h0E: begin    // xori
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b100;
			 memwrite = 1'b0;
			 alusrc = 1'b1;
			 regwrite = 1'b1;
			 zero_extend = 1'b1;
			 uses_rs = 1'b1;
			 uses_rt = 1'b0;
		 end 
		 6'h0A: begin    // slti
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b101;
			 memwrite = 1'b0;
			 alusrc = 1'b1;
			 regwrite = 1'b1;
			 zero_extend = 1'b0;
			 uses_rs = 1'b1;
			 uses_rt = 1'b0;
		 end 
		 6'h23: begin    // lw
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b1;
			 memtoreg = 1'b1;
			 aluop = 3'b001;
			 memwrite = 1'b0;
			 alusrc = 1'b1;
			 regwrite = 1'b1;
			 zero_extend = 1'b0;
			 uses_rs = 1'b1;
			 uses_rt = 1'b0;
		 end 
		 6'h2B: begin    // SW
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b001;
			 memwrite = 1'b1;
			 alusrc = 1'b1;
			 regwrite = 1'b0;
			 zero_extend = 1'b0;
			 uses_rs = 1'b1;
			 uses_rt = 1'b1;
		 end 
		 6'h04: begin    // beq
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b1;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b110;
			 memwrite = 1'b0;
			 alusrc = 1'b0;
			 regwrite = 1'b0;
			 zero_extend = 1'b0;
			 uses_rs = 1'b1;
			 uses_rt = 1'b1;
		 end 
		 6'h05: begin    // bne
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b1;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b110;
			 memwrite = 1'b0;
			 alusrc = 1'b0;
			 regwrite = 1'b0;
			 zero_extend = 1'b0;
			 uses_rs = 1'b1;
			 uses_rt = 1'b1;
		 end 
		 6'h02: begin    // j
		    regdst = 1'b0;
			 jmp = 1'b1;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b000;
			 memwrite = 1'b0;
			 alusrc = 1'b0;
			 regwrite = 1'b0;
			 zero_extend = 1'b0;
			 uses_rs = 1'b0;
			 uses_rt = 1'b0;
		 end 
		 default: begin 
		    regdst = 1'b0;
			 jmp = 1'b0;
			 branch = 1'b0;
			 bne = 1'b0;
			 memread = 1'b0;
			 memtoreg = 1'b0;
			 aluop = 3'b000;
			 memwrite = 1'b0;
			 alusrc = 1'b0;
			 regwrite = 1'b0;
			 zero_extend = 1'b0;
			 uses_rs = 1'b0;
			 uses_rt = 1'b0;
		 end 
		 endcase
end
endmodule 