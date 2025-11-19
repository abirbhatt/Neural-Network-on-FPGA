// Weight ROM for MNIST FPGA
// Stores neural network weights

module weight_rom (
    input wire [12:0] addr,  // 0 to 7839
    output reg [7:0] data    // 8-bit weight data
);
    // Memory array for weights
    reg [7:0] mem [0:7839]; 
    
    // Initialize memory from external file
    initial begin
        $readmemh("data/weights.mem", mem);
    end
    
    // Read operation
    always @(*) begin
        data = mem[addr];
    end
    
endmodule
