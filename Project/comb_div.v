module comb_div (
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] quotient
);
    wire [4:0] lz;
    assign lz = (b[31]) ? 0 : (b[30]) ? 1 : (b[29]) ? 2 : (b[28]) ? 3 :
                (b[27]) ? 4 : (b[26]) ? 5 : (b[25]) ? 6 : (b[24]) ? 7 :
                (b[23]) ? 8 : (b[22]) ? 9 : (b[21]) ? 10: (b[20]) ? 11:
                (b[19]) ? 12: (b[18]) ? 13: (b[17]) ? 14: (b[16]) ? 15:
                (b[15]) ? 16: (b[14]) ? 17: (b[13]) ? 18: (b[12]) ? 19:
                (b[11]) ? 20: (b[10]) ? 21: (b[9])  ? 22: (b[8])  ? 23:
                (b[7])  ? 24: (b[6])  ? 25: (b[5])  ? 26: (b[4])  ? 27:
                (b[3])  ? 28: (b[2])  ? 29: (b[1])  ? 30: (b[0])  ? 31 : 31;

    wire [31:0] b_norm = b << lz;

    wire [31:0] x0;
    reciprocal_rom rom_inst (.index(b_norm[30:23]), .x0(x0));

    
    wire [63:0] b_x0_full = b_norm * x0;
    wire [31:0] b_x0 = b_x0_full[61:30]; 

 
    wire [31:0] v_factor = 32'h7FFFFFFF - b_x0; 

    
    wire [63:0] x1_full = x0 * v_factor;
    wire [31:0] x1 = x1_full[60:29]; 
    wire [63:0] q_pre = a * x1;
    wire [31:0] q_norm = q_pre[61:30];

    assign quotient = (b == 0) ? 32'hFFFFFFFF : (q_norm >> (31 - lz));
endmodule