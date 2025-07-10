`timescale 1ns / 1ps

/**
 * @module accelerator_buffer
 * @brief Generic, synthesizable dual-port buffer. (Vivado Compatible)
 */
module accelerator_buffer #(
    parameter DATA_WIDTH = 128,
    parameter DEPTH = 256,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (
    input clk,
    input wr_en,
    input [ADDR_WIDTH-1:0] wr_addr,
    input [DATA_WIDTH-1:0] wr_data,
    input [ADDR_WIDTH-1:0] rd_addr,
    output [DATA_WIDTH-1:0] rd_data
);
  reg [DATA_WIDTH-1:0] mem[DEPTH-1:0];

  always @(posedge clk) begin
    if (wr_en) begin
      mem[wr_addr] <= wr_data;
    end
  end

  assign rd_data = mem[rd_addr];

endmodule
