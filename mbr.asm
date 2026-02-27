; 将第二个扇区里面的内容加载进入内存
;mbr.asm loader.asm
;0       1
;将loader放入0x900

LOADER_BASE_ADDR    equ 0x900
LOADER_START_SECTOR equ 0x1    ;表示以LBA方式，loader存放在第2块扇区

SECTION MBR vstart=0x7c00
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov fs,ax
    mov sp,ax
    mov ax,0xb800
    mov gs,ax
;利用0x06的功能，调用10号中断
;AH = 0x06
;AL = 0    表示全部都要清除
;BH = 上卷行的属性
;(CL,CH) 左下角坐标 x,y
;(DL,DH) 右下角坐标 
    mov ax,0600h
    mov bx,0700h
    mov cx,0
    mov dx,184fh  ;(80,25)
    int 10h

; 输出当前在MBR
    mov byte [gs:0],'1'
    mov byte [gs:1],0xa4
    
    mov byte [gs:2],' '
    mov byte [gs:3],0xa4

    mov byte [gs:4],'M'
    mov byte [gs:5],0xa4

    mov byte [gs:6],'B'
    mov byte [gs:7],0xa4

    mov byte [gs:8],'R'
    mov byte [gs:9],0xa4

    mov eax, LOADER_START_SECTOR ; LBA读入的扇区
    mov bx, LOADER_BASE_ADDR     ; 写入的目的地址
    mov cx, 1                    ; 等待读入的扇区数
    call rd_disk

    jmp LOADER_BASE_ADDR         ; 跳到实际的物理地址

     rd_disk:
     ; eax LBA 扇区号
     ; bx  写入的内存地址
     ; cx  等待读入的扇区数
     mov esi, eax         ; 备份eax
     mov di, cx
     ;读写硬盘
     mov dx, 0x1f2
     mov al, cl         ;1
     out dx, al
     mov eax,esi
     ; 将LBA的地址存入0x1f3,0x1f6
     mov dx, 0x1f3
     out dx,al

     ;15-8位写给1f4
     mov cl,8
     shr eax,cl
     mov dx,0x1f4
     out dx,al

     ;25-16 写入1f5
     shr eax,cl
     mov dx,0x1f5
     out dx,al

     shr eax,cl
     and al,0x0f
     or  al,0xe0   ; 设置7~4位1110，此时是LBA模式
     mov dx,0x1f6
     out dx,al

     ;向0x1f7写入读命令
     mov dx,0x1f7
     mov al,0x20   ; 0x20 是 "Read Sectors" 命令
     out dx,al

     ;监测硬盘状态
     .not_ready:
     nop
     in  al,dx
     and al,0x88  ; 第4位为1，表示可以传输，7位为1表示硬盘繁忙
     cmp al,0x08
     jnz .not_ready

     ; 读数据
     mov ax,di
     mov dx,256
     mul dx
     mov cx,ax
     mov dx,0x1f0

    .go_on:
     in   ax,dx    ; 从硬盘一次读 2 字节 (16 位)
     mov  [bx],ax  ; 存入内存
     add  bx,2     ; 内存指针 +2
     loop .go_on   ; CX 减 1，不为 0 则跳转
     ret
     times 510 - ($-$$) db 0
	 dw 0xaa55
