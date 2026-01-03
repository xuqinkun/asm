assume cs:codesg,ds:data
data segment
  db 'welcome to masm!'
  db '................'
data ends
codesg segment

start: mov ax,data
       mov ds,ax
       mov si,0

       mov cx,8
     s:mov ax,[si]
       mov [si+16],ax
       add si,2
       loop s

       mov ax,4c00h
       int 21h
codesg ends
end start