// -------------------------------------------------------------------------
// Module: mip_datapath (Word-Indexed with full Debug Ports)
// -------------------------------------------------------------------------

module mip_datapath(
    input  wire        clk,
    
    // --- Stage Monitoring (The "Must-Haves" for Debugging) ---
    output wire [7:0]  Address_IF,      // Current PC
    output wire [31:0] instruct_ID,     // Instruction in Decode
    output wire [31:0] rs_data_ID,      // Register File Out 1
    output wire [31:0] rt_data_ID,      // Register File Out 2
    output wire [31:0] IMM_ID,          // Extended Immediate (Sign or Zero)
    
    // --- Hazard & Control Status ---
    output wire        Stall,           
    output wire        Flush_idex,      
    output wire        Flush_ifid,      
    output wire        BRANCH_SEL,      
    output wire        JUMP_ID,         

    // --- Execution Details ---
    output wire [31:0] A_ALU_EX,        
    output wire [31:0] B_ALU_EX,        
    output wire        ZERO_EX,         

    // --- Memory & Write-Back ---
    output wire [31:0] alu_result_MEM,  // Address sent to Data Memory
    output wire [31:0] dmem_data_MEM,   // RAW data coming OUT of Data Memory
    output wire [31:0] alu_result_WB,   // Final data written to RegFile
    output wire [4:0]  rd_REG_WB,       
    output wire        regwrite_WB      
);

    // -------------------------------------------------------------------------
    // F: INSTRUCTION FETCH
    // -------------------------------------------------------------------------
    wire [31:0] pc_next, pc_current, pc_plus_1_if, instr_if;

    PC U_PC_REG (
        .clk(clk), .Stall(Stall), .in(pc_next), .out(pc_current)
    );

    IMEM U_INSTRUCTION_MEM (
        .addr(pc_current[7:0]), .q(instr_if)
    );

    assign pc_plus_1_if = pc_current + 32'd1;

    // -------------------------------------------------------------------------
    // D: INSTRUCTION DECODE
    // -------------------------------------------------------------------------
    wire [31:0] instr_id, pc_plus_1_id, rs_data_id, rt_data_id, imm_id_sign, imm_id_zero, imm_id_final;
    wire [31:0] jump_target_id;
    wire [2:0]  aluop_id;
    wire        regdst_id, jmp_id, branch_id, bne_id, memread_id, memtoreg_id, memwrite_id, alusrc_id, regwrite_id, zero_ext_id, uses_rs_id, uses_rt_id;

    if_id U_IF_ID_REG (
        .clk(clk), .Stall(Stall), .flush_IFREG(Flush_ifid),
        .instr_IF(instr_if), .address_branch_IF(pc_plus_1_if),
        .instr_ID(instr_id), .address_branch_ID(pc_plus_1_id)
    );

    control_unit U_CONTROL (
        .opcode(instr_id[31:26]), .regdst(regdst_id), .jmp(jmp_id), .branch(branch_id), 
        .bne(bne_id), .memread(memread_id), .memtoreg(memtoreg_id), .memwrite(memwrite_id), 
        .alusrc(alusrc_id), .regwrite(regwrite_id), .zero_extend(zero_ext_id),
        .uses_rs(uses_rs_id), .uses_rt(uses_rt_id), .aluop(aluop_id)
    );

    Register_File U_REG_FILE (
        .clk(clk), .ReadWrite(regwrite_WB),
        .ReadAddress1(instr_id[25:21]), .ReadAddress2(instr_id[20:16]),
        .WriteAddress(rd_REG_WB), .WriteData(alu_result_WB),
        .ReadData1(rs_data_id), .ReadData2(rt_data_id)
    );

    Stall U_HAZARD_UNIT (
        .RegWrite_EX(regwrite_ex), .RegWrite_MEM(regwrite_mem),
        .rd_EX(rd_REG_ex), .rd_MEM(rd_REG_mem),
        .rs_ID(instr_id[25:21]), .rt_ID(instr_id[20:16]),
        .uses_rs(uses_rs_id), .uses_rt(uses_rt_id), .Stall(Stall)
    );

    Sign_Extend U_SIGN_EXT (.in(instr_id[15:0]), .out(imm_id_sign));
    assign imm_id_zero  = {16'b0, instr_id[15:0]};
    assign imm_id_final = zero_ext_id ? imm_id_zero : imm_id_sign;
    
    assign jump_target_id = {pc_plus_1_id[31:26], instr_id[25:0]};

    // -------------------------------------------------------------------------
    // E: EXECUTE
    // -------------------------------------------------------------------------
    wire [31:0] a_alu_ex, b_alu_ex_pre, b_alu_ex_final, imm_ex, pc_plus_1_ex, branch_target_ex, alu_result_ex;
    wire [4:0]  rt_mux_ex, rd_mux_ex, rd_REG_ex, shamt_ex;
    wire [2:0]  aluop_ex;
    wire [5:0]  alu_control_signal;
    wire        zero_ex, alusrc_ex, regdst_ex, regwrite_ex, memtoreg_ex, memwrite_ex, memread_ex, branch_ex, bne_ex;

    id_ex U_ID_EX_REG (
        .clk(clk), .Stall(Stall), .flush_IDEX(Flush_idex),
        .rs_REG_id(rs_data_id), .rt_REG_id(rt_data_id), .imm_id(imm_id_final),
        .rd_mux_id(instr_id[15:11]), .rt_mux_id(instr_id[20:16]), .shamt_id(instr_id[10:6]),
        .aluop_id(aluop_id), .alusrc_id(alusrc_id), .regdst_id(regdst_id), .regwrite_id(regwrite_id),
        .memread_id(memread_id), .memwrite_id(memwrite_id), .memtoreg_id(memtoreg_id),
        .branch_id(branch_id), .bne_id(bne_id), .branch_offset_id(pc_plus_1_id),
        
        .rs_REG_ex(a_alu_ex), .rt_REG_ex(b_alu_ex_pre), .imm_ex(imm_ex), 
        .rd_mux_ex(rd_mux_ex), .rt_mux_ex(rt_mux_ex), .shamt_ex(shamt_ex),
        .aluop_ex(aluop_ex), .alusrc_ex(alusrc_ex), .regdst_ex(regdst_ex), .regwrite_ex(regwrite_ex),
        .memread_ex(memread_ex), .memwrite_ex(memwrite_ex), .memtoreg_ex(memtoreg_ex),
        .branch_ex(branch_ex), .bne_ex(bne_ex), .branch_offset_ex(pc_plus_1_ex)
    );

    assign branch_target_ex = pc_plus_1_ex + imm_ex;

    alu_control U_ALU_CTRL ( .alu_op(aluop_ex), .funct(imm_ex[5:0]), .alu_out(alu_control_signal) );
    assign b_alu_ex_final = alusrc_ex ? imm_ex : b_alu_ex_pre;
    assign rd_REG_ex = regdst_ex ? rd_mux_ex : rt_mux_ex;

    alu U_ALU (
        .a(a_alu_ex), .b(b_alu_ex_final), .shamt(shamt_ex), .alu_control(alu_control_signal), 
        .zero(zero_ex), .alu_result(alu_result_ex)
    );

    // -------------------------------------------------------------------------
    // M: MEMORY
    // -------------------------------------------------------------------------
    wire [31:0] alu_result_mem_internal, rt_data_mem, branch_target_mem, dmem_data_mem_internal;
    wire [4:0]  rd_REG_mem;
    wire        zero_mem, regwrite_mem, memtoreg_mem, memwrite_mem, memread_mem, branch_mem, bne_mem;

    ex_mem U_EX_MEM_REG (
        .clk(clk), .zero_ex(zero_ex), .alu_result_ex(alu_result_ex), .rd_REG_ex(rd_REG_ex),
        .branch_offset_ex(branch_target_ex), .rt_REG_ex(b_alu_ex_pre),
        .regwrite_ex(regwrite_ex), .memtoreg_ex(memtoreg_ex), .memwrite_ex(memwrite_ex),
        .memread_ex(memread_ex), .branch_ex(branch_ex), .bne_ex(bne_ex),

        .zero_mem(zero_mem), .alu_result_mem(alu_result_mem_internal), .rd_REG_mem(rd_REG_mem),
        .branch_offset_mem(branch_target_mem), .rt_REG_mem(rt_data_mem),
        .regwrite_mem(regwrite_mem), .memtoreg_mem(memtoreg_mem), .memwrite_mem(memwrite_mem),
        .memread_mem(memread_mem), .branch_mem(branch_mem), .bne_mem(bne_mem)
    );

    branch_selector U_BRANCH_UNIT (
        .branch_mem(branch_mem), .bne_mem(bne_mem), .zero_mem(zero_mem), 
        .branch_sel(BRANCH_SEL)
    );

    Data_Memory U_DATA_MEM (
        .clk(clk), .mem_write(memwrite_mem), .mem_read(memread_mem),
        .address(alu_result_mem_internal), .write_data(rt_data_mem), .read_data(dmem_data_mem_internal)
    );

    // -------------------------------------------------------------------------
    // W: WRITE BACK
    // -------------------------------------------------------------------------
    wire [31:0] dmem_data_wb, alu_result_wb_internal;
    wire        memtoreg_wb;

    mem_wb U_MEM_WB_REG (
        .clk(clk), .alu_result_mem(alu_result_mem_internal), .dmem_data_mem(dmem_data_mem_internal), 
        .rd_REG_mem(rd_REG_mem), .regwrite_mem(regwrite_mem), .memtoreg_mem(memtoreg_mem),
        .alu_result_wb(alu_result_wb_internal), .dmem_data_wb(dmem_data_wb), .rd_REG_wb(rd_REG_WB),
        .regwrite_wb(regwrite_WB), .memtoreg_wb(memtoreg_wb)
    );

    assign alu_result_WB = memtoreg_wb ? dmem_data_wb : alu_result_wb_internal;

    // -------------------------------------------------------------------------
    // REDIRECTION & FLUSH
    // -------------------------------------------------------------------------
    assign pc_next = jmp_id      ? jump_target_id  : 
                     BRANCH_SEL  ? branch_target_mem : 
                                   pc_plus_1_if;

    flush U_FLUSH_UNIT (
        .jump_id(jmp_id), .branch_sel(BRANCH_SEL),
        .flush_ifid(Flush_ifid), .flush_idex(Flush_idex)
    );

    // --- ASSIGN DEBUG OUTPUTS ---
    assign Address_IF     = pc_current[7:0];
    assign instruct_ID    = instr_id;
    assign rs_data_ID     = rs_data_id;
    assign rt_data_ID     = rt_data_id;
    assign IMM_ID         = imm_id_final;   // FIXED: Re-added requested signal
    assign JUMP_ID        = jmp_id;
    assign A_ALU_EX       = a_alu_ex;
    assign B_ALU_EX       = b_alu_ex_final;
    assign ZERO_EX        = zero_ex;
    assign alu_result_MEM = alu_result_mem_internal;
    assign dmem_data_MEM  = dmem_data_mem_internal; // FIXED: Re-added requested signal

endmodule