segment pila stack
    resb 64

segment datos data
filename:   db  'history.txt',0
errormsg:   db  'Error al abrir el archivo. Saliendo.$'
fileHandle: resw 1
fileBuffer: resb 1

segment code
..start:
    mov     ax,datos
    mov     ds,ax
    mov     ax,pila
    mov     ss,ax
    call    fOpen
    call    loopOverFile
    call    fClose
    jmp     fin

loopOverFile:
    mov     bx,[fileHandle]
    mov     cx,1
    mov     dx,fileBuffer
    mov     ah,3fh
    int     21h
    jc      fileError   ;no es error al abrir pero xd
    cmp     ax,1
    jne     onEOF
    mov     dl,[fileBuffer]
    mov     ah,2
    int     21h
    jmp     loopOverFile
onEOF:
    ret

fileError:
    mov     dx,errormsg
    mov     ah,9
    int     21h
    jmp     fin

fOpen:
    mov     dx,filename
    mov     al,0
    mov     ah,3dh
    int     21h
    jc      fileError
    mov     [fileHandle],ax
    ret

fClose:
    mov     bx,[fileHandle]
    mov     ah,3eh
    int     21h
    ret

fin:
    mov     ax,4c00h
    int     21h
