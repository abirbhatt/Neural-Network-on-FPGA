// tb_weight_rom.v
// Testbench to verify weight_rom reads from weights.mem correctly.

`timescale 1ns/1ps

module tb_weight_rom;

    reg  [12:0] addr;
    wire [7:0]  data;

    weight_rom dut (
        .addr(addr),
        .data(data)
    );

    initial begin
        $display("==== tb_weight_rom start ====");

        // Test a few addresses
        addr = 13'd0;
        #10;
        $display("addr = %0d, data = 0x%02h", addr, data);

        addr = 13'd10;
        #10;
        $display("addr = %0d, data = 0x%02h", addr, data);

        addr = 13'd784;  // start of neuron 1 if flattened row-major
        #10;
        $display("addr = %0d, data = 0x%02h", addr, data);

        addr = 13'd7839;
        #10;
        $display("addr = %0d, data = 0x%02h", addr, data);

        $display("==== tb_weight_rom done ====");
        $finish;
    end

endmodule
