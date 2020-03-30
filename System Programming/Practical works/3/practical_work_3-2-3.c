//3-2-3 Practical work

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
static int values[6];
static char names[6][44];
static int var[6];
enum e_flags //Никак не работает, это просто массив, только вместо целых чисел тут биты.
{
    expr_top = 1 << 0, //start :shrug:
    expr_const = 1 << 1, //const keyword
    expr_token = 1 << 2, //string tokens(spaces, commas, etc)
    expr_num = 1 << 3, //number flag
    expr_var = 1 << 4, //var word flag
    expr_char_write = 1 << 5, //флаг записи переменной
    expr_eval = 1 << 6,
//    expr_sign = 1 << 7,
    expr_end = 1 << 7, //end :shrug:
};
#define isnum(c) (c >= '0' && c <= '9')
#define ischar(c) ((c >= 'a' && c <= 'z') || c == '_')

#define ARG_PARSE_ERROR -3

typedef enum e_flags e_flags_t;
int lookup(/*e_flags_t* state,*/ const char* name, int index)
{
    for(int i = 0; i <= index; i++)
    {
        if(strcmp(names[i], name) == 0) {
            return i;
        }
    }
    return -1;
}
const char* handle_arg(const char* expr, char* ret_name)
{
    //int i =0;
    while(ischar(*expr))
    {
        *ret_name = *expr;
        expr++;
        ret_name++;
        //i++;
    }
    return expr;
}
const char* handle_num(/*e_flags_t* state,*/ const char* expr, int* num, char sign)
{
    int res = 0;
    while(isnum(*expr)) {
        int n = *expr - '0';
        expr++;
        res = 10 * res + n;
    }
    *num = sign ? -res : res;
//    if(*state & expr_sign) {
//        *state &= ~(expr_sign);
//        *num = -res;
//    }
//    else *num = res;

    return expr;
}
int handler(const char* expr)
{
    e_flags_t current_state = expr_top;
    int num_args = 0; //количество переменных в строке.
    char* mod_ptr = strstr(expr, "mod"); //mod ptr
    const char* preserved_ptr = mod_ptr; //preserved ptr to "mod" str
    int i = 0; //индекс текущего элемента в переменной
    int arg_value = 0; //текущее число
    char current_var[44] = ""; //текущая переменная
    int operand_num = 0; //index of var array at the start of the file
    char saved_flag = 0; //костыль для одиночной записи
    int preserved_index = -1; //preserving index of variable var=imm mod imm
    char sign = 0; //sign flag, if set number is below zero
    int arg_index = 0; //stored index of variable, if found in "names" array otherwise -1
    char back = -1;
    int arg_arg = 0;
    while(*expr)
    {
        switch (current_state) {
            case expr_top:
                while(*expr == ' ')
                    expr++;
                while(*mod_ptr != '=')
                    mod_ptr--;
                current_state = expr_const;
                break;
            case expr_const:
                if(strncasecmp(expr, "const", 4) == 0) {
                    expr += 5; //skipping "const" keyword
                    current_state = expr_token; //change state to a token parse
                } else {
                    perror("const expected");
                    current_state = expr_end;
                }
                break;
            case expr_token:
                while(*expr == ' ')
                    expr++;
                 if(ischar(*expr))
                    current_state = expr_var;
                else if(*expr == ',') {
                    expr++;
                    current_state = expr_var;
                }
                else if(*expr == '=') {
                    char if_mod = expr == mod_ptr ? 1 : 0;
                    if(if_mod)
                        current_state = expr_eval;
                    expr++;
                    while(*expr == ' ')
                        expr++;
                    if((isnum(*expr) || *expr == '-') && !if_mod) {
                        if(*expr == '-') {
                            sign = 1;
                            expr++;
                        }
                        current_state = expr_num;
                    }
                }
                else if(*expr == ';' || *expr == '\0')
                    current_state = expr_end;
                break;
            case expr_char_write:
            {
                expr = handle_arg(expr, &current_var[0]);
                if(back == 1)
                    current_state = expr_var;
                else if(back == 0)
                    current_state = expr_eval;
            }
                break;
            case expr_var: {
                while(*expr == ' ')
                    expr++;
                if(ischar(*expr)) {
                    back = 1;
                    current_state = expr_char_write;
                }
                
                else if(*expr == '=') {
                    arg_index = lookup(/*&current_state,*/ current_var, num_args);
                    if(arg_index == -1) {
                        strcpy(&names[num_args][0], current_var/*, sizeof(current_var)*/);
                        memset(current_var, 0, i);
                    }
                        
                    i = 0;
                    back = 0;
                    current_state = expr_token;
                }
                else if(*expr == ';' || '\0')
                    current_state = expr_end;
            }
                break;
            case expr_num: {
                expr = handle_num(/*&current_state,*/ expr, &arg_value, sign);
                while(*expr == ' ')
                    expr++;
                if(*expr == ',' || *expr == ';') {
                    if(arg_index != -1)
                        values[arg_index] = arg_value;
                    else {
                        values[num_args] = arg_value;
                        num_args++;
                    }
                    arg_value = 0;
                    sign = 0;
                    current_state = expr_token;
                }

            }
                break;
            case expr_eval: {
                if(!saved_flag) {
                    preserved_index = num_args;
                    saved_flag = 1;
                }
                while(*expr == ' ')
                    expr++;
                bool if_mod = expr == preserved_ptr;
                if(isnum(*expr) || *expr == '-') {
                    if(*expr == '-') {
                        sign = 1;
                        expr++;
                    }
                    else sign = 0;
//                       current_state = expr_num | expr_sign;
                    expr = handle_num(/*&current_state,*/ expr, &var[operand_num], sign);
                    operand_num++;
                }
                else if(ischar(*expr) && !if_mod)
                {
                    back = 0;
                    arg_arg++;
                    memset(&current_var[0], 0, sizeof(current_var));
                    expr = handle_arg(expr, &current_var[0]);
                    var[operand_num] = values[lookup(current_var, num_args)];
                    operand_num++;
                }
                if(if_mod)
                    expr+=3;

                else if(*expr == ';' || *expr == ',')
                {
                    if(preserved_index >= 0) {
                        values[preserved_index] = var[0] % var[1];
                        current_state = *expr == ';' ? expr_end : expr_token;
                    }
                    else current_state = expr_end;
                }
                
            }
                break;
            case expr_end:
                return num_args;
        }
    }
    return num_args;
}
int main() {
    char buf[1024]="const _ = -5, __ = -100, cc = _ mod -100;";
    int ret = 0;
    //fgets(buf, sizeof(buf), stdin);
    if(*buf == '\0') {
        ret = -1;
        perror("[fgets] error while read");
    }
    int arg_count = -1;
    arg_count = handler(buf);
    if(arg_count < 0)
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
