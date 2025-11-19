// Image ROM for MNIST FPGA
// Stores one MNIST test image (28x28 pixels, 1 channel, 8-bit per pixel)

module image_rom (
    input wire [12:0] addr,  // enough for 7840 bits
    output reg [7:0] data   // 8-bit pixel data
);
    // Memory array (7840 bytes for 10 x 784 entries
    reg [7:0] mem [0:7839];
    
    // Initialize memory from external file
    initial begin
        $readmemh("data/images.mem", mem);
    end
    
    always @(*) begin
        data = mem[addr];
    end
endmodule
