//verilog_format: off
module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input logic clk,
    input logic rst,

    input  logic             wr_valid,
    output logic             wr_ready,
    input  logic [WIDTH-1:0] wr_data,

    output logic             rd_valid,
    input  logic             rd_ready,
    output logic [WIDTH-1:0] rd_data
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    logic [WIDTH-1:0] mem[0:DEPTH-1];

    logic [   PTR_WIDTH:0] count;
    logic [PTR_WIDTH-1:0] wr_ptr;
    logic [PTR_WIDTH-1:0] rd_ptr;

    assign wr_ready = count < DEPTH;
    assign rd_valid = count != 0;
    assign rd_data  = rd_valid ? mem[rd_ptr] : '0;

    logic push, pop;
    assign push = wr_ready && wr_valid;
    assign pop = rd_ready && rd_valid;


    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count  <= '0;
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            if (push) begin
                mem[wr_ptr] <= wr_data;
                wr_ptr      <= wr_ptr + 'd1;
            end
            if (pop) begin
                rd_ptr <= rd_ptr + 'd1;
            end
            case ({push, pop})
                2'b10:   count <= count + 'd1;
                2'b01:   count <= count - 'd1;
                default: count <= count;
            endcase
        end
    end

endmodule
