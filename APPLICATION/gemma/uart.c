#include "uart.h"

/**************************************************
 * Function name	: void init_uart(void)
 * Description		: Initialize UART.
 * Notes			: To initialize UART - Baud Rate = 115200 Clock
 *25MHz 8 Data bits, 1 Stop bit, no Parity,disable DR intrpt & THRE intrpt
 **************************************************/

void init_uart(unsigned char baud) {
  uart_regs.UART_LCR = 0x83; // Divisor latch enabled
  uart_regs.UART_DR = baud;  // 0x0e;
                            // //0x0b-20mHz,0x02-5mHz,0x10-30mHz;//y-25mHz;0x0f-29mHz,0x1b-50mHz;
                            // 0x15-40mHz ;0x28-75mHz  //Divisor LSB
  uart_regs.UART_IE = 0x00;  // Divisor MSB
  uart_regs.UART_LCR = 0x03; // Divisor latch disabled, stop-bits = 1, parity =
                             // none, data-bits = 8
  uart_regs.UART_IE = 0x00; // Interrupts disabled
  __asm__ __volatile__("fence");
}

/**************************************************
 * Function name	: void tx_uart(UC tx_char)
 *    returns		: Nil
 * Tx_char           : Character to Tx
 * Description		: Tx 1 character through UART
 * Notes			:
 *************************************************/

void tx_uart(UC tx_char) {
  UC lsr;

  uart_regs.UART_DR = tx_char;
  __asm__ __volatile__("fence");
  do {
    lsr = uart_regs.UART_LSR;
    __asm__ __volatile__("fence");
    lsr = lsr & 0x20;
  } while (lsr != 0x20);
}

/**************************************************
 * Function name	: void Transmit_string_uart(ee_u8 *data_ptr)
 *    returns	: Nil
 *   *Char           : Pointer to the string to be transmitted
 * Description		: Tx character through UART upto '\0'
 * Notes			:
 **************************************************/

void Transmit_uart(UC *data_ptr) {
  // UC lsr;

  while (*data_ptr != '\0') {
    tx_uart(*data_ptr);
    data_ptr++;
  }
}

/**************************************************
 * Function name	: UC Tx_uart(void)
 *    returns		: Nil
 * Tx_char           : Character to Rx
 * Description		: Rx 1 character through UART
 * Notes			:
 **************************************************/

UC rx_uart(void) {
  UC lsr, Rx_char;

  do {
    lsr = uart_regs.UART_LSR;
    __asm__ __volatile__("fence");
  } while ((lsr & 1) == 0);

  Rx_char = uart_regs.UART_DR;
  __asm__ __volatile__("fence");

  // uart_regs.UART_LSR &= ~0x1;  //For emulation only FIXME
  return Rx_char;
}

/**************************************************
 * Function name	: get_decimal()
 * returns		    : Nil
 * Description		:
 * Notes			:
 **************************************************/
UL get_decimal(UC noOfDigits) {
  UC i, rx = 0, ascii[16];
  ;
  UL number = 0, temp = 1;

  for (i = 1; i < noOfDigits; i++)
    temp *= 10;

  i = 0;
  while (1) {

    if (i < noOfDigits) {
      while (1) {
        rx = rx_uart();
        if (rx >= '0' && rx <= '9') {
          tx_uart(rx);
          ascii[i] = rx;
          break;
        }
        if (rx == '\b') {
          if (i > 0) {
            tx_uart(rx);
            tx_uart(' ');
            tx_uart(rx);
            i--;
          }
          continue;
        }
      }
      i++;

    } else if (i == noOfDigits) {
      rx = rx_uart();
      if (rx == '\r') {
        break;
      } else if (rx == '\b') {
        tx_uart(rx);
        tx_uart(' ');
        tx_uart(rx);
        i--;
        continue;
      }
    }
  }
  for (i = 0; i < noOfDigits; i++) {
    ascii[i] -= '0'; // ascii
    number = number + (temp * ascii[i]);
    temp = temp / 10;
  }
  return number;
}

/**************************************************
 * Function name	: get_long_int()
 * returns		    : Nil
 * Description		:
 * Notes			:
 **************************************************/
UL get_long_int(UC noofBytes) {
  UC i, rx = 0, temp[16];
  UI hex_val = 0;
  i = 0;
  while (1) {
    if (i < noofBytes) {
      /*if ((noofBytes == 4) || (noofBytes == 2)) {
       if (i > 0)
       Tx_uart('-');
       }*/
      rx = get_hex();
      if (rx == '\b') {
        if (i > 0) {
          tx_uart(rx);
          tx_uart(' ');
          tx_uart(rx);
          tx_uart(rx);
          tx_uart(' ');
          tx_uart(rx);
          i--;
        }
        continue;
      }
      // temp <<= 8;
      // temp = temp + rx;
      temp[i] = rx;

      i++;
    } else if (i == noofBytes) {
      rx = rx_uart();
      if (rx == '\r') {
        break;
      } else if (rx == '\b') {
        tx_uart(rx);
        tx_uart(' ');
        tx_uart(rx);
        tx_uart(rx);
        tx_uart(' ');
        tx_uart(rx);
        i--;
        continue;
      }
    }
  }

  for (i = 0; i < noofBytes; i++) {
    hex_val <<= 8;
    hex_val |= temp[i];
  }

  return hex_val;
}

/************************************************************
 * Function name		: UC get_hex()
 * returns		    : 1 byte unsigned character (number).
 * Description		: To get hex value and display it to HT.
 *************************************************************/

UC get_hex() {
  unsigned char number = 0, dig1, dig2, count = 2, rx;
  while (count) {
    rx = rx_uart();
    if (rx == '\b') {
      if (count < 2) {
        tx_uart(rx);
        tx_uart(' ');
        tx_uart(rx);
        count++;
        continue;
      } else
        return rx;
    }

    if ((rx >= 0x30) && (rx <= 0x39)) {
      tx_uart(rx);
      rx = rx - 0x30;
    } else if ((rx >= 'A') && (rx <= 'F')) {
      tx_uart(rx);
      rx = rx - 0x37;
    } else if ((rx >= 'a') && (rx <= 'f')) {
      tx_uart(rx);
      rx = rx - 0x57;
    }

    else
      continue;
    if (count == 2)
      dig1 = rx;
    else
      dig2 = rx;
    count--;
  }
  number = (dig1 << 4);
  number |= dig2;
  return number;
}
