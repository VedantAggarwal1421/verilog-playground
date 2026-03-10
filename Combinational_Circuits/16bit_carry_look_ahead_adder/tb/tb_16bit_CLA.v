`timescale 1ns/1ns

module tb_CLA_16bit();
    reg [15:0] a,b;
    reg cin;
    wire [15:0] sum;
    wire cout;

    CLA_16bit dut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_CLA_16bit);
        
        a = 16'hffff; b = 16'd0; cin=0; #5;
        a = 16'hffff; b = 16'd0; cin=1; #5;
        a = 16'd5; b = 16'd5; cin=0; #5;
        a = 16'd5; b = 16'd5; cin=1; #5;

    end
endmodule