assume cs:code

stack segment
  db 16 dup (0)
stack ends

code segment
start: mov ax,0
       call s
       inc ax
     s:pop ax
       ret
code ends
end start
