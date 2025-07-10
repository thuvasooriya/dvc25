`timescale 1ns / 1ps

/**
 * @module systolic_array_16x16
 * @brief 16x16 Systolic Array for high-throughput GEMM operations. (Vivado Compatible)
 */
module systolic_array_16x16 #(
    parameter SIZE = 16,
    parameter DATA_WIDTH = 8,
    parameter ACCUM_WIDTH = 32
) (
    input clk,
    input rst,
    input accum_reset,

    input signed [SIZE-1:0][DATA_WIDTH-1:0] north_inputs,
    input signed [SIZE-1:0][DATA_WIDTH-1:0] west_inputs,

    output signed [SIZE-1:0][SIZE-1:0][ACCUM_WIDTH-1:0] result_matrix
);
  wire signed [DATA_WIDTH-1:0] north_to_south[  SIZE:0][SIZE-1:0];
  wire signed [DATA_WIDTH-1:0] west_to_east  [SIZE-1:0][  SIZE:0];

  // CORRECTED: Use a generate loop for array assignment, which is standard Verilog.
  genvar c_north;
  generate
    for (c_north = 0; c_north < SIZE; c_north = c_north + 1) begin : north_assign_loop
      assign north_to_south[0][c_north] = north_inputs[c_north];
    end
  endgenerate

  genvar r;
  generate
    for (r = 0; r < SIZE; r = r + 1) begin : west_assign_loop
      assign west_to_east[r][0] = west_inputs[r];
    end
  endgenerate

  genvar row, col;
  generate
    for (row = 0; row < SIZE; row = row + 1) begin : row_gen
      for (col = 0; col < SIZE; col = col + 1) begin : col_gen
        pe_int8 pe_inst (
            .clk(clk),
            .rst(rst),
            .accum_reset(accum_reset),
            .inp_north(north_to_south[row][col]),
            .inp_west(west_to_east[row][col]),
            .outp_south(north_to_south[row+1][col]),
            .outp_east(west_to_east[row][col+1]),
            .result(result_matrix[row][col])
        );
      end
    end
  endgenerate

endmodule
