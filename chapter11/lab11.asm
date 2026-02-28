assume cs:code
data segment
  db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

code segment
  begin: mov ax,data
         mov ds,ax
         mov si,0
         call letterc

         mov ax,4c00h
         int 21h
 letterc:mov bl,[si]
         cmp bl,0
         je exit
         cmp bl,'a'
         jb next
         cmp bl,'z'
         ja next
         sub bl, 32
         mov [si],bl
         inc si
         jmp letterc
   next: inc si
         jmp letterc
   exit: ret
code ends
end begin
        