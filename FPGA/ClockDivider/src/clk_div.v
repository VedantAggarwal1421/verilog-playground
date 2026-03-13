module clock_divider(input clk, output [5:0] led_out);
    reg [24:0] counter;

    always @(posedge clk) begin
        counter <= counter + 1;
        clk_div <= counter[24];
    end

    assign led_out = {6{counter[24]}};
endmodule