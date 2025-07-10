#include "stdlib.h"
#include "uart.h"

// required by the crt.S startup code
typedef unsigned long UL;
UL g_program_entry;
volatile UL core_flag;
UL g_dtb_address;

// define accelerator register offsets
#define ACC_BASE 0x20060000
#define ACC_CONTROL (ACC_BASE + 0x00)
#define ACC_STATUS (ACC_BASE + 0x04)
#define ACC_CONFIG (ACC_BASE + 0x08)
#define ACC_ADDR_A_LSB (ACC_BASE + 0x10)
#define ACC_ADDR_A_MSB (ACC_BASE + 0x14)
#define ACC_ADDR_B_LSB (ACC_BASE + 0x18)
#define ACC_ADDR_B_MSB (ACC_BASE + 0x1C)
#define ACC_ADDR_C_LSB (ACC_BASE + 0x20)
#define ACC_ADDR_C_MSB (ACC_BASE + 0x24)
#define ACC_DIM_M (ACC_BASE + 0x38)
#define ACC_DIM_K (ACC_BASE + 0x3C)
#define ACC_DIM_N (ACC_BASE + 0x40)

// define memory locations for matrices
#define MATRIX_A_ADDR 0x20000
#define MATRIX_B_ADDR 0x21000
#define MATRIX_C_ADDR 0x22000
#define MATRIX_SIZE 16
#define NUM_ELEMENTS (MATRIX_SIZE * MATRIX_SIZE) // 256

// helper to write to a 32-bit memory-mapped register
void write_reg(unsigned int addr, unsigned int value) {
  volatile unsigned int *ptr = (volatile unsigned int *)addr;
  *ptr = value;
}

int main(void) {
  // UART init
  init_uart(0x1b);
  printf("S> Gemma3 INT8 Accelerator Test: A * I = A\n");

  // pointers for matrix data (INT8)
  volatile signed char *matrix_a = (volatile signed char *)MATRIX_A_ADDR;
  volatile signed char *matrix_b = (volatile signed char *)MATRIX_B_ADDR;

  // --- 1. prepare input data ---
  printf("Preparing input matrices in memory...\n");
  // matrix a: simple incrementing values
  for (int i = 0; i < NUM_ELEMENTS; i++) {
    matrix_a[i] = (signed char)(i + 1);
  }
  // matrix b: identity matrix
  for (int r = 0; r < MATRIX_SIZE; r++) {
    for (int c = 0; c < MATRIX_SIZE; c++) {
      if (r == c) {
        matrix_b[r * MATRIX_SIZE + c] = 1;
      } else {
        matrix_b[r * MATRIX_SIZE + c] = 0;
      }
    }
  }
  // clear output matrix to ensure results are from the accelerator
  for (int i = 0; i < NUM_ELEMENTS * 4; i++) { // clear result (INT32)
    ((volatile signed char *)MATRIX_C_ADDR)[i] = 0;
  }

  // --- 2. configure the accelerator ---
  printf("Configuring accelerator registers...\n");
  write_reg(ACC_ADDR_A_LSB, MATRIX_A_ADDR);
  write_reg(ACC_ADDR_A_MSB, 0x0);
  write_reg(ACC_ADDR_B_LSB, MATRIX_B_ADDR);
  write_reg(ACC_ADDR_B_MSB, 0x0);
  write_reg(ACC_ADDR_C_LSB, MATRIX_C_ADDR);
  write_reg(ACC_ADDR_C_MSB, 0x0);

  // set matrix dimensions for 16x16 x 16x16
  write_reg(ACC_DIM_M, MATRIX_SIZE);
  write_reg(ACC_DIM_K, MATRIX_SIZE);
  write_reg(ACC_DIM_N, MATRIX_SIZE);

  // --- 3. start accelerator and wait for completion ---
  printf("[i] starting accelerator...\n");
  write_reg(ACC_CONTROL, 0x1); // write 1 to start

  volatile unsigned int *status_reg = (volatile unsigned int *)ACC_STATUS;
  while (1) {
    if ((*status_reg & 0x1) == 0x1) { // poll bit 0 for done signal
      printf("[✓] accelerator finished\n");
      break;
    }
  }

  // --- 4. verify the results ---
  printf("[i] verifying results...\n");
  int mismatches = 0;
  volatile signed int *result_ptr = (volatile signed int *)MATRIX_C_ADDR;

  for (int i = 0; i < NUM_ELEMENTS; i++) {
    // since b is identity, c should equal a.
    // the systolic array produces INT32 results, so we cast matrix_a[i] for
    // comparison.
    if (result_ptr[i] != (signed int)matrix_a[i]) {
      mismatches++;
      if (mismatches < 5) { // Print first few errors
        printf("[✕] error at index %d: expected %d, got %d\n", i, matrix_a[i],
               result_ptr[i]);
      }
    }
  }

  if (mismatches == 0) {
    printf("[✓] test PASSED!\n");
  } else {
    printf("[✕] FAILED with %d mismatches.\n", mismatches);
  }

  printf("E>\n");
  while (1)
    ;
}
