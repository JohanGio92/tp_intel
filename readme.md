# TP intel
Enunciado 101

### Instrucciones para obtener el ejecutable
#### Ensamblado:
Se debe correr nasm, lo testeé sobre Ubuntu 16.04LTS de 64 bits
```
nasm -fOBJ tp.asm
```
#### Linkeo
Desde DOSbox (probé la versión 0.74 bajo Ubuntu 16.04LTS de 64 bits), se debe
montar este directorio, iniciar un DPMI y linkear con ALINK, cuyos archivos
están incluidos en este repositorio
```
mount c ~/Documents/GitHub/organizacion_del_computador/TP_intel/
c:
cwsdpmi.exe -p
alink.exe -oEXE -o tp.exe tp.obj
```

---
Realizado por Juan Pablo Capurro

Padrón 98194
