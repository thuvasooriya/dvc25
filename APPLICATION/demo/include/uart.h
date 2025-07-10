#ifndef UART_H_
#define UART_H_

#include "config.h"
#include "stdlib.h"
/**
 *  Definition section
***************************************************/

typedef struct uart_reg
{
	UI   UART_DR; 	/*0x00*/
	UI   UART_IE; 	/*0x04*/
	UI   UART_IIR; 	/*0x08*/
	UI   UART_LCR; 	/*0x0c*/
	UI   Dummy10; 	/*0x10*/
	UI   UART_LSR; 	/*0x14*/
}UART_REG;

/**
 *   Function declaration section
***************************************************/


void init_uart(unsigned char baud);
void tx_uart(UC tx_char);
UC rx_uart(void);
UL get_long_int(UC noofBytes);
UC get_hex();
UL get_decimal(UC noOfDigits);
void Transmit_uart(UC *data_ptr);
#define uart_regs (*((volatile UART_REG *)(UART_BASE)))

#endif /* UART_H_ */
