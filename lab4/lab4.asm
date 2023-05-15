.486; ��������� ���������� ���� �������������
    .model flat, stdcall  ;���������� ����� ����� �����
    option casemap :none;��������� ��������� �� �������� �������
    include \masm32\include\windows.inc ; ���������� ����������� ����� windows.inc
    include \masm32\macros\macros.asm       ; MASM support macros
    include \masm32\include\masm32.inc; ���������� ����������� ����� masm.inc
    include \masm32\include\gdi32.inc; ���������� ����������� ����� gdi32.inc
    include \masm32\include\fpu.inc; ���������� ����������� �����  fpu.inc
    include \masm32\include\user32.inc; ���������� ����������� ����� user32.inc
    include \masm32\include\kernel32.inc; ���������� ����������� ����� kernel32.inc
    include \masm32\include\msvcrt.inc; ���������� ����������� ����� msvcrt.inc
    includelib \masm32\lib\msvcrt.lib; ���������� ��������  msvcrt.lib
    includelib \masm32\lib\fpu.lib; ���������� ��������  fpu.lib
    includelib \masm32\lib\masm32.lib; ���������� ��������  masm32.lib
    includelib \masm32\lib\gdi32.lib; ���������� ��������  gdi32.lib
    includelib \masm32\lib\user32.lib; ���������� ��������  user32.lib
    includelib \masm32\lib\kernel32.lib; ���������� ��������  kernel32.lib
    .data	; ��������� ���������� ������
    _r DWORD 0.0;���������� ����� r
    _const0_2 DWORD 0.2;���������� ���������
    _const0_5 DWORD 0.5;���������� ���������
    _e DWORD 2.7;���������� ���������
    _const0_35 DWORD 0.35;���������� ���������
    borderLeft DWORD -3.0;���������� ����� borderLeft
    borderRight DWORD 4.0;���������� ����� borderRight
    _title db "����������� ������ �4",0;����� ���� �����������
    strbuf dw ?,0
    _text db "masm32. ����� ����. ",10 ,"���� ���������� ����� MessageBox:", 10,
    "v=x + cos(x+0.2)        x < -3", 10,
    "v=arctg(0.5x-0.35)     -3 <= x <= 4", 10,
    "v=e^x + lg(sqrt(x) + sin(x))  4 < x", 10,
    "���������: " 
    _res db 10 DUP(0),10,13
    MsgBoxCaption  db "��������� ���������",0 
    MsgBoxText_1     db "x < -3",0 
    MsgBoxText_2     db "-3 <= x <= 4", 0
    MsgBoxText_3     db "4 < x", 0; ��������� �� ����� ����������� ����������� ��� ���������

    .const 
    NULL        equ  0 
    MB_OK       equ  0 

    .code	; ��������� ������� �������� ������
    _start:	; ���� ������� �������� � ������ _start
 
    main proc;��������� proc
    LOCAL _x: DWORD;���������� ����� �

    mov _x, sval(input("Enter x: "));��������� � ��� ������ �����������

    finit;����������� ������������
           
    fild _x;������������ � � �������� �����
    fstp _x;���������� � � �������������� � �����
        
    fld borderLeft;������������ ����� � �������� �����
    fld _x;������������ � � �������� �����, ������� ����� � st(1)
    fcompp;��������� ������� ����� � ���������
    fstsw ax;������ �������� ����� ����� fpu � ������
    sahf ;����� ����� ������� � ������ ������� ��������� 
    jb first;����� 
    fld borderRight;�������� ����� � �������� �����
    fld _x;�������� ����� � � �������� �����, ��������� ����� � st(1)
    fcompp;��������� ������� ����� � ���������
    fstsw ax;������ �������� ����� ����� fpu � ������
    sahf;����� ����� ������� � ������ ������� ���������
    jbe second;�����
    
    ; y = e^x + lg(sqrt(x) + sin(x))
    fld _x;��������� � � �������� �����
    fsin; 
    fld _x;
    fsqrt;��������� �� ����������� ������
    fadd;
    fyl2x
    fld1
    fld _x ;�������� � � �������� �����
    fldl2e ;����������� ��������� log2(e)
    fmulp st(1), st(0) ;����������� ���� st(1), st(0)
    fld1 ;�������� 1 � �������� �����
    fld st(1) ;�������� ���� st(1) � ������ �����( st(0))
    fprem ;��������� ������� �� ������
    f2xm1 ;������ 2^x -1
    faddp st(1), st(0) ;������ ����� �������
    fscale ;������� st �� 2 � ��e��� st(1)

    INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_3, ADDR MsgBoxCaption, MB_OK 
    invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
    invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
    invoke ExitProcess, 0

    jmp lexit ;���������� �� ���� exit (GOTO exit)
    
    ;y=x+cosx  / y=x+cos(x+0.2)
    first:;����
    fld _x;��������� � � �������� �����
    fadd _const0_2;
    fcos;����������� ��������
    fadd _x;��������� �
    
   INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK 
    invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
    invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
    invoke ExitProcess, 0


    jmp lexit

    ;arctg(0.5x-0.35)
    second:;���� 2
    fld _x;��������� � � �������� �����
    fmul _const0_5;
    fsub _const0_35; ��������� ���������
    fld1
    fpatan;����������� �����������
    
   INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR      MsgBoxCaption, MB_OK 
    invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
    invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
    invoke ExitProcess, 0

   
    lexit:
    ret
    main endp
    ret                     ; ���������� ��������� ��
    end _start          ; ���������� �������� � ����  _start
