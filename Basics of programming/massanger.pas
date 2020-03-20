program file_manager;
var f, buffer: file;
address, newName: string[35];
i: integer;
code_operation: char;
procedure CopyFile(var f: file);
begin
reset(f);
writeln ('Введите адрес нового места');
readln(address);
assign(buffer, address);
rewrite(buffer);
BlockRead (f, i, FileSize(f));
BlockWrite(buffer, i, FileSize(f));
close(buffer);
close(f);
end;
procedure EraseFile(var f: file);
begin
writeln ('Вы точно хотите удалить файл? Если "да" нажмите - "y"');
readln(code_operation);
if code_operation='y' then
erase(f);
end;
procedure RenameFile(var f: file);
begin
writeln('Введите новое имя файла');
readln(newName);
rename(f, newName);
end;
begin
repeat
writeln ('Введите адрес файла');
readln(address);
assign (f, address);
writeln ('Код операции: Копировать (C), Удалить (D), Переименовать (R)');
writeln ('Выход из программы (E)');
readln (code_operation);
case (code_operation) of
'C','c': CopyFile(f);
'D','d': EraseFile(f);
'R','r': RenameFile(f);
end;
until (code_operation = 'E') or (code_operation = 'e');
readln;
end.