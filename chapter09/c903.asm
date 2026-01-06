assume cs:code

;查找第一个值为0的字节，将地址存到dx中
code segment
start:mov ax,2000h
      mov ds,ax
      mov bx,0

    s:mov cx,[bx]
      jcxz ok
      inc bx

      jmp short s
   ok:mov dx,bx
      mov ax,4c00h
      int 21h
code ends
end start
