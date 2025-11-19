// tb_bias_rom.v
// Testbench to verify bias_rom reads from biases.mem correctly.

`timescale 1ns/1ps

module tb_bias_rom;

    reg  [3:0]  addr;
    wire [15:0] data;

    bias_rom dut (
        .addr(addr),
        .data(data)
    );

    integer i;

    initial begin
        $display("==== tb_bias_rom start ====");

        // Loop over all 10 possible addresses (0..9)
        for (i = 0; i < 10; i = i + 1) begin
            addr = i[3:0];
            #10;
            $display("addr = %0d, data = 0x%04h", addr, data);
        end

        $display("==== tb_bias_rom done ====");
        $finish;
    end

endmodule
