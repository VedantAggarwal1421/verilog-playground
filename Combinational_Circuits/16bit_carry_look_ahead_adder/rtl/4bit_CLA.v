module CLA_4bit(input [3:0] a, input [3:0] b, input cin, output [3:0] sum, output cout, output g_block, output p_block);

    wire c0,c1,c2;
    wire [3:0] gen, prop;

    assign gen = a&b;
    assign prop = a^b;

    assign c0 = gen[0] | (cin&prop[0]);
    assign c1 = gen[1] | (gen[0]&prop[1]) | (cin&prop[0]&prop[1]);
    assign c2 = gen[2] | (gen[1]&prop[2]) | (gen[0]&prop[1]&prop[2]) | (cin&prop[0]&prop[1]&prop[2]);

    assign sum[0] = a[0]^b[0]^cin;
    assign sum[1] = a[1]^b[1]^c0;
    assign sum[2] = a[2]^b[2]^c1;
    assign sum[3] = a[3]^b[3]^c2;

    assign p_block = &prop;
    assign g_block = gen[3]|(prop[3]&(gen[2]|(prop[2]&(gen[1]|(prop[1]&gen[0])))));

    assign cout = g_block | (p_block&cin);
endmodule