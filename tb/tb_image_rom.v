// tb_image_rom.v
// Simple testbench to verify image_rom reads from images.mem correctly.

`timescale 1ns/1ps

module tb_image_rom;

    // Testbench signals (regs drive inputs, wires observe outputs)
    reg  [12:0] addr;
    wire [7:0]  data;

    // Instantiate the DUT (Device Under Test)
    image_rom dut (
        .addr(addr),
        .data(data)
    );

    initial begin
        $display("==== tb_image_rom start ====");

        // Test 1: address 0
        addr = 13'd0;
        #10;  // wait 10 time units for data to settle
        $display("addr = %0d, data = 0x%02h", addr, data);

        // Test 2: address 1
        addr = 13'd1;
        #10;
        $display("addr = %0d, data = 0x%02h", addr, data);

        // Test 3: some mid-range address
        addr = 13'd100;
        #10;
        $display("addr = %0d, data = 0x%02h", addr, data);

        // Test 4: near the end (if you filled that far in images.mem)
        addr = 13'd7839;
        #10;
        $display("addr = %0d, data = 0x%02h", addr, data);

        $display("==== tb_image_rom done ====");
        $finish;
    end

endmodule
