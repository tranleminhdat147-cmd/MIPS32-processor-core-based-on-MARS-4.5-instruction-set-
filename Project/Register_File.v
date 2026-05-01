module Register_File(
    input ReadWrite,
    input [4:0] ReadAddress1,
    input [4:0] ReadAddress2,
    input [4:0] WriteAddress,
    input [31:0] WriteData,
    input clk,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);

    reg [31:0] registers [31:0]; 

    always @(posedge clk) begin
        if (ReadWrite && WriteAddress != 5'd0) begin
            registers[WriteAddress] <= WriteData;
        end
    end

    assign ReadData1 = (ReadAddress1 == 5'd0) ? 32'b0 : 
                       (ReadWrite && (ReadAddress1 == WriteAddress)) ? WriteData : 
                       registers[ReadAddress1];

    assign ReadData2 = (ReadAddress2 == 5'd0) ? 32'b0 : 
                       (ReadWrite && (ReadAddress2 == WriteAddress)) ? WriteData : 
                       registers[ReadAddress2];

endmodule