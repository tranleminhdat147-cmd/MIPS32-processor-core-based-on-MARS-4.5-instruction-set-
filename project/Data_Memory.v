module Data_Memory (
    input [31:0] address,
    input [31:0] write_data,
    input mem_write,
    input mem_read,
    input clk,
    output [31:0] read_data 
);
    parameter MEM_SIZE = 256;
    reg [31:0] memory [0:MEM_SIZE-1];  

    always @(posedge clk) begin
        if (mem_write) begin
            memory[address[7:0]] <= write_data;
        end
    end

    assign read_data = (mem_read) ? memory[address[7:0]] : 32'b0;
endmodule