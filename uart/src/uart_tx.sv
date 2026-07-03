module uart_tx #(
    parameter CLK_FREQ  = 27,     //(MHz)
    parameter BAUD_RATE = 115200  //Bits per second
) (
    input            clk,            //Clock
    input            reset,          // Asynchronous active high reset
    input      [7:0] tx_data,        //Data to send
    input            tx_data_valid,  //Data to be sent is valid
    output reg       tx_data_ready,  //Transmitter is ready to send data
    output           tx_pin          //Uart transmission pin
);
    localparam CYCLES = CLK_FREQ * 1_000_000 / BAUD_RATE; // Clock cycles per bit being sent , about 234 for 27 MHz at 115200 baud rate

    reg [31:0] cycle_cnt;
    reg [ 2:0] bit_cnt;
    reg [ 7:0] tx_data_latch;  //Latch the data to be sent
    reg        tx_reg;  //Transmission register
    assign tx_pin = tx_reg;

    //State machine variables
    localparam S_IDLE = 0;
    localparam S_START = 1;
    localparam S_DATA = 2;
    localparam S_STOP = 3;

    reg [1:0] current_state;
    reg [1:0] next_state;

    // verilog_format: off

    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= S_IDLE;
        else 
            current_state <= next_state;
    end

    //Next state logic
    always @(*) begin
        case (current_state)
            S_IDLE: begin
                if (tx_data_valid == 1'b1)
                    next_state = S_START;
                else
                    next_state = S_IDLE;
            end
            S_START: begin
                if (cycle_cnt == CYCLES-1)
                    next_state = S_DATA;
                else
                    next_state = S_START;
            end
            S_DATA: begin
                if (cycle_cnt == CYCLES-1 && bit_cnt == 3'd7)
                    next_state = S_STOP;
                else
                    next_state = S_DATA;
            end
            S_STOP: begin
                if (cycle_cnt == CYCLES-1)
                    next_state = S_IDLE;
                else
                    next_state = S_STOP;
            end
            default: next_state = S_IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if(reset)
            cycle_cnt <= 32'd0;
        else if((current_state == S_DATA && cycle_cnt == CYCLES - 1) || next_state != current_state)
            cycle_cnt <= 32'd0;
        else
            cycle_cnt <= cycle_cnt+1; 
    end

    always @(posedge clk or posedge reset) begin
        if(reset)
            tx_data_latch <= 8'd0;
        else if(tx_data_valid == 1'b1 && current_state == S_IDLE)
            tx_data_latch <= tx_data; 
    end

    always @(posedge clk or posedge reset) begin
        if(reset)
            tx_data_ready <= 1'b0;
        else if (current_state == S_IDLE) begin
            if(tx_data_valid == 1'b1)
                tx_data_ready <= 1'b0;
            else
                tx_data_ready <= 1'b1;
        end else if (current_state == S_STOP && cycle_cnt == CYCLES-1)
            tx_data_ready <= 1'b1;
    end

    always @(posedge clk or posedge reset) begin
        if(reset)
            bit_cnt <= 3'd0;
        else if(current_state == S_DATA) begin
            if(cycle_cnt == CYCLES - 1)
                bit_cnt <= bit_cnt + 3'd1;
            else
                bit_cnt <= bit_cnt;
        end else
            bit_cnt <= 3'd0;
    end

    always @(posedge clk or posedge reset) begin
        if(reset)
            tx_reg <= 1'b1;
        else begin
            case(current_state)
                S_IDLE, S_STOP: tx_reg <= 1'b1; //Idle High
                S_START:        tx_reg <= 1'b0;
                S_DATA:         tx_reg <= tx_data_latch[bit_cnt];
                default:        tx_reg <= 1'b1;
            endcase
        end
    end

endmodule
