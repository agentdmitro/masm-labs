;�������� 1.2. г�����  ������� 4d/4a � 6cd   �� masm32:
.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
firstfunc PROTO _d:DWORD,_const1:DWORD,_c1:DWORD,_const2:DWORD,_a:DWORD,_c2:DWORD
.data   ;4d/4a � 6cd
const1 dd 4;	 ����������  const1 �� ����� ��������� ����� � ��������� 4
d dd 5	; ����������  d �� ����� ��������� ����� � ��������� 5
const2 dd 4;	 ����������  const1 �� ����� ��������� ����� � ��������� 4
c1 dd 1		; ����������  c1 �� ����� ��������� ����� � ��������� 1
const3 dd 6	; ����������  const2 �� ����� ��������� ����� � ��������� 6
a dd 2	; ���������� a �� ����� ��������� ����� � ��������� 2
c2 dd 1; ����������  c2 �� ����� ��������� ����� � ��������� 1

_temp1 dd ?,0
_title db "����������� ������ �1. �����. ��������",0
strbuf dw ?,0
_text db "masm32. ���� ���������� 4d/4a � 6cd ����� MessageBox:",0ah,"���������: %d � ���� �������",0ah, 0ah,
"������� ����  ԲѲ�",0
.code
firstfunc proc _d:DWORD,_const1:DWORD,_c1:DWORD,_const2:DWORD,_a:DWORD,_c2:DWORD
mov eax,_d
mul _c1
div _const1
mov _temp1, eax
mov eax, _const2
mul _a
mul _c2
sub _temp1,eax
ret 
firstfunc endp

start:
invoke firstfunc,d,const1,c1,const2,a,c2
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0
END start
