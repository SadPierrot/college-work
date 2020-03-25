//3-2-3 ВАРИАНТ
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
static int values[6];
static char names[6][44];
enum e_flags //Никак не работает, это просто массив, только вместо целых чисел тут биты.
{
    expr_top = 1 << 0, //start :shrug:
    expr_const = 1 << 1, //const keyword
    expr_token = 1 << 2, //string tokens(spaces, commas, etc)
    expr_num = 1 << 3, //number flag
    expr_var = 1 << 4, //var word flag
    expr_char_write = 1 << 5, //флаг записи переменной
    expr_eval = 1 << 6,
    expr_end = 1 << 7, //end :shrug:
};
#define ischar(c) c >= 'a' && c <= 'z'
#define isnum(c) c >= '0' && c <= '9'

#define ARG_PARSE_ERROR -3

typedef enum e_flags e_flags_t;
int handler(char* expr, e_flags_t* flags)
{
    e_flags_t current_state = *flags;
    int index = 0; //количество переменных в строке. 
    int idx_var = 0; //индекс текущего элемента в переменной
    int res = 0; //хуй знает че
    char tmp[44]=""; //текущая переменная
    char flag = -1; //хуй знает че
    int op1=0; //значение первой переменной
    int op2=0; //значение второй переменной
    char interm[44] = ""; 
    char checked = 0; //костыль для одиночной записи
    unsigned long sz = 0; 
    char end_flag = 0;
    while(!end_flag || *expr)
    {
        switch (current_state) {
            case expr_top:
                if(*expr == ' ')
                    expr++;
                else current_state = expr_const;
                break;
            case expr_const:
                if(strncmp(expr, "const", 4) == 0) {
                    expr += 5; //skipping "const" keyword
                    current_state = expr_token; //change state to a token parse
                } else { //if not found
                    perror("const expected");
                    current_state = expr_end;
                }
                break;
            case expr_token:
                if(*expr == ' ')
                    expr++;
                else if(ischar(*expr)) 
                    current_state = expr_var;
                else if(*expr == ',') {
                    index++;
                    expr++;
                    current_state = expr_var;
                }
                else if(*expr == '=') {
                    expr++;
                    if(*expr == ' ')
                        while(*expr == ' ') expr++;
                    current_state = ischar(*expr) ? expr_eval : expr_num;
                }
                else if(*expr == ';' || *expr == '\0')
                    current_state = expr_end;
                break;
            case expr_char_write:
                if(ischar(*expr)) {
                    tmp[idx_var] = *expr;
                    expr++;
                    idx_var++;
                }
                if(flag == 0)
                    current_state = expr_var;
                else if(flag == 1)
                    current_state = expr_eval;
                break;
            case expr_var: {

                if(ischar(*expr)) {
                    flag = 0;
                    current_state = expr_char_write;
                }
                else if(*expr == ' ')
                    expr++;
                else if(*expr == '=') {
                    strncpy(&names[index][0], tmp, idx_var); //записываем в массив имен имя текущей переменной.
                    idx_var = 0;
                    current_state = expr_token;
                }
                else if(*expr == ';' || '\0')
                    current_state = expr_end;
            }
                break;
            case expr_num: {

                
                int r = 0;
                if(isnum(*expr)) { //аналогично ischar. Везде будет проверка на 0-9
                    int n = expr[r] - '0';
                    r++;
                    expr++;
                    res = 10 * res + n;
                }
                else if(*expr == ' ')
                    expr++;
                else if(*expr == ',' || *expr == ';') {
                    values[index] = res;
                    res = 0;
                    current_state = expr_token;
                }
            }
                break;
            case expr_eval: {
                if(*tmp && !checked) {
                    sz = strlen(tmp);  //это длинна переменной в которой будет выражение(ab=bc mod db. Где tmp=ab) 
                    strncpy(&interm[0], tmp, sz); //сохраняем эту переменную, она понадобится нам позже для присваивания ей значения.
                    checked = 1; //ставим флаг в 1, нам нужно единожды записать ее
                }
                int op = strncmp(expr, "mod", 3); //каждый раз проверяем 3 последующие символа строки с mod
                if(ischar(*expr) && op) { //если мы НЕ встретили "mod", но встретили букву, то
                    flag = 1; //устанавливаем flag в 1, необходимо для перехода обратно в текущее состояние
                    current_state = expr_char_write; //устанавливаем состояние записи первой переменной
                }
                else if(*expr == ' ')
                    expr++;
                else if(!op) //если мы встретили mod, то после него стоит название второй переменной 
                 {
                     expr+=3; //прыгаем через mod
                     int j = 0; //текущий индекс элемента в массиве имен
                     int ret = -1; //переменная определяющая нашли ли мы искомое название переменной в массиве имен
                     char flag = 0; //для остановки поиска, если мы уже нашли искомое. ЕБАННЫЙ break нельзя использовать, поэтому так
                     do {
                         ret = strncmp(names[j], tmp, idx_var); //сравнивает текущее имя переменной в names с tmp 
                         if(!ret && !flag) {
                             flag = 1;
                             idx_var=0; //если совпало, то затираем tmp
                             memset(tmp,0, sizeof(tmp));
                             op1 = values[j]; //и записываем значение этой переменной в нашу
                         }
                         j++; //увеличиваем счетчик
                      } while (j < index || !flag); //пока не обошли все элементы массива names либо не установлен флаг 
                 }
                else if(*expr == ';' || *expr == ',') //если мы встретили символ конца выражения
                {
                    int j = 0; //текущий индекс элемента в массиве имен
                    int ret = -1; //переменная определяющая нашли ли мы искомое название переменной в массиве имен
                    int _ret = -1; //переменная определяющая нашли ли мы искомое название переменной в массиве имен. Эта для ранее записанной ab. См. начало этого case
                    char flag = 0; //флаг, показывающий, что мы нашли имя текущей переменной
                    char _flag = 0; //тоже самое, но для переменной хранящей выражение
                    while (j <= index) {
                        ret = strncmp(names[j], tmp, idx_var); //ищем текущую в массиве
                        _ret = strncmp(names[j], &interm[0], sz); //ищем переменную содержающую выражение
                        if(!ret && !flag) { //это проверки для текущей
                            flag = 1; //если нашли, ставим флаг, что бы больше не заходить сюда
                            idx_var=0; //обнуляем индекс, хуй знает почему я не мемсетнул тут, ошибка наверное
                            op2 = values[j]; //записываем значение второй переменной в нашу
                        }
                        if(!_ret && !_flag) { //это для выражения
                            sz = j; //если нашли -- то запоминаем индекс
                            _flag = 1; //ставим флаг
                        }
                    
                        j++;
                    }
                    if(_flag) //предположительно все нашли
                    {
                        if(op1 && op2) { //проверяем деление на 0 и 0 % n
                            values[sz] = op1 % op2; //если все ок, то делим и записываем в индекс, который ранее запомнили. Это будет индекс переменной ab
                            current_state = *expr == ';' ? expr_end : expr_token;
                        }
                        else { //иначе это будет деление на ноль
                            perror("division by zero");
                            index = 0; 
                            current_state = expr_end; //заканчиваем;
                        }
                    }
                }
                
            }
                break;
            case expr_end: //если попали сюда, то встретили конечный символ
                return index;//end_flag = 1; //ставим флаг в 1
                //break; //бежим нахуй отсюда
        }
    }
    return index;
}
int main() {
    e_flags_t flags = expr_top;
    char buf[1024]="";
    int ret = 0;
    fgets(buf, sizeof(buf), stdin);
    if(*buf == '\0') {
        ret = -1;
        perror("[fgets] error while read");
    }
    int arg_count = handler(buf, &flags);
    if(!arg_count)
    {
        perror("error while handling args");
        ret = ARG_PARSE_ERROR;
    }
    for(int i=0; i <= arg_count; i++)
    {
        printf("%s == %d\n", names[i], values[i]);
    }

    return ret;
}