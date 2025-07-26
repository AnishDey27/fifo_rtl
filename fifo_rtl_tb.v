`timescale 1ns / 1ps

module fifo_rtl_tb();
    localparam TB_DATA_WIDTH = 8;
    localparam TB_DEPTH = 8;
    localparam CLK_PERIOD = 10;

    reg clk, rst_n;
    reg read_en, write_en;
    reg [TB_DATA_WIDTH-1:0] data_in;
    wire [TB_DATA_WIDTH-1:0] data_out;
    wire [$clog2(TB_DEPTH):0]  fifo_level;
    wire fifo_full, fifo_empty;

    fifo_rtl #(
        .DATA_WIDTH(TB_DATA_WIDTH),
        .DEPTH(TB_DEPTH)
    ) dut(
        .data_out(data_out),
        .data_in(data_in),
        .fifo_level(fifo_level),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty),
        .read_en(read_en),
        .write_en(write_en),
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    task write_fifo;
        input [TB_DATA_WIDTH-1:0] wdata;
        begin
            @(posedge clk);
            write_en = 1;
            data_in = wdata;
            @(posedge clk);
            write_en = 0;
        end
    endtask

    task read_fifo;
        begin
            @(posedge clk);
            read_en = 1;
            @(posedge clk);
            read_en = 0;
        end
    endtask

    task simultaneous_read_write_fifo;
        input [TB_DATA_WIDTH-1:0] wdata;
        begin
            @(posedge clk);
            write_en = 1; read_en = 1;
            data_in = wdata;
            @(posedge clk);
            write_en = 0; read_en = 0;
        end
    endtask

    initial begin
        rst_n = 0; write_en = 0; read_en = 0; data_in = 0;

        #20 rst_n = 1;
        @(posedge clk);

        write_fifo(1);
        write_fifo(2);
        write_fifo(3);
        write_fifo(4);
        write_fifo(5);
        write_fifo(6);
        write_fifo(7);
        write_fifo(8);

        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();

        simultaneous_read_write_fifo(10);

        read_fifo();

        #(2*CLK_PERIOD) $finish;
    end

endmodule