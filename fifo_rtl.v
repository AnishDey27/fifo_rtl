module fifo_rtl #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
)(
    output[DATA_WIDTH-1:0] data_out,
    input[DATA_WIDTH-1:0] data_in,
    output [$clog2(DEPTH):0] fifo_level,
    output fifo_full,
    output fifo_empty,
    input read_en,
    input write_en,
    input clk,
    input rst_n
);
    localparam PTR_WIDTH = $clog2(DEPTH) + 1;

    reg [DATA_WIDTH-1:0] memory [DEPTH-1:0];
    reg [PTR_WIDTH-1:0] rd_ptr, wr_ptr;
    reg [DATA_WIDTH-1:0] data_out_reg;

    // WRITE
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) wr_ptr <= 0;
        else if(write_en && !fifo_full) begin
            memory[wr_ptr[PTR_WIDTH-2:0]] <= data_in;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // READ
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) rd_ptr <= 0;
        else if(read_en && !fifo_empty) begin
            data_out_reg <= memory[rd_ptr[PTR_WIDTH-2:0]];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end
    assign data_out = data_out_reg;

    // LEVEL
    assign fifo_empty = (wr_ptr == rd_ptr);
    assign fifo_full = (wr_ptr[PTR_WIDTH-1] != rd_ptr[PTR_WIDTH-1]) && (wr_ptr[PTR_WIDTH-2:0] == rd_ptr[PTR_WIDTH-2:0]);
    assign fifo_level = wr_ptr - rd_ptr;

endmodule