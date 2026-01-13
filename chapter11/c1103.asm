assume cs:code,ds:data

data segment
  db 1,2,3,32,34,39,127,128,129
data ends

code segment
  start:mov ax,data
        mov ds,ax
        mov bx,0
        mov dx,0
        mov cx,32
     s: mov al,[bx]
        cmp al,9
        jb next        ;小于32转到next
        cmp al,128
        ja next        ;大于128转到next
        inc dx
  next: inc bx
        loop s
code ends
end start
