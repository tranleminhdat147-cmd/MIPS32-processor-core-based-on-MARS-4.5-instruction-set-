module Stall(
    input  wire        RegWrite_EX,
    input  wire        RegWrite_MEM,
    input  wire [4:0]  rd_EX,
    input  wire [4:0]  rd_MEM,
    input  wire [4:0]  rs_ID,
    input  wire [4:0]  rt_ID,
    input  wire        uses_rs,     // NEW
    input  wire        uses_rt,     // NEW
    output wire        Stall
);

// Hazard with EX stage
wire ex_hazard =
    RegWrite_EX &&
    (rd_EX != 5'b00000) &&
    (
        (uses_rs && (rd_EX == rs_ID)) ||
        (uses_rt && (rd_EX == rt_ID))
    );

// Hazard with MEM stage
wire mem_hazard =
    RegWrite_MEM &&
    (rd_MEM != 5'b00000) &&
    (
        (uses_rs && (rd_MEM == rs_ID)) ||
        (uses_rt && (rd_MEM == rt_ID))
    );

assign Stall = ex_hazard | mem_hazard;

endmodule