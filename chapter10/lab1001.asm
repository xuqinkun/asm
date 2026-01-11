assume cs:code
data segment
  db 'Welcome to masm!',0
data ends

code segment
start:    mov dh,8
          mov dl,3
          mov cl,2
          mov ax,data
          mov ds,ax
          mov si,0
          call show_str

          mov ax,4c00h
          int 21h

show_str: push ax
          push cx
          push ds
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

      ok: pop ds
          pop cx
          pop ax
          ret

code ends
end start