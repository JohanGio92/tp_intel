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


fin:
    mov ax,4c00h
    int 21h
