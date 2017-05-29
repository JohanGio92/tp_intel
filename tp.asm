segment pila stack
    resb 4096

segment datos data
errormsg:           db  'Error al abrir el archivo. Saliendo.$'
pedirFilenameMsg:   db 'Ingrese el nombre del archivo: $'
askShowIntermediatesMsg: db 'Ingrese s si quiere ver los pasos intermedios, otro caracter en caso contrario: $'
fNamebuffer:        db  255
                    db  0
filename:           resb 256
                    db   0dh
fileHandle:         resw 1
fileBuffer:         resb 1

vectorLength:       resw 1
vector:             times 256 resw 1
vectorIndex:        resw 1
otherVectorIndex:   resw 1

base10:             dw 10;
bpfToShow:          resw 1
asciiRep:           times 8 resb 1

showIntermediates:  resb 1
;variables usadas en el sort
indexI:             resw 1
indexJ:             resw 1
comparator:         resw 1

segment code
..start:
    mov     ax,datos
    mov     ds,ax
    mov     ax,pila
    mov     ss,ax

    call    getFilename
    call    getShowIntermediates
    call    fOpen
    call    loadFile

    call    showVector
    call    sortVector
    call    showVector

    call    fClose
    jmp     fin

sortVector:
    mov     word[indexI],0
        outerLoop:
        mov     ax,word[indexI]
        mov     word[indexJ],ax
            innerLoop:
            mov     ax,[indexJ]
            mov     si,ax
            mov     ax,[vector+si]
            mov     [comparator],ax
            mov     ax,vector
            add     ax,si
            mov     bx,ax
            mov     ax,[indexI]
            mov     si,ax
            mov     ax,[vector+si]
            cmp     ax,[comparator];en ax esta v[i],
            jge     noSwap
            mov     [bx],ax
            mov     ax,[comparator]
            mov     [vector+si],ax
            noSwap:

            inc     word[indexJ]
            inc     word[indexJ]
            mov     ax,[indexJ]
            cmp     ax,[vectorLength]
            jl      innerLoop

        cmp     byte[showIntermediates],'s'
        jne     noshow
        call    showVector
        noshow:

        inc     word[indexI]
        inc     word[indexI]
        mov     ax,[indexI]
        cmp     ax,[vectorLength]
        jl      outerLoop
    ret

getShowIntermediates:
    mov     dx,askShowIntermediatesMsg
    mov     ah,9
    int     21h
    mov     ah,1
    int     21h
    mov     [showIntermediates],al
    call    printNewline
    ret

getFilename:
    mov     dx,pedirFilenameMsg
    mov     ah,9
    int     21h
    mov     dx,fNamebuffer
    mov     ah,0ah
    int     21h
    mov     ax,0
    mov     al,[filename-1]
    mov     si,ax
    mov     byte[filename+si],0
    ret

showVector:
    mov     si,0
    mov     ax,0
    mov     [vectorIndex],ax
        loopOverVector:
        mov     ax,[vectorIndex]
        mov     si,ax
        mov     ax,[vector+si]
        mov     [bpfToShow],ax
        inc     si
        inc     si
        mov     [vectorIndex],si
        call    showBpf
        mov     ax,[vectorIndex]
        cmp     ax,[vectorLength]
        jl      loopOverVector
    call    printNewline
    ret

showBpf:
    cmp     word[bpfToShow],0
    jl      negativo
    mov     byte[asciiRep],'0'
    jmp     convertToStr
    negativo:
    mov     byte[asciiRep],'-'
    neg     word[bpfToShow]
    convertToStr:
    mov     ax,[bpfToShow]
    mov     si,5
        loopOverNumber:
        mov     dx,0
        div     word[base10]
        mov     byte[asciiRep+si],dl
        add     byte[asciiRep+si],'0'
        dec     si
        cmp     si,0
        je      conversionEnd
        jmp     loopOverNumber
    conversionEnd:
    mov     byte[asciiRep+6],' '
    mov     byte[asciiRep+7],'$'
    mov     dx,asciiRep
    mov     ah,9
    int     21h
    ret

loadFile:
    mov     ax,0
    mov     si,ax
        loopFile:
        mov     bx,[fileHandle]
        mov     cx,2
        mov     dx,fileBuffer
        mov     ah,3fh
        int     21h
        jc      fileError   ;no es error al abrir pero xd
        cmp     ax,2
        jne     onEOF
        mov     ax,vector
        mov     bx,ax
        mov     ax,[fileBuffer]
        mov     [bx+si],ax
        inc     si
        inc     si
        jmp     loopFile
    onEOF:
    mov     [vectorLength],si
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

printNewline:
    mov     dl,0dh;\r
    mov     ah,2
    int     21h
    mov     dl,0ah;\n
    mov     ah,2
    int     21h
    ret

fin:
    mov     ax,4c00h
    int     21h
