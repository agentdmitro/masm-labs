.486; директива визначення типу мікропроцесора
    .model flat, stdcall  ;визначення лінійної моделі пам’яті
    option casemap :none;розділення верхнього та нижнього регістрів
    include \masm32\include\windows.inc ; підключення програмного файлу windows.inc
    include \masm32\macros\macros.asm       ; MASM support macros
    include \masm32\include\masm32.inc; підключення програмного файлу masm.inc
    include \masm32\include\gdi32.inc; підключення програмного файлу gdi32.inc
    include \masm32\include\fpu.inc; підключення програмного файлу  fpu.inc
    include \masm32\include\user32.inc; підключення програмного файлу user32.inc
    include \masm32\include\kernel32.inc; підключення програмного файлу kernel32.inc
    include \masm32\include\msvcrt.inc; підключення програмного файлу msvcrt.inc
    includelib \masm32\lib\msvcrt.lib; підключення бібліотеки  msvcrt.lib
    includelib \masm32\lib\fpu.lib; підключення бібліотеки  fpu.lib
    includelib \masm32\lib\masm32.lib; підключення бібліотеки  masm32.lib
    includelib \masm32\lib\gdi32.lib; підключення бібліотеки  gdi32.lib
    includelib \masm32\lib\user32.lib; підключення бібліотеки  user32.lib
    includelib \masm32\lib\kernel32.lib; підключення бібліотеки  kernel32.lib
    .data	; директива визначення данних
    _r DWORD 0.0;оголошення змінної r
    _const0_2 DWORD 0.2;оголошення константи
    _const0_5 DWORD 0.5;оголошення константи
    _e DWORD 2.7;оголошення константи
    _const0_35 DWORD 0.35;оголошення константи
    borderLeft DWORD -3.0;оголошення змінної borderLeft
    borderRight DWORD 4.0;оголошення змінної borderRight
    _title db "Лабораторна робота №4",0;назва вікна повідомлення
    strbuf dw ?,0
    _text db "masm32. ІІТвЕ КНЕУ. ",10 ,"Вивід результата через MessageBox:", 10,
    "v=x + cos(x+0.2)        x < -3", 10,
    "v=arctg(0.5x-0.35)     -3 <= x <= 4", 10,
    "v=e^x + lg(sqrt(x) + sin(x))  4 < x", 10,
    "Результат: " 
    _res db 10 DUP(0),10,13
    MsgBoxCaption  db "Результат порівняння",0 
    MsgBoxText_1     db "x < -3",0 
    MsgBoxText_2     db "-3 <= x <= 4", 0
    MsgBoxText_3     db "4 < x", 0; виведення на екран користувачу повідомлення про результат

    .const 
    NULL        equ  0 
    MB_OK       equ  0 

    .code	; директива початку сегменту команд
    _start:	; мітка початку програми з іменем _start
 
    main proc;директива proc
    LOCAL _x: DWORD;оголошення змінної х

    mov _x, sval(input("Enter x: "));виведення х для вибору користувача

    finit;ініціалізація співпроцесора
           
    fild _x;завантаження х у верхівку стеку
    fstp _x;збереження х з виштовхуванням з стеку
        
    fld borderLeft;завантаження змінної у верхівку стеку
    fld _x;завантаження х у верхівку стеку, зміщення змінної у st(1)
    fcompp;порівняння вершини стека з операндом
    fstsw ax;записує значення слова стану fpu в регістр
    sahf ;запис вмісту регістра в регістр прапорів процесора 
    jb first;джамп 
    fld borderRight;записуємо змінну у верхівку стеку
    fld _x;записуємо змінну х у верхівку стеку, попередня змінна в st(1)
    fcompp;порівняння вершини стека з операндом
    fstsw ax;записує значення слова стану fpu в регістр
    sahf;запис вмісту регістра в регістр прапорів процесора
    jbe second;джамп
    
    ; y = e^x + lg(sqrt(x) + sin(x))
    fld _x;занесення х у верхівку стеку
    fsin; 
    fld _x;
    fsqrt;піднесення до квадратного кореню
    fadd;
    fyl2x
    fld1
    fld _x ;записуємо х у верхівку стеку
    fldl2e ;завантажуємо константу log2(e)
    fmulp st(1), st(0) ;перемножуємо вміст st(1), st(0)
    fld1 ;записуємо 1 у верхівку стеку
    fld st(1) ;записуємо вміст st(1) у верівку стеку( st(0))
    fprem ;знаходимо залишок від ділення
    f2xm1 ;рахуємо 2^x -1
    faddp st(1), st(0) ;додаємо вмістр регістрів
    fscale ;множимо st на 2 в стeпені st(1)

    INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_3, ADDR MsgBoxCaption, MB_OK 
    invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
    invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
    invoke ExitProcess, 0

    jmp lexit ;переходимо на мітку exit (GOTO exit)
    
    ;y=x+cosx  / y=x+cos(x+0.2)
    first:;мітка
    fld _x;занесення х у верхівку стеку
    fadd _const0_2;
    fcos;знаходження косинусу
    fadd _x;додавання х
    
   INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK 
    invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
    invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
    invoke ExitProcess, 0


    jmp lexit

    ;arctg(0.5x-0.35)
    second:;мітка 2
    fld _x;занесення х у верхівку стеку
    fmul _const0_5;
    fsub _const0_35; додавання константи
    fld1
    fpatan;знаходження арктангенсу
    
   INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR      MsgBoxCaption, MB_OK 
    invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
    invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
    invoke ExitProcess, 0

   
    lexit:
    ret
    main endp
    ret                     ; повернення управління ОС
    end _start          ; завершення програми з ім’ям  _start
