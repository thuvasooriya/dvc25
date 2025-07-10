
#ifndef INCLUDE_SYSCALLS_H_
#define INCLUDE_SYSCALLS_H_
#ifndef EOF
# define EOF (-1)
#endif


typedef unsigned char  UC;	//1 Byte
typedef unsigned int   UI;	//4 Bytes
typedef unsigned long  UL;	//4 Bytes
typedef unsigned short US;	//2 Bytes
int puts(const char *p);
int printf(const char* fmt, ...);



#endif /* INCLUDE_SYSCALLS_H_ */
