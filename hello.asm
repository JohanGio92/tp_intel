segment pila stack
    resb 64

segment datos data
filename:   db  'history.txt',0

segment code
..start:
    mov ax,datos
    mov ds,ax
    mov ax,pila
    mov ss,ax

    mov dx,filename
    mov al,0
    mov ah,3dh
    int 21h


fin:
    mov ax,4c00h
    int 21h
