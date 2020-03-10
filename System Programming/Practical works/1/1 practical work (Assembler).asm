;==============================================НОМЕР 1.2-3=============================================================
; Первая практическая работа, узнающая, что является-ли число квадратом какого-либо иного числа. Если да,то какого именно? 
;=======================================================================================================================

format MZ
mov ax,cs
mov ds,ax

;Input
mov AH,3fh ;3fh - ввод
mov DX,buffer ;DX = адрес строки
mov BX,0 ;BX = 0 ввод с клавиатуры (stdin)
mov CX,100 ;вводим 10 байт
int 21h ;в буфер помещается строка,число символов в AX

;String > Int (схема Горнера)
mov SI,0 ;в SI храним число-результат
mov BX,buffer ;bx - адрес 1го символа
mov CX,AX ;cx - число символов

cont: mov AX,10 ;умножаем на 10
mul SI ;DX:AX=AX*SI
mov SI,AX ;результат умножения пишем в SI
mov AX,0
;символ 1 байт
mov AL,[BX] ;AX=AH:AL ;AX-код символа (AX=AH:AX)
sub AL,48 ;получаем из символа цифру
add SI,AX ;прибавляем цифру

inc BX ;bx=bx+1 ;BX - адрес следующего символа
;заканчиваем цикл если
;а)встретилась не цифра
;б)закончились символы
mov AL,[BX]
cmp AL,48
jb NOTD ;jump if below
cmp AL,57
ja NOTD ;jump if above

loop cont
NOTD:


mov ax,0
mov cx,0

ml:
inc cx ; Добавляем 1 к cx
mov ax,cx ; Перенос cx в ax
mul ax ; Умножаем на ax

cmp ax,si ; Сравнение SI с AX
je found ; Прыжок если больше
jb ml ; Прыжок если меньше
;nfound:
mov cx,0
found: mov si,cx


;Int > String
mov AX,SI ; ax - число
mov BX,buffer+100 ;bx адрес конца строки

cont2: mov CX,10 ;делим на 10
mov DX,0
div CX
add DX,48;dx - символ

dec BX
mov [BX],DL;

cmp AX,0
jne cont2

;Output
mov DX,BX;dx - адрес начала строки

mov CX,buffer+100
sub CX,BX;cx - длина сторки

;mov cx,ax ;cx - сколько байт
;mov dx,buffer ;DS:DX - адрес

mov BX,1 ;bx = 1 вывод на экран
mov AH,40h ;40h - вывод
int 21h

;Exit
mov ax,4c00h
int 21h

;Data
buffer db 100 dup (?)