#include<stdio.h>
#include<inttypes.h>
#include<stdlib.h>
#include<time.h>

/*
Aprovecho el hecho de que tanto la arquitectura de mi computadora como la
que emulo en DOSbox son little endian para generar archivos como los que
especifica el enunciado.
*/
const size_t LARGO_ARCHIVO = 2;
const char* NOMBRE_ARCHIVO = "file.bpf";
const size_t BITS_PER_FIELD =16;
const size_t BYTES_PER_FIELD =2;

int main(){
    srand((unsigned int)clock());
    FILE* archivo = fopen(NOMBRE_ARCHIVO,"w");
    if(!archivo)
        return -1;
    for(size_t i =0;i<LARGO_ARCHIVO;i++){
        int16_t valor = 1;//(int16_t) (rand()%(2*INT16_MAX))-INT16_MAX;
        printf("%"PRId16,valor);
        fwrite(&valor,BYTES_PER_FIELD,1,archivo);
        puts("");
    }
    fclose(archivo);
}
