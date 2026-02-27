DA_32   EQU 4000h ; 32位代码段
DA_C    EQU 98h   ; 只执行代码段的属性
DA_DRW  EQU 92h   ; 可读写的数据段
DA_DRWA EQU 93h   ; 存在的，已访问的，可读写的

%macro Descriptor 3
    dw %2 & 0FFFFh         ;段界限0~15  (2字节)
    dw %1 & 0FFFFh         ;段基址0~15  (2字节)
    dw (%1 >> 16) & 0FFh   ;段基址16~23 (1字节)
    dw ((%2 >> 8) & 0F00h) | (%3 & 0F0FFh) ; 属性1 + 段界限2 + 属性2 （2字节）
    db (%1 >> 24) & 0FFh   ;段基址24~31 (1字节)
%endmacro


org 0100h          ; dos下调试程序，0100是可用区域
    jmp PM_BEGIN   ; 跳入到标号为PM_BEGIN的代码段，开始执行

[SECTION .gdt]

;GDT                           段基址，     段界限，           属性
PM_GDT:           Descriptor   0         , 0           ,      0
PM_DESC_CODE32:   Descriptor   0         , SegCode32Len - 1,  DA_C    + DA_32
PM_DESC_DATA:     Descriptor   0         , DATALen-1       ,  DA_DRW
PM_DESC_STACK:    Descriptor   0         , TopOfStack      ,  DA_DRWA + DA_32
PM_DESC_TEST :    Descriptor   0200000h  , 0FFFFh          ,  DA_DRW
PM_DESC_VIDEO:    Descriptor   0B8000h   , 0FFFFh          ,  DA_DRW
;end of definition gdt
GdtLen equ $ - PM_GDT
GdtPtr dw GdtLen - 1
dd 0 ; GDT 基地址

;GDT 选择子
SelectorCode32 equ PM_DESC_CODE32 - PM_GDT
SelectorDATA   equ PM_DESC_DATA   - PM_GDT
SelectorSTACK  equ PM_DESC_STACK  - PM_GDT
SelectorTEST   equ PM_DESC_TEST   - PM_GDT
SelectorVIDEO  equ PM_DESC_VIDEO  - PM_GDT

;End of [SECTION .gdt]

[SECTION .data]
ALIGN 32
[BITS 32]
PM_DATA:
PMMessage: db "Protect Mode", 0
OffsetPMMessage equ PMMessage - $$
DATALen equ $ - PM_DATA
; END of [SECTION .data]

;全局的堆栈段
[SECTION .gs]
ALIGN 32
[BITS 32]
PM_STACK:
   times 512 db 0
TopOfStack equ $ - PM_STACK - 1
;End of stack

[SECTION .s16]
[BITS 16]
PM_DEGIN:
   mov ax,cs
   mov ds,ax
   mov es,ax
   mov ss,ax
   mov sp,0100h

   ;初始化32位代码段
   xor eax,eax
   mov ax, cs
   shl eax,4
   add eax,PM_SEG_CODE32
   mov word [PM_DESC_CODE32+2], ax
   shr eax, 16
   mov byte [PM_DESC_CODE32+4], al
   mov byte [PM_DESC_CODE32+7], ah

   ;初始化32位数据段
   xor eax,eax
   mov ax, ds
   shl eax,4
   add eax,PM_DATA
   mov word [PM_DESC_DATA+2], ax
   shr eax, 16
   mov byte [PM_DESC_DATA+4], al
   mov byte [PM_DESC_DATA+7], ah


   ;初始化32位stack段
   xor eax,eax
   mov ax, ds
   shl eax,4
   add eax,PM_STACK
   mov word [PM_DESC_STACK+2], ax
   shr eax, 16
   mov byte [PM_DESC_STACK+4], al
   mov byte [PM_DESC_STACK+7], ah

[SECTION .s32]
[BITS 32]
PM_SEG_CODE32:

SegCode32Len equ $-PM_SEG_CODE32