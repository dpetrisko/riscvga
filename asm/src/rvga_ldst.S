.section .text

.globl _start
_start:
  nop
  nop
  nop
  nop
  lui  x1  , 0x1234
  addi x1  , x1, 0x56 
  la   x2  , data0
  la   x3  , data1
  la   x4  , data2

  sw  x1  , 0(x2)
  sh  x1  , 0(x3) 
  sb  x1  , 0(x4)

  lw  x5  , 0(x2) 
  lw  x6  , 0(x3) 
  lw  x7  , 0(x4) 

  lh  x8  , 0(x2) 
  lh  x9  , 0(x3) 
  lh  x10 , 0(x4) 

  lb  x11 , 0(x2) 
  lb  x12 , 0(x3)  
  lb  x13 , 0(x4)  

HALT:
  j HALT
  nop

.section .data
data0: .word 0x00000000
data1: .word 0x00000000
data2: .word 0x00000000
