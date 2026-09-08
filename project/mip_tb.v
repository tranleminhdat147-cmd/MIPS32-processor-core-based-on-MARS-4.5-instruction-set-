`timescale 1ns/1ps
// =============================================================================
// tb_mip_datapath
// =============================================================================
// Program: binary.txt (assembled by scratchpad/assemble_mips.py). Original
// binary.txt backed up at binary.txt.orig.bak.
//
//   0:  addi $1, $0, 5        $1 = 5
//   1:  addi $2, $0, 10       $2 = 10
//   2:  add  $3, $1, $2       $3 = 15
//   3:  sub  $4, $2, $1       $4 = 5
//   4:  and  $5, $1, $2       $5 = 0
//   5:  or   $6, $1, $2       $6 = 15
//   6:  xor  $7, $1, $2       $7 = 15
//   7:  slt  $8, $1, $2       $8 = 1
//   8:  sw   $3, 0($0)        MEM[0] = 15
//   9:  lw   $9, 0($0)        $9 = 15
//   10: beq  $3, $9, 2        taken -> target = 13
//   11: addi $10, $0, 999     wrong-path, flushed
//   12: addi $10, $0, 888     wrong-path, flushed
//   13: addi $11, $0, 42      branch target -> $11 = 42
//   14: j    16
//   15: addi $12, $0, 111     wrong-path, flushed
//   16: addi $12, $0, 222     jump target -> $12 = 222
//   17: lw   $13, 0($0)       $13 = 15
//   18: add  $14, $13, $13    load-use hazard -> $14 = 30
//   19-21: nop
// =============================================================================

module tb_mip_datapath;

    reg clk;

    wire [7:0]  Address_IF;
    wire [31:0] instruct_ID;
    wire [31:0] rs_data_ID;
    wire [31:0] rt_data_ID;
    wire [31:0] IMM_ID;

    wire        Stall;
    wire        Flush_idex;
    wire        Flush_ifid;
    wire        Flush_exmem;
    wire        BRANCH_SEL;
    wire        JUMP_ID;

    wire [31:0] A_ALU_EX;
    wire [31:0] B_ALU_EX;
    wire        ZERO_EX;

    wire [31:0] alu_result_MEM;
    wire [31:0] dmem_data_MEM;
    wire [31:0] alu_result_WB;
    wire [4:0]  rd_REG_WB;
    wire        regwrite_WB;

    mip_datapath U_DUT (
        .clk           (clk),
        .Address_IF    (Address_IF),
        .instruct_ID   (instruct_ID),
        .rs_data_ID    (rs_data_ID),
        .rt_data_ID    (rt_data_ID),
        .IMM_ID        (IMM_ID),
        .Stall         (Stall),
        .Flush_idex    (Flush_idex),
        .Flush_ifid    (Flush_ifid),
        .Flush_exmem   (Flush_exmem),
        .BRANCH_SEL    (BRANCH_SEL),
        .JUMP_ID       (JUMP_ID),
        .A_ALU_EX      (A_ALU_EX),
        .B_ALU_EX      (B_ALU_EX),
        .ZERO_EX       (ZERO_EX),
        .alu_result_MEM(alu_result_MEM),
        .dmem_data_MEM (dmem_data_MEM),
        .alu_result_WB (alu_result_WB),
        .rd_REG_WB     (rd_REG_WB),
        .regwrite_WB   (regwrite_WB)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_mip_datapath.vcd");
        $dumpvars(0, tb_mip_datapath);
    end

    integer cycle;
    initial cycle = 0;
    always @(posedge clk) begin
        $display("cyc=%0d  PC=%0d  instrID=%h  Stall=%b  FlushIFID=%b  FlushIDEX=%b  FlushEXMEM=%b  BranchSel=%b  JumpID=%b  aluWB=%0d  rdWB=%0d  regwriteWB=%b",
                  cycle, Address_IF, instruct_ID, Stall, Flush_ifid, Flush_idex, Flush_exmem,
                  BRANCH_SEL, JUMP_ID, alu_result_WB, rd_REG_WB, regwrite_WB);
        cycle = cycle + 1;
    end

    localparam RUN_CYCLES = 60;

    integer pass_count, fail_count;

    task check(input [8*48-1:0] name, input [31:0] actual, input [31:0] expected);
        begin
            if (actual === expected) begin
                $display("  PASS  %0s = %0d", name, actual);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL  %0s = %0d  (expected %0d)", name, actual, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;
        wait (cycle >= RUN_CYCLES);

        $display("\n================ SELF-CHECK (after %0d cycles) ================", RUN_CYCLES);
        check("$1 (addi)          ", U_DUT.U_REG_FILE.registers[1],  32'd5);
        check("$2 (addi)          ", U_DUT.U_REG_FILE.registers[2],  32'd10);
        check("$3 (add)           ", U_DUT.U_REG_FILE.registers[3],  32'd15);
        check("$4 (sub)           ", U_DUT.U_REG_FILE.registers[4],  32'd5);
        check("$5 (and)           ", U_DUT.U_REG_FILE.registers[5],  32'd0);
        check("$6 (or)            ", U_DUT.U_REG_FILE.registers[6],  32'd15);
        check("$7 (xor)           ", U_DUT.U_REG_FILE.registers[7],  32'd15);
        check("$8 (slt)           ", U_DUT.U_REG_FILE.registers[8],  32'd1);
        check("$9 (lw)            ", U_DUT.U_REG_FILE.registers[9],  32'd15);
        check("$10 (branch flush) ", U_DUT.U_REG_FILE.registers[10], 32'd0);
        check("$11 (branch target)", U_DUT.U_REG_FILE.registers[11], 32'd42);
        check("$12 (jump target)  ", U_DUT.U_REG_FILE.registers[12], 32'd222);
        check("$13 (lw)           ", U_DUT.U_REG_FILE.registers[13], 32'd15);
        check("$14 (load-use add) ", U_DUT.U_REG_FILE.registers[14], 32'd30);
        check("MEM[0] (sw)        ", U_DUT.U_DATA_MEM.memory[0],     32'd15);

        $display("=================================================================");
        $display("RESULT: %0d passed, %0d failed", pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL CHECKS PASSED");
        else
            $display("SOME CHECKS FAILED -- see FAIL lines above");
        $display("=================================================================\n");

        $finish;
    end

endmodule
