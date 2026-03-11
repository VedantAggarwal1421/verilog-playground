module count(input clk, input s1, input reset, output [5:0] led_out);
    reg [5:0] state = 0;
    reg prev_state = 0;

    always @(posedge clk) begin
        if(reset) begin
            state <= 0;
            prev_state <= 0;
        end
        else begin 
            if(s1 & (~prev_state))
                state <= state+1;
            
            prev_state <= s1;
        end
    end

    assign led_out = state;
endmodule