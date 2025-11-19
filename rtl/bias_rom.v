// Bias ROM for MNIST FPGA
// Stores neural network biases

module bias_rom (
    input wire [3:0] addr,   // 0 to 9
    output reg [15:0] data    // 16-bit bias data
);
    // Memory array for biases
    reg [15:0] mem [0:9];
    
    // Initialize memory from external file
    initial begin
        $readmemh("data/biases.mem", mem);
    end
    
    // Read operation
    always @(*) begin
        data = mem[addr];
    end
    
endmodule
