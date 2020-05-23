uses crt;

///глобальный_ключ
var key:string;
///счётчики
var i0,i1,i2,i3,i4,i5,i6,i7,i8,i9:integer;
///позиция в таблице
x,y:integer;
///символ
var c1,c2:char;
///код_символа
var w1:word;
///текст
var t1,t2:string;
///файл
var f1,f2,f3:text;
//путь до файла
var dir,config,cash:string;

{function FileExistsOpen(fileName:string):boolean;
begin
try
  try
    f:=TFileStream.Create(fileName,fmOpenRead);
    Result:=f.Size>=0
  finally
    f.Free
  end;
except
  Result:=false
end;
end;}

begin
key:='main_menu';

while(key<>'')do begin
dir:='D:\111';
config:='config.txt';
cash:='cash.txt';

while(key='main_menu')do begin
 clrscr;
 for i1:=1 to 10 do writeln;
 t1:='                                                ';
 t2:='                ';
 textcolor(15);
 write(t1);write(#201);for i1:=1 to 17 do write(#205);writeln(#187);
 write(t1);write(#186);write(t2);writeln(' '#186);
 write(t1);write(#186'  '#201);for i1:=1 to 11 do write(#205);writeln(#187'  '#186);
 write(t1);write(#186'  '#186);if(y=0)then textcolor(10);write('  Создать  ');textcolor(15);writeln(#186'  '#186);
 write(t1);write(#186'  '#200);for i1:=1 to 11 do write(#205);writeln(#188'  '#186);
 write(t1);write(#186'  '#201);for i1:=1 to 11 do write(#205);writeln(#187'  '#186);
 write(t1);write(#186'  '#186);if(y=1)then textcolor(10);write('  Открыть  ');textcolor(15);writeln(#186'  '#186);
 write(t1);write(#186'  '#200);for i1:=1 to 11 do write(#205);writeln(#188'  '#186);
 write(t1);write(#186'  '#201);for i1:=1 to 11 do write(#205);writeln(#187'  '#186);
 write(t1);write(#186'  '#186);if(y=2)then textcolor(10);write('  Справка  ');textcolor(15);writeln(#186'  '#186);
 write(t1);write(#186'  '#200);for i1:=1 to 11 do write(#205);writeln(#188'  '#186);
 write(t1);write(#186'  '#201);for i1:=1 to 11 do write(#205);writeln(#187'  '#186);
 write(t1);write(#186'  '#186);if(y=3)then textcolor(10);write('   Выйти   ');textcolor(15);writeln(#186'  '#186);
 write(t1);write(#186'  '#200);for i1:=1 to 11 do write(#205);writeln(#188'  '#186);
 write(t1);write(#186);write(t2);writeln(' '#186);
 write(t1);write(#200);for i1:=1 to 17 do write(#205);writeln(#188);

 c1:=readkey;
 w1:=ord(c1);
 case w1 of
  13:begin case y of
   0:key:='create';
   1:key:='open';
   2:key:='info';
   3:key:='exit';
  end;x:=0;y:=0;t1:='';t2:='';end;
  27:begin key:='exit';x:=0;y:=0;t1:='';t2:='';end;
  75:dec(x);
  72:dec(y);
  77:inc(x);
  80:inc(y);
 end;
 if(y<0)then y:=3;if(y>3)then y:=0;
 if(x<0)then x:=0;if(x>0)then x:=0;

end;

while(key='create')do begin
 clrscr;
 t1:='                                        ';
 for i1:=1 to 10 do writeln;
 textcolor(10);
 write(t1);write(#201);for i1:=1 to 35 do write(#205);writeln(#187);
 write(t1);write(#186);for i1:=1 to 35 do write(' ');writeln(#186);
 write(t1);write(#186);textcolor(15);write('   Введите название нового файла   ');textcolor(10);writeln(#186);
 write(t1);write(#186);for i1:=1 to 35 do write(' ');writeln(#186);
 write(t1);write(#186);for i1:=1 to 35 do write(' ');writeln(#186);
 write(t1);write(#186);for i1:=1 to 35 do write(' ');writeln(#186);
 write(t1);write(#186);textcolor(15);write('   ENTER - ВВОД                    ');textcolor(10);writeln(#186);
 write(t1);write(#186);for i1:=1 to 35 do write(' ');writeln(#186);
 write(t1);write(#186);textcolor(15);write('   ESC   - ВЫХОД                   ');textcolor(10);writeln(#186);
 write(t1);write(#186);for i1:=1 to 35 do write(' ');writeln(#186);
 write(t1);write(#200);for i1:=1 to 35 do write(#205);writeln(#188);
 gotoxy(45,15);write(t2);

 c1:=readkey;
 w1:=ord(c1);
 if(length(t2)=0)then i2:=0;
 case w1 of
  8:delete(t2,length(t2),1);
  13:if(t2<>'')and(t2<>'con')then begin

   assign(f1,dir+t2+'.txt');
   rewrite(f1);
   close(f1);
   assign(f2,dir+config);
   i2:=0;
   {$I-}reset(f2);{$I+}
   if(IOResult=0)then begin
   while(eof(f2)=false)do begin readln(f2,t1);if(t1=t2)then i2:=1;end;
   close(f2);
   end;
   if(i2=0)then begin
   if(IOResult=0)then
   append(f2)else rewrite(f2);
   writeln(f2,t2);
   close(f2);
   end;

   key:='flights';t2:='';x:=0;y:=0;t1:='';t2:='';
  end else begin
  clrscr;
  textcolor(15);
  for i1:=1 to 10 do writeln;
  write(t1);write(#201);for i1:=1 to 29 do write(#205);writeln(#187);
  write(t1);write(#186);for i1:=1 to 29 do write(' ');writeln(#186);
  write(t1);write(#186);write('  Следует ввести имя файла.  ');writeln(#186);
  write(t1);write(#186);for i1:=1 to 29 do write(' ');writeln(#186);
  write(t1);write(#186);textcolor(10);write('  ENTER                      ');textcolor(15);writeln(#186);
  write(t1);write(#186);for i1:=1 to 29 do write(' ');writeln(#186);
  write(t1);write(#200);for i1:=1 to 29 do write(#205);writeln(#188);
  c1:=readkey;
  end;
  27:begin key:='main_menu';x:=0;y:=0;t1:='';t2:='';end;
  else if(length(t2)<26)then t2:=t2+c1;
 end;

end;

while(key='open')do begin
 clrscr;
 textcolor(15);
 write(#201);for i1:=1 to 96 do write(#205);writeln(#187);
 write(#186);write('  название базы данных');for i1:=1 to 96-22 do write(' ');writeln(#186);
 assign(f2,dir+config);
 {$I-}
 reset(f2);
 {$I+}
 i2:=0;
 if(IOResult=0)then
 while(eof(f2)=false)do begin
  readln(f2,t1);
  write(#204);for i1:=1 to 96 do write(#205);writeln(#185);
  write(#186);if(y=i2)then textcolor(10);write(t1);textcolor(15);for i1:=1 to 96-length(t1) do write(' ');writeln(#186);
  inc(i2);
 end;
 close(f2);
 write(#200);for i1:=1 to 96 do write(#205);writeln(#188);
 gotoxy(2,4+2*y);write(t2);

 c1:=readkey;
 w1:=ord(c1);
 case w1 of
  8:begin
  assign(f3,dir+cash);rewrite(f3);
  reset(f2);for i1:=0 to y do begin readln(f2,t1);if(i1<>y)then writeln(f3,t1);end;
  assign(f1,dir+t1+'.txt');erase(f1);
  while(eof(f2)=false)do begin readln(f2,t1);writeln(f3,t1);end;
  rewrite(f2);
  reset(f3);
  while(eof(f3)=false)do begin readln(f3,t1);
  writeln(f2,t1);end;
  close(f2);close(f3);erase(f3);
  end;
  //13:begin key:='flights';x:=0;y:=0;t1:='';t2:='';end;
  27:begin key:='main_menu';x:=0;y:=0;t1:='';t2:='';end;
  75:dec(x);
  72:dec(y);
  77:inc(x);
  80:inc(y);
  //else if(length(t2)<26)then t2:=t2+c1;
 end;
 if(x<0)then x:=0;if(x>0)then x:=0;
 if(y<0)then y:=i2-1;if(y>i2-1)then y:=0;

end;

while(key='flights')do begin
 clrscr;
 textcolor(15);
 write(#201);for i1:=1 to 96 do write(#205);writeln(#187);
 write(#186);write('  Рейсы');for i1:=1 to 89 do write(' ');writeln(#186);
 write(#204);for i1:=1 to 96 do write(#205);writeln(#185);
 //ТАБЛИЦА
 write(#200);for i1:=1 to 96 do write(#205);writeln(#188);

 c1:=readkey;
 w1:=ord(c1);
 case w1 of
  13:begin key:='main_menu';x:=0;y:=0;t1:='';t2:='';end;
  27:begin key:='main_menu';x:=0;y:=0;t1:='';t2:='';end;
  75:dec(x);
  72:dec(y);
  77:inc(x);
  80:inc(y);
 end;
 if(x<0)then x:=0;if(x>0)then x:=0;
 if(y<0)then y:=0;if(y>0)then y:=0;

end;

while(key='flight')do begin
 clrscr;
 textcolor(15);
 write(#201);for i1:=1 to 96 do write(#205);writeln(#187);
 write(#186);write('');for i1:=1 to 96 do write(' ');writeln(#186);
 write(#204);for i1:=1 to 96 do write(#205);writeln(#185);
 //ТАБЛИЦА
 write(#200);for i1:=1 to 96 do write(#205);writeln(#188);

 c1:=readkey;
 w1:=ord(c1);
 case w1 of
  13:begin key:='main_menu';x:=0;y:=0;t1:='';t2:='';end;
  27:begin key:='main_menu';x:=0;y:=0;t1:='';t2:='';end;
  75:dec(x);
  72:dec(y);
  77:inc(x);
  80:inc(y);
 end;
 if(y<0)then y:=0;if(y>0)then y:=0;
 if(x<0)then x:=0;if(x>0)then x:=0;

end;

while(key='info')do begin
 clrscr;
 for i1:=1 to 10 do writeln;
 t1:='                                                ';
 t2:='                ';
 textcolor(15);
 write(t1);write(#201);for i1:=1 to 17 do write(#205);writeln(#187);
 write(t1);write(#186);write(t2);writeln(' '#186);
 write(t1);write(#186'  '#201);for i1:=1 to 11 do write(#205);writeln(#187'  '#186);
 write(t1);write(#186'  '#186);write('  Справка  ');writeln(#186'  '#186);
 write(t1);write(#186'  '#200);for i1:=1 to 11 do write(#205);writeln(#188'  '#186);
 write(t1);write(#186);write(t2);writeln(' '#186);
 write(t1);write(#186'  '#201);for i1:=1 to 11 do write(#205);writeln(#187'  '#186);
 write(t1);write(#186'  '#186);textcolor(10);write('   Выход   ');textcolor(15);writeln(#186'  '#186);
 write(t1);write(#186'  '#200);for i1:=1 to 11 do write(#205);writeln(#188'  '#186);
 write(t1);write(#186);write(t2);writeln(' '#186);
 write(t1);write(#200);for i1:=1 to 17 do write(#205);writeln(#188);

 c1:=readkey;
 w1:=ord(c1);
 case w1 of
  13:begin case y of 0:key:='main_menu';end;x:=0;y:=0;t1:='';t2:='';end;
  27:begin key:='main_menu';x:=0;y:=0;t1:='';t2:='';end;
 end;
end;

while(key='exit')do begin
 clrscr;
 for i1:=1 to 10 do writeln;
 t1:='                                         ';
 t2:='                               ';
 textcolor(15);
 write(t1);write(#201);for i1:=1 to 32 do write(#205);writeln(#187);
 write(t1);write(#186);write(t2);writeln(' '#186);
 write(t1);write(#186'  '#201);for i1:=1 to 26 do write(#205);writeln(#187'  '#186);
 write(t1);write(#186'  '#186);              write('  Вы точно хотите выйти?  ');writeln(#186'  '#186);
 write(t1);write(#186'  '#200);for i1:=1 to 26 do write(#205);writeln(#188'  '#186);
 write(t1);write(#186);write(t2);writeln(' '#186);
 write(t1);write(#186'  '#201);for i1:=1 to 11 do write(#205);write(#187'  '#201);for i1:=1 to 11 do write(#205);writeln(#187'  '#186);
 write(t1);write(#186'  '#186);if(x=0)then textcolor(10);write('    ДА     ');textcolor(15);write(#186'  '#186);if(x=1)then textcolor(10);write('    НЕТ    ');textcolor(15);writeln(#186'  '#186);
 write(t1);write(#186'  '#200);for i1:=1 to 11 do write(#205);write(#188'  '#200);for i1:=1 to 11 do write(#205);writeln(#188'  '#186);
 write(t1);write(#186);write(t2);writeln(' '#186);
 write(t1);write(#200);for i1:=1 to 32 do write(#205);writeln(#188);

 c1:=readkey;
 w1:=ord(c1);
 case w1 of
  13:begin case x of
   0:key:='';
   1:key:='main_menu';
  end;x:=0;y:=0;t1:='';t2:='';end;
  27:begin key:='';x:=0;y:=0;t1:='';t2:='';end;
  75:dec(x);
  72:dec(y);
  77:inc(x);
  80:inc(y);
 end;
 if(y<0)then y:=0;if(y>0)then y:=0;
 if(x<0)then x:=1;if(x>1)then x:=0;

end;

end;
end.
