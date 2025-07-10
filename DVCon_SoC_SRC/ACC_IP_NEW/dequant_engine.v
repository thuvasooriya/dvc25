`timescale 1ns / 1ps

/**
 * @module dequant_engine
 * @brief Pipelined 4-bit to INT8 dequantization engine. (Vivado Verilog-2001 Compatible)
 * @details Implements output = (input - zero_point) * scale.
 *          Processes 16 weights per cycle using generated parallel pipelines.
 */
module dequant_engine #(
    parameter WEIGHTS_PER_CYCLE = 16
) (
    input                                       clk,
    input                                       rst,
    input             [WEIGHTS_PER_CYCLE*4-1:0] quantized_weights_in,
    input  signed     [                    7:0] zero_point,
    input  signed     [                   15:0] scale_factor_q8_8,
    output reg signed [WEIGHTS_PER_CYCLE*8-1:0] dequantized_weights_out
);

  // Pipeline stage registers
  reg signed [8:0] temp_val_stage1[WEIGHTS_PER_CYCLE-1:0];
  reg signed [24:0] scaled_val_stage2[WEIGHTS_PER_CYCLE-1:0];
  reg signed [16:0] integer_val_stage3[WEIGHTS_PER_CYCLE-1:0];
  integer j;  // Loop variable for resets

  // Use a generate block to create the 16 parallel sequential pipelines
  genvar i;
  generate
    for (i = 0; i < WEIGHTS_PER_CYCLE; i = i + 1) begin : dequant_pipeline_gen

      // Pipeline Stage 1: Unpack and Subtract Zero Point
      always @(posedge clk) begin
        if (rst) begin
          temp_val_stage1[i] <= 9'sd0;
        end else begin
          temp_val_stage1[i] <= {1'b0, quantized_weights_in[i*4+:4]} - zero_point;
        end
      end

      // Pipeline Stage 2: Fixed-Point Multiplication
      always @(posedge clk) begin
        if (rst) begin
          scaled_val_stage2[i] <= 25'sd0;
        end else begin
          scaled_val_stage2[i] <= temp_val_stage1[i] * scale_factor_q8_8;
        end
      end

      // Pipeline Stage 3: Shift to get integer part
      always @(posedge clk) begin
        if (rst) begin
          integer_val_stage3[i] <= 17'sd0;
        end else begin
          integer_val_stage3[i] <= scaled_val_stage2[i] >>> 8;
        end
      end

    end
  endgenerate

  // A single combinational block to handle the final saturation for all lanes.
  // This is cleaner and more standard than placing it inside the generate block.
  integer k;  // Loop variable for combinational logic
  always @(*) begin
    for (k = 0; k < WEIGHTS_PER_CYCLE; k = k + 1) begin
      if (integer_val_stage3[k] > 127) begin
        dequantized_weights_out[k*8+:8] = 8'sd127;
        // CORRECTED: Use the hex representation for -128.
      end else if (integer_val_stage3[k] < -128) begin
        dequantized_weights_out[k*8+:8] = 8'h80;  // -128 in 8-bit two's complement
      end else begin
        dequantized_weights_out[k*8+:8] = integer_val_stage3[k][7:0];
      end
    end
  end

endmodule
