#include "stdlib.h"
#include "uart.h"

UL g_program_entry;
volatile UL core_flag;
UL g_dtb_address;

volatile unsigned int *accelarator_base, *accelarator_dst_addr_lsb_matrix_a,
    *accelarator_dst_addr_msb_matrix_a;
volatile unsigned int *accelarator_dst_addr_lsb_matrix_b,
    *accelarator_dst_addr_msb_matrix_b;
volatile unsigned int *accelarator_dst_addr_lsb_matrix_c,
    *accelarator_dst_addr_msb_matrix_c;
volatile int *matrix_a, *matrix_b, *matrix_c;

int main(void) {
  // UART init in 50MHz
  init_uart(0x1b);
  printf("S>\n");

  // For setting the memory region as non-cacheable
  volatile unsigned long *framebuff_start_addr =
      (volatile unsigned long *)0x10301030;
  volatile unsigned long *framebuff_end_addr =
      (volatile unsigned long *)0x10301038;
  *framebuff_start_addr = 0x20000;
  *framebuff_end_addr = 0x30000;

  // Setting address locations (SRAM) for matrices
  int temp = 0;
  matrix_a = (volatile int *)(0x20000);
  matrix_b = (volatile int *)(0x26000);
  matrix_c = (volatile int *)(0x2b000);

  // Accelerator register offsets
  accelarator_base = (volatile unsigned int *)(0x20060000);
  accelarator_dst_addr_lsb_matrix_a = (volatile unsigned int *)(0x20060010);
  accelarator_dst_addr_msb_matrix_a = (volatile unsigned int *)(0x20060014);
  accelarator_dst_addr_lsb_matrix_b = (volatile unsigned int *)(0x2006001c);
  accelarator_dst_addr_msb_matrix_b = (volatile unsigned int *)(0x20060020);
  accelarator_dst_addr_lsb_matrix_c = (volatile unsigned int *)(0x20060028);
  accelarator_dst_addr_msb_matrix_c = (volatile unsigned int *)(0x2006002c);

  temp = 0;

  unsigned int data_hex[4100] = {
      0,
  };

  // Dummy data : (Decimal 1: floating point notation(0x3f800000)). You can set
  // your own datatype as per your accelerator requirements.
  for (int i = 0; i < 4096; i++) {
    data_hex[i] = 0x3f800000;
  }

  // Filling Matrix A data
  for (int i = 0; i < 4096; i++) {
    *matrix_a = data_hex[i];
    // printf("%d:%x\n\r", i, *matrix_a);
    matrix_a++;
  }
  // Filling Matrix B data
  for (int i = 0; i < 4096; i++) {
    *matrix_b = data_hex[i];
    // printf("%d:%x\n\r", i, *matrix_b);
    matrix_b++;
  }

  // Setting accelerator register configuration with matrix addresses
  *(accelarator_dst_addr_lsb_matrix_a) = 0x20000;
  *(accelarator_dst_addr_msb_matrix_a) = 0x0;
  *(accelarator_dst_addr_lsb_matrix_b) = 0x26000;
  *(accelarator_dst_addr_msb_matrix_b) = 0x0;
  *(accelarator_dst_addr_lsb_matrix_c) = 0x2b000;
  *(accelarator_dst_addr_msb_matrix_c) = 0x0;

  // Starting accelerator
  *accelarator_base = 0x1;

  // Wating for accelerator process completion
  while (1) {
    temp = *accelarator_base;
    if ((temp & 0x2) == 0x2) {
      // printf("S\n\r");
      break;
    }
  }

  // Printing results if required.

  // printf("matrix A\n");
  // matrix_a = (volatile int *)(0x20000);
  // for (int i = 0; i < 4096; i++) {
  //   printf("%d:%x\n\r", i, *matrix_a);
  //   matrix_a++;
  // }
  // printf("matrix B\n");
  // matrix_b = (volatile int *)(0x26000);
  // for (int i = 0; i < 4096; i++) {
  //   printf("%d:%x\n\r", i, *matrix_b);
  //   matrix_b++;
  // }

  printf("matrix C\n");
  matrix_c = (volatile int *)(0x2b000);
  for (int i = 0; i < 4096; i++) {
    printf("%d:%x\n\r", i, *matrix_c);
    matrix_c++;
  }

  printf("E>\n");

  while (1)
    ;
}
