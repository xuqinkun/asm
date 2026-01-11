assume cs:code

code segment
  start: mov ax,4240h
         mov dx,000fh
         mov cx,0ah
         call divdw
         mov ax,4c00h
         int 21h
   divdw:push ax   ; 将被除数低16位放入栈
         mov ax,dx ; 将被除数高16位赋值给ax
         mov dx,0  ; 
         div cx    ; 将被除数高16位除以cx
         mov bx,ax ; 将商放到bx中
         pop ax    ; 恢复被除数低16位
         div cx    ; 
         mov cx,dx
         mov dx,bx
         ret
code ends
end start




