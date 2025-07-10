`timescale 1ns / 1ps

/**
 * @module pe_int8
 * @brief Processing Element for INT8 Systolic Array. (Vivado Compatible)
 */
module pe_int8 #(
    parameter DATA_WIDTH = 8
) (
    input clk,
    input rst,
    input accum_reset,

    input signed [DATA_WIDTH-1:0] inp_north,
    input signed [DATA_WIDTH-1:0] inp_west,

    output signed [DATA_WIDTH-1:0] outp_south,
    output signed [DATA_WIDTH-1:0] outp_east,
    output signed [          31:0] result
);
  reg signed [31:0] accumulator;

  assign outp_south = inp_north;
  assign outp_east  = inp_west;
  assign result     = accumulator;

  always @(posedge clk) begin
    if (rst) begin
      accumulator <= 32'sd0;
    end else if (accum_reset) begin
      accumulator <= 32'sd0;
    end else begin
      accumulator <= accumulator + (inp_north * inp_west);
    end
  end

endmodule
