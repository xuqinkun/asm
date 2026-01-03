assume cs:codesg,ds:datasg

datasg segment
  db '1. file         '
  db '2. edit         '
  db '3. search       '
  db '4. view         '
  db '5. options      '
  db '6. help         '
datasg ends

codesg segment
 start:mov ax,datasg
       mov ds,ax

       mov cx,6
       mov bx,0
       mov si,3

     s:mov al,[bx+si]
       and al,11011111b
       mov [bx+si],al
       add bx, 10h
       loop s

       mov ax,4c00h
       int 21h

codesg ends

end start

