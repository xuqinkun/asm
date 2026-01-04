assume cs:codesg

codesg segment
	mov ax,0h
	mov cx,00ECH
s:  add ax,7bh
    loop s    
    mov ax,4c00h
    int 21h
codesg ends
end