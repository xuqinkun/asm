assume cs:code

code segment
   start:mov ax,0
         push ax
         popf
         mov ax,0fff0h
         add ax,0010h
         pushf
         pop ax
         and al,11000101B
         and ah,00001000B
         ret
code ends
end start