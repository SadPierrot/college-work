program PracticalWork20;
uses crt;

type
      village = record
        name: string[255];
        developer: string[255];
        square: integer;
        citizens: integer;
      end;
Type
   MenuType = (Vertical, Horizontal);
   MenuTypeSort = (VerticalSort, HorizontalSort);

const
   width = 12; { В поле такой ширины будут выводиться пункты меню }
   nItems = 7;  { Количество элементов меню }

   widthSort = 12;
   nItemsSort = 5;

   optText1: array[0 .. pred(nItems)] of string = (
     'Add ', 'Delete', 'Change' , 'Sort', 'Table', 'Search', 'Exit'
   );
   optTextSort: array[0..pred(nItemsSort)] of string = (
   'Sort by name', 'Sort by developer', 'Sort by square', 'Sort by citizens', 'Exit'
   );
   optNormal = LightGray;
   optSelected = Yellow;

var
   X, Y, selected, row: integer;
   xSort, ySort, selectedSort, rowSort:integer;
   _style: menuType;
   _styleSort: menuTypesort;
   mas: array[0..100] of village;
   count: integer;

   function min(a, b: integer): integer;
  begin
    if a < b then
      min := a
    else
      min := b;
  end;

   procedure verticalLine(x, y, a, b, c: integer);   //Рисует вертикальные линии в таблице
  var
    i: integer;
  begin
    gotoxy(x, y);
    Write(#203);
    for i := 1 to a do
    begin
      Inc(y);
      gotoxy(x, y);
      Write(#186);
    end;
    gotoxy(x, c);
    Write(#202);
    y := 1;
    gotoxy(x, y + 3);
    for i := 1 to b do
    begin
      y := y + 2;
      gotoxy(x, y);
      Write(#206);
    end;
  end;

  procedure horizontalLine(x, y, z, b, c: integer);  //Рисует горизонтальные линии в таблице
  var
    i, a: integer;
  begin
    for a := 1 to z do
    begin
      y := y + 2;
      x := 1;
      gotoxy(x, y);
      Write(#204);
      for i := 1 to b do
      begin
        Inc(x);
        gotoxy(x, y);
        Write(#205);
      end;
      gotoxy(c, y);
      Write(#185);
    end;
  end;

   procedure frame(x1, y1, x2, y2: integer); //Рисует рамку
  var
    x, y: integer;
  begin
    y := y1;
    gotoxy(x1, y1);
    Write(#201);
    for x := x1 + 1 to x2 - 1 do
    begin
      gotoxy(x, y);
      Write(#205);
    end;
    Write(#187);
    for y := y1 + 1 to y2 - 1 do
    begin
      gotoxy(x1, y);
      Write(#186);
      for x := x1 + 1 to x2 - 1 do
        Write(#32);
      Write(#186);
    end;
    gotoxy(x1, y2);
    Write(#200);
    for x := x1 + 1 to x2 - 1 do
    begin
      gotoxy(x, y2);
      Write(#205);
    end;
    Write(#188);
  end;

procedure headOperator; //Рисует шапку + ячейки
  begin
    frame(1, 1, 120, 45);
    horizontalLine(1, 1, 21, 119, 120);
    verticalLine(6, 1, 44, 21, 45);
    verticalLine(48, 1, 44, 21, 45);
    verticalLine(78, 1, 44, 21, 45);
    verticalLine(98, 1, 44, 21, 45);
    gotoxy(8, 2);
    writeln('Name');
    gotoxy(50, 2);
    Writeln('Developer');
    gotoxy(80, 2);
    writeln('Square');
    gotoxy(100, 2);
    writeln('Citizens');
    gotoxy(3, 2);
    writeln('#');
  end;

   function readStr(var f: file): string; //Считывает посимвольно
  var
    s: string;
    len: byte;
    count:integer;
  begin
    blockread(f, len, 1, count);
    setlength(s, len);
    blockread(f, s[1], length(s));
    readStr := s;
  end;

 procedure readingFile;   //Читает файл
  var
    f: file;
  begin
    count := 0;
    assignfile(f, 'village.dat');
    reset(f, 1);
    while not EOF(f) do
    begin
      with(mas[count]) do
      begin
        name := readstr(f);
        developer := readstr(f);
        blockread(f, square, Sizeof(integer));
        blockread(f, citizens, Sizeof(integer));
      end;
      inc(count);
    end;
    Close(f);
  end;

  procedure writingFile;    //Записывает в файл
  var
    f: file;
    len: byte;
    i: integer;
  begin
    assignfile(f, 'village.dat');
    rewrite(f, 1);
    for i := 0 to count - 1 do  // count  кол-во записей / строчек
    begin
      with(mas[i]) do
      begin
        len := length(name);
        blockwrite(f, name, len + 1);
        len := length(developer);
        blockwrite(f, developer, len + 1);
        blockwrite(f, square, SizeOf(integer));
        blockwrite(f, citizens, SizeOf(integer));
      end;
    end;
    Close(f);
  end;

procedure MakeMenuSort(optTextSort: array of string; MaxItemsSort: integer);
var
  i, _X: byte;
  begin
    ySort:=rowSort;
    _X:= xSort;
    for i := 0 to MaxItemsSort-1 do
    begin
          GoToXY (_X, ySort);
          if i = selectedSort then
             TextColor (optSelected)
          else
             TextColor (optNormal);
          write (optTextSort[ i ]);

          If _styleSort = HorizontalSort Then
            inc (_X, width + 1)
          Else
            inc (ySort, 2);
     end;
end;

{ Отрисовка всех элементов меню с выделением цветом одного из них - выбранного на данный момент }
procedure MakeMenu (optText: array of string; MaxItems: integer);
var
   i, _X: byte;
begin
     Y := row;
     _X := X;
     for i := 0 to MaxItems-1 do
     begin
          GoToXY (_X, Y);
          { Вот тут происходит выделение цветом активного элемента }
          if i = selected then
             TextColor (optSelected)
          else
             TextColor (optNormal);
          write (optText[ i ]);

          If _style = Horizontal Then
            inc (_X, width + 1)
          Else
            inc (Y, 2);
     end;
end;

function MenuOptionSort (optTextSort: array of string; MaxItemsSort: integer): byte;
var
   ch:char;
   begin
   selectedSort := 0;

   If _styleSort = VerticalSort Then Begin
     xSort := (120 - width) div 2;
     rowSort := (50 - MaxItemsSort) div 2;
   End
   Else Begin
     xSort := (120 - MaxItemsSort * width) div 2;
     rowSort := 2; { строчка, в которой будет находиться горизонтальное меню }
     GotoXY(1, rowSort); ClrEol; { Очистка заданной строки для вывода горизонтального меню }
     End;

     repeat
           frame(52,21,71,32);
           { Отрисовываем элементы меню }
           MakeMenuSort (optTextSort, MaxItemsSort);

           { И по нажатию клавиш увеличиваемуменьшаем индекс текущего элемента }
           ch := readkey;
           if ch = #0 then
              ch := readkey;

           case ch of
           #80, #77: {Down/Right}
           begin
                inc (SelectedSort);
                if SelectedSort = MaxItemsSort then
                   SelectedSort := 0;
                MakeMenuSort (optTextSort, MaxItemsSort);
           end;

           #72, #75: {Up/Left}
           begin
                dec (SelectedSort);
                if SelectedSort < 0 then
                   SelectedSort := MaxItemsSort-1;
                MakeMenuSort (optTextSort, MaxItemsSort);
           end;
           end;
     until ch = #13; {Enter}

     {
            Если мы пришли сюда - значит, пользователь нажал Enter,
            и в переменной selected находится индекс выбранного им
            элемента меню
     }
     MenuOptionSort := SelectedSort + 1;

     {
       Восстанавливаем нормальный цвет вывода,
       и для вертикального меню очищаем экран
     }
     TextColor (optNormal);
     If _styleSort = VerticalSort Then
        clrscr;
end;

 { Основная функция в нашем меню - позволяет перемещаться по пунктам и возвращает
  номер элемента, выбранного пользователем                                       }
function MenuOption (optText: array of string; MaxItems: integer): byte;
var
   ch: char;
begin
   selected := 0;

   If _style = Vertical Then Begin
     X := (120 - width) div 2;
     row := (50 - MaxItems) div 2;
   End
   Else Begin
     X := (120 - MaxItems * width) div 2;
     row := 2; { строчка, в которой будет находиться горизонтальное меню }
     GotoXY(1, row); ClrEol; { Очистка заданной строки для вывода горизонтального меню }
     End;

     repeat
           frame(52,20,70,34);
           { Отрисовываем элементы меню }
           MakeMenu (optText, MaxItems);

           { И по нажатию клавиш увеличиваемуменьшаем индекс текущего элемента }
           ch := readkey;
           if ch = #0 then
              ch := readkey;

           case ch of
           #80, #77: {Down/Right}
           begin
                inc (Selected);
                if Selected = MaxItems then
                   Selected := 0;
                MakeMenu (optText, MaxItems);
           end;

           #72, #75: {Up/Left}
           begin
                dec (Selected);
                if Selected < 0 then
                   Selected := MaxItems-1;
                MakeMenu (optText, MaxItems);
           end;
           end;
     until ch = #13; {Enter}

     {
       Если мы пришли сюда - значит, пользователь нажал Enter,
       и в переменной selected находится индекс выбранного им
       элемента меню
     }
     MenuOption := Selected + 1;

     {
       Восстанавливаем нормальный цвет вывода,
       и для вертикального меню очищаем экран
     }
     TextColor (optNormal);
     If _style = Vertical Then
        clrscr;
end;

{
  Процедуры, запускаемые при выборе пользователем определенных пунктов меню ...
  Собственно,  именно в них нужно программировать те действия,
  которые требуются по алгоритму решения задачи.
}
procedure Append; //Процедура добавляет в конец файла запись
  begin
      readingFile;
      with(mas[count]) do
      begin
        gotoxy(44, 20);
        Write('Name: ');
        readln(name);
        gotoxy(44, 22);
        Write('Developer: ');
        readln(developer);
        gotoxy(44, 24);
        Write('Square: ');
        readln(square);
        gotoxy(44,26);
        Write('Count of citizens: ');
        readln(citizens);
      end;
      inc(count);
        writingFile;
  end;

procedure change; //Процедура изменяет запись по названию
var
  s: string;
  i, schet, k: integer;
begin
  clrscr;
  count := 0;
  schet := 0;
  readingFile;
  Frame(42, 22, 80, 24);
  gotoxy(44, 23);
  Write('Write name of village: ');
  readln(s);
  begin
    for k := 0 to count do
      if s = mas[k].name then
        Inc(schet);
  end;
  if schet = 1 then
  begin
    for i := 0 to count do
      if s = mas[i].name then
        with(mas[i]) do
        begin
          clrscr;
          Frame(42, 19, 77, 27);
          gotoxy(44, 20);
          Write('Name: ');
          readln(name);
          gotoxy(44, 22);
          Write('Developer: ');
          readln(developer);
          gotoxy(44, 24);
          Write('Square: ');
          readln(square);
          gotoxy(44, 26);
          Write('Citizens: ');
          readln(citizens);
        end;
    for i := 0 to count - 1 do
      writingFile;
  end
  else
  begin
    clrscr;
    Frame(47, 23, 69, 25);
    gotoxy(49, 24);
    Write('Name not found!');
    readln();
  end;
end;

procedure search; //процедура поиска записи в файле
  var
    s: string;
    i, y, j, schet: integer;
  begin
    schet := 0;
    y := 3;
    readingFile;
    gotoxy(2, 2);
    Write('Write name of village: ');
    readln(s);
    begin
    for j := 0 to count do
    if s = mas[j].name then
     inc(schet)
    end;
    if schet = 1 then
    begin
    for i := 0 to count do
      if s = mas[i].name then
        with(mas[i]) do
        begin
          gotoxy(11, y + 2);
          writeln('Name');
          gotoxy(36, y + 2);
          writeln('Developer');
          gotoxy(54, y + 2);
          writeln('Square');
          gotoxy(83, y + 2);
          writeln('Citizens');
          gotoxy(2, y + 4);
          Write(name);
          gotoxy(30, y + 4);
          Write(developer);
          gotoxy(53, y + 4);
          Write(square);
          gotoxy(60, y + 4);
          Write(citizens);
        end;
      end
    else
      begin
      Frame(1, 4, 35, 6);
      gotoxy(2, y+2);
      writeln('This village not exist');
      end;
    readln();
    end;

procedure sortByName;        //сортировка по названию
  var
    i, j, schet: integer;
    t: village;
  begin
    begin
      readingFile;
      with (mas[Count]) do
      begin
        schet := 1;
        while schet < 50 do
          Inc(schet);
        for i := 0 to Count do
          for j := i + 1 to Count - 1 do
            if mas[i].name > mas[j].name then
            begin
              t := mas[i];
              mas[i] := mas[j];
              mas[j] := t;
            end;
      end;
      writingFile;
    end;
  end;

procedure sortByDeveloper;   //сортировка по разработчику
  var
    i, j, schet: integer;
    t: village;
  begin
    begin
      readingFile;
      with (mas[Count]) do
      begin
        schet := 1;
        while schet < 50 do
          Inc(schet);
        for i := 0 to Count do
          for j := i + 1 to Count - 1 do
            if mas[i].developer > mas[j].developer then
            begin
              t := mas[i];
              mas[i] := mas[j];
              mas[j] := t;
            end;
      end;
      writingFile;
    end;
  end;

procedure sortBySquare;    //сортировка по площади
  var
    i, j, schet: integer;
    t: village;
  begin
    begin
      readingFile;
      with (mas[Count]) do
      begin
        schet := 1;
        while schet < 50 do
          Inc(schet);
        for i := 0 to Count do
          for j := i + 1 to Count - 1 do
            if mas[i].square > mas[j].square then
            begin
              t := mas[i];
              mas[i] := mas[j];
              mas[j] := t;
            end;
      end;
      writingFile;
    end;
  end;

procedure sortByCitizens;   //сортировка по кол-ву жителей
  var
    i, j, schet: integer;
    t: village;
  begin
    begin
      readingFile;
      with (mas[Count]) do
      begin
        schet := 1;
        while schet < 50 do
          Inc(schet);
        for i := 0 to Count do
          for j := i + 1 to Count - 1 do
            if mas[i].citizens > mas[j].citizens then
            begin
              t := mas[i];
              mas[i] := mas[j];
              mas[j] := t;
            end;
      end;
      writingFile;
    end;
  end;

procedure delete;           //удаление по названию
var
    s: string;
    i, k, index, jump: integer;
  begin
    clrscr;
    jump:=0;
      readingFile;
    Frame(42, 22, 80, 24);
    gotoxy(44, 23);
    Write('write name: ');
    readln(s);
    begin
      for k := 0 to count do
        if s = mas[k].name then
          Inc(jump);
    end;
    if jump = 1 then
    begin
    for i := 0 to count do
      if s = mas[i].name then
        index := i;
    for i := index to count do
      mas[i] := mas[i + 1];
    Dec(count);
    writingfile;

    end
    else
    begin
      clrscr;
      Frame(47, 23, 69, 25);
      gotoxy(49, 24);
      Write('name not found');
      readln();
    end;
    end;

procedure Table;      //таблица + перемещение между листами
var

   y, j, point, page: integer;
   c: char;
 begin
   clrscr;
   y := 2;

   point := 1;
   page := 0;
   begin
     readingFile;
     end;
     headOperator;
     repeat
       y := 2;
       point := min((page + 1) * 25, count - 1);
       for j := page * 25 to point do
       begin
         with(mas[j]) do
         begin
           gotoxy(3, y + 2);
           Write(j + 1);
           gotoxy(8, y + 2);
           Write(name);
           gotoxy(50, y + 2);
           Write(developer);
           gotoxy(80, y + 2);
           Write(square);
           gotoxy(100, y + 2);
           Write(citizens);
           y := y + 2;
         end;
       end;
       c := readkey;
       if c = #0 then
       begin
         c := readkey;
         clrscr;
         case Ord(c) of
           75:
           begin
             if page > 0 then
               Dec(page);
             headOperator;
           end;
           77:
           begin
             if page < 2 then
               Inc(page);
             headOperator;
           end;
         end;
       end;
     until c = #27;
   end;

 procedure menuForSort;
 var
  Option: byte; { Эта переменная будет хранить номер пункта, выбранного пользователем }

begin
     { Проверяем с вертикальным меню (_style = Horizontal для горизонтального) }
     _styleSort := VerticalSort;
     repeat

       clrscr;
       Option := MenuOptionSort (optTextSort, nItemsSort);
       case option of
         1: sortbyname;
         2: sortbydeveloper;
         3: sortbysquare;
         4: sortbycitizens;
       end;

       {
         Здесь я исходил из предположения, что завершающим пунктом меню всегда идет Выход.
         Если это не так - надо просто подставить вместо nItems номер пункта для выхода из программы
       }
     until Option= nItemsSort;

end;


var
  Option: byte; { Эта переменная будет хранить номер пункта, выбранного пользователем }

begin
     { Проверяем с вертикальным меню (_style = Horizontal для горизонтального) }
     _style := Vertical;
     repeat

       clrscr;
       Option := MenuOption (optText1, nItems);
       case option of
         1: Append;
         2: delete;
         3: change;
         4: menuForSort;
         5: table;
         6: search;
       end;

       {
         Здесь я исходил из предположения, что завершающим пунктом меню всегда идет Выход.
         Если это не так - надо просто подставить вместо nItems номер пункта для выхода из программы
       }
     until Option = nItems;

end.
