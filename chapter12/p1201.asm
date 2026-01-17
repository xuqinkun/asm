assume cs:code
code segment

start: mov ax,cs
       mov ds,ax
       mov si,offset do0
       mov ax,0
       mov es,ax
       mov di,200h
       mov cx,offset doend - offset do0
       cld
       rep movsb

       mov ax,0
       mov ds,ax
       mov si,0
       mov [si],0200h              
       mov [si+2],ax
       mov ax,4c00h
       int 21h
  do0: jmp short do0start
       db 'overflow'
do0start: 
       mov ax,cs
       mov ds,ax
       mov si,202h

       mov ax,0b800h
       mov es,ax
       mov di,12*160+36*2
       
       mov cx,9
    s: mov bl,[si]
       mov es:[di],bl
       inc si
       add di,2
       loop s
       mov ax,4c00h
       int 21h
doend: nop
code ends
end start