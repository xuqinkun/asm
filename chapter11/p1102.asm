assume cs:code,ds:data
data segment
  db 'Welcome to masm!'
  db 16 dup (0)
data ends

code segment
   start: mov ax,data
          mov ds,ax
          mov es,ax
          mov si,0
          mov di,16
          mov cx,16
          cld
          rep movsb
          ret
code ends
end start