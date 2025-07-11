OUTPUT_ARCH( "riscv" )
ENTRY(_start)

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

SECTIONS
{

  /* text: test code section */
  . = 0x10000;/*SOC ROM start address*/
  .text.init : { *(.text.init) }

  .text : 
  { 
  		*(.text)
  }

  /* data segment */
  . = 0x30000; /*SOC IRAM Upper 32KB for data/heap/stack */
  .data : { *(.data) }

  .sdata : {
    __global_pointer$ = . + 0x800;
 /*   *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
  *(.sdata .sdata.* .gnu.linkonce.s.*)*/
  }

  /* bss segment */
  .sbss : {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
  }
  .bss : { *(.bss) }

  /* thread-local data segment */
  .tdata :
  {
    _tls_data = .;
    *(.tdata.begin)
    *(.tdata)
    *(.tdata.end)
  }
  .tbss :
  {
    *(.tbss)
    *(.tbss.end)
  }

  /* End of uninitalized data segement */
  _end = .;
}
