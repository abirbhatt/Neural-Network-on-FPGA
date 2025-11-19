// Input Buffer for MNIST FPGA
// Buffers input data for processing

module input_buf (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire wr_en,
    output reg [7:0] data_out
);
    // Internal buffer
    reg [7:0] buffer;
    
    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'h00;
        end else if (wr_en) begin
            buffer <= data_in;
        end
    end
    
    // Continuous assignment for output
    always @(*) begin
        data_out = buffer;
    end
    
endmodule
