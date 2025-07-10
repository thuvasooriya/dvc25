`timescale 1ns / 1ps

/**
 * @module output_processor
 * @brief Applies bias and activation function. (Vivado Compatible)
 */
module output_processor (
    input                clk,
    input                rst,
    input  signed [31:0] result_in,
    input                bias_en,
    input  signed [31:0] bias_in,
    input         [ 1:0] activation_type,
    output signed [31:0] result_out
);
  localparam ACT_LINEAR = 2'b00;
  localparam ACT_RELU = 2'b01;

  reg signed [31:0] biased_result_stage1;
  reg signed [31:0] final_result_stage2;

  assign result_out = final_result_stage2;

  always @(posedge clk) begin
    if (rst) begin
      biased_result_stage1 <= 32'sd0;
    end else begin
      if (bias_en) biased_result_stage1 <= result_in + bias_in;
      else biased_result_stage1 <= result_in;
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      final_result_stage2 <= 32'sd0;
    end else begin
      case (activation_type)
        ACT_RELU: final_result_stage2 <= biased_result_stage1[31] ? 32'sd0 : biased_result_stage1;
        default:  final_result_stage2 <= biased_result_stage1;
      endcase
    end
  end

endmodule
