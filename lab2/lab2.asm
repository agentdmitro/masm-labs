.486                                    ; create 32 bit code
    .model flat, stdcall                    ; 32 bit memory model
    option casemap :none                    ; case sensitive
     include \masm32\include\windows.inc     ; always first
    include \masm32\macros\macros.asm       ; MASM support macros
  ; -----------------------------------------------------------------
  ; include files that have MASM format prototypes for function calls
  ; -----------------------------------------------------------------
    include \masm32\include\masm32.inc
    include \masm32\include\gdi32.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\msvcrt.lib
  ; ------------------------------------------------
  ; Library files that have definitions for function
  ; exports and tested reliable prebuilt code.
  ; ------------------------------------------------
    includelib \masm32\lib\masm32.lib
    includelib \masm32\lib\gdi32.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib
.data	; директива определения данных
_temp1 dd ?,0
_temp2 dd ?,0
_const1 dd 2
_const2 dd 7
_const3 dd 8
_const4 dd 9
_const5 dd 1
_title db "Лабораторна робота №2. операції порівнняння",0
strbuf dw ?,0
_text db "masm32.  Вивід результата через MessageBox:",0ah,
"y= 2a/7 - c/7e e>a",0ah,
"y= 8/d - 9d/c e<=a",0ah,
"Результат: %d — ціла частина",0ah, 0ah,
"СТУДЕНТ КНЕУ  ФІСІТ",0
MsgBoxCaption  db "Пример окна сообщения",0 
MsgBoxText_1     db "порівнняння  _e >_a",0 
MsgBoxText_2     db "порівнняння  _e<=_a",0 

.const 
   NULL        equ  0 
   MB_OK       equ  0 

.code	; директива начала сегмента команд
_start:	; метка начала программы с именем _start
 
main proc
LOCAL _e: DWORD 
LOCAL _a: DWORD 
LOCAL _c: DWORD
LOCAL _d: DWORD 

mov _e, sval(input("vvedite e = "))
mov _a, sval(input("vvedite a = "))
mov _c, sval(input("vvedite c = "))
mov _d, sval(input("vvedite d = "))
 
mov ebx, _e 
mov eax, _a ;здесь мы записали число _c в регистр eax.
sub ebx, eax   ; порівняння  _e<=_a
   
	jle zero

; zero ;осуществляем переход на метку zero,
;если флаг ZF установлен.
;Если  не , то выполнение продолжится дальше

;2a/7 - c/7e e>a

mov eax, _const1      
mul _a                
div _const2
mov ecx, eax          

mov eax, _const2      
mul _e               
mov ebx, eax          
mov eax, _c           
div ebx               
sub ecx, eax          
mov _temp1, ecx       

INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK 
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0

jmp lexit ;переходим на метку exit (GOTO exit)
 zero:
 
;y=8/d - 9d/c e<=a

mov eax, _const3      
mul _const5           
div _d
mov ecx, eax          

mov eax, _c           
mov ebx, eax          

mov eax, _const4      
mul _d               
div ebx               
sub ecx, eax          
mov _temp2, ecx       

INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK 
invoke wsprintf, ADDR strbuf, ADDR _text, _temp2
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0

 lexit:
 ret
main endp
 ret                     ; возврат управления ОС
end _start          ; завершение программы с именем _start
