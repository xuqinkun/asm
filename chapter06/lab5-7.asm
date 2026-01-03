assume cs:code
data_a segment
   db 1,2,3,4,5,6,7,8,9,0ah,0bh,0ch,0dh,0eh,0fh,0ffh
data_a ends

data_b segment
   db 0,0,0,0,0,0,0,0
data_b ends

code segment
start: mov ax,data_a
       mov ds,ax
       mov ax,data_b
       mov ss,ax
       mov sp,08h

       mov cx,4
       mov bx,0
       mov ax,0      
     s:mov ah,ds:[bx]
       inc bx
       mov al,ds:[bx]
       push ax
       inc bx
       loop s

       mov ax,4c00h
       int 21h
code ends
end start