.686
.model flat, stdcall
option casemap :none
include \masm32\include\windows.inc
include \masm32\macros\macros.asm
uselib kernel32,user32,fpu,masm32

.data
x real10 8.5
_const1 real10 5.1
incr real10 8.5
szfmt db "y%d = %",0
result db 260 dup(?)
buf db 100 dup(?)
titl db "Встроенные masm32-функції сопроцессора",0
count dd 1
uravnenie db "Y = 5.1*(sin(x)) -- 4 results with x - 8.5 each",0
buf2 db 100 dup(?) 
newLine db 0ah,0
avt db "Студент ФІСІТ КНЕУ, каф. ІСЕ"

.code
st1:
    mov edi, 4
    invoke szCatStr, addr result, addr uravnenie
    invoke szCatStr, addr result, addr newLine
    invoke szCatStr, addr result, addr newLine

    finit
    operation:
        ; обчислення sin(x)
        invoke FpuSin, addr x, 0, SRC1_REAL or DEST_FPU
        ; множення на 5.1
        invoke FpuMul, addr _const1, addr x, 0, SRC2_FPU or SRC1_REAL or DEST_FPU

        invoke wsprintf, addr buf2, addr szfmt, count, x
        invoke FpuFLtoA, 0, 5, addr buf, SRC1_FPU or SRC2_DIMM
        invoke szCatStr, addr result, addr buf2
        invoke szCatStr, addr result, addr buf
        invoke szCatStr, addr result, addr newLine

        ; збільшуємо значення x на 8.5 на кожній ітерації
        invoke FpuAdd, addr x, addr incr, addr x, SRC1_REAL or SRC2_REAL or DEST_MEM

        inc count
        dec edi
        jnz operation

    invoke szCatStr, addr result, addr newLine
    invoke szCatStr, addr result, addr avt
    invoke MessageBox, 0, addr result, addr titl, MB_ICONINFORMATION
    invoke ExitProcess, 0
end st1

