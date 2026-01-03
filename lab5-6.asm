assume cs:code
data_a segment
   db 1,2,3,4,5,6,7,8
data_a ends

data_b segment
   db 1,2,3,4,5,6,7,8
data_b ends

data_c segment
   db 0,0,0,0,0,0,0,0
data_c ends

code segment
start: mov ax,data_a
       mov ds,ax
       mov ax,data_b
       mov es,ax

       mov cx,8
       mov bx,0
     s:mov al,ds:[bx]
       add es:[bx],al
       inc bx
       loop s

       mov ax,data_c
       mov ds,ax
       mov cx,8
       mov bx,0
     t:mov al,es:[bx]
       mov ds:[bx],al
       inc bx
       loop t

       mov ax,4c00h
       int 21h
code ends
end start