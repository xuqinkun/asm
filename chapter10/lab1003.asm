assume cs:code
data segment
  dw 1,8,3,38,123,12666
  db 10 dup (0)
data ends

code segment
start:    mov ax,data
          mov ds,ax
          add ax,1
          mov es,ax
          mov si,0

          mov bx,0
          mov cx,6

        s:mov ax,[bx]   
          add bx,2      
          call dtoc

          push cx
          mov dx,0
          mov dh,8      ; 第8行
          mov dl,3      ; 第3列
          mov cl,2      ; 绿色
          call show_str
          pop cx
          loop s

          mov ax,4c00h
          int 21h
    dtoc: push bx
          push cx
          mov si,0      ; 计数器
          mov bx,0ah    ; 除数10
        d:mov dx,0
          div bx        ; dx:ax / bx
          add dl,30h     ; '0' + c
          push dx
          mov cx,ax
          inc si
          jcxz reverse
          jmp d
  reverse:mov cx,si
          mov di,0
       s0:pop dx
          mov es:[di],dl
          inc di
          loop s0
          mov byte ptr es:[di],0
          pop cx
          pop bx
          ret

show_str: push ax
          push bx
          push cx
          push dx
          push ds
          push es
          mov si,0
          mov ax,es
          mov ds,ax
          mov al,0Ah
          mov ah,0
          sub dh,1
          mul dh
          add ax,0b800h
          mov es,ax
          mov al,dl
          mov ah,0
          sub ax,1
          mov dl,2
          mul dl
          mov bx,ax
          mov dh,cl
  display:mov cl,[si]
          mov ch,0
          jcxz ok
          mov dl,[si]
          mov es:[bx],dx
          inc si
          add bx,2
          jmp display

      ok: pop es
          pop ds
          pop dx
          pop cx
          pop bx
          pop ax
          ret

code ends
end start