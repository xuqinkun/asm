assume cs:code,ds:data

data segment
   db 'welcome to masm!'
data ends

code segment
  start: mov ax,0B870h
         mov ds,ax
         mov ax,data
         mov es,ax
         mov si,08h
         mov di,0

         mov bx,0
         mov cx,10h
       s:mov al,es:[bx]
         mov ah,02h
         mov [si],ax
         inc bx
         add si,2
         loop s
code ends
end start
