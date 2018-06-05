.section .text

.globl _start
_start:
  lui  x1 , x0, 0x12345
  addi x1 , x1, 0x678

  st   x1 , data0(x0)
  sth  x1 , data1(x0) 
  stb  x1 , data2(x0)

  lw   x2 , data0(x0) 
  lw   x3 , data1(x0) 
  lw   x4 , data2(x0) 

  lwh  x5 , data0(x0) 
  lwh  x6 , data1(x0) 
  lwh  x7 , data2(x0) 

  lwb  x8 , data0(x0)  
  lwb  x9 , data1(x0)  
  lwb  x10, data2(x0)  

.data
data0: 
  .word 0x00000000
data1: 
  .word 0x00000000
data2: 
  .word 0x00000000

