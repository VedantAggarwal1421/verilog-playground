module CLA_16bit(input [15:0] a, input [15:0] b, input cin, output [15:0] sum, output cout);
    wire [3:0] gen, prop;
    wire G, P;
    wire [3:0] c;

    assign c[0] = cin;
    assign c[1] = gen[0] | (cin&prop[0]);
    assign c[2] = gen[1] | (gen[0]&prop[1]) | (cin&prop[0]&prop[1]);
    assign c[3] = gen[2] | (gen[1]&prop[2]) | (gen[0]&prop[1]&prop[2]) | (cin&prop[0]&prop[1]&prop[2]);

    assign P = &prop;
    assign G = gen[3] |
               (gen[2] & prop[3]) |
               (gen[1] & prop[2] & prop[3]) |
               (gen[0] & prop[1] & prop[2] & prop[3]);

    assign cout = G | (P&cin);

    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin
            CLA_4bit block(
                .a(a[i*4 +: 4]),
                .b(b[i*4 +: 4]),
                .cin(c[i]),
                .sum(sum[i*4 +: 4]),
                .g_block(gen[i]),
                .p_block(prop[i])
            );
        end
    endgenerate
endmodule