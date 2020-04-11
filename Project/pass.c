#include <stdio.h>
#include <locale.h>
int main() {
setlocale(LC_ALL, "");
int k;
scanf("%d", &k);
switch (k){
case 11:
case 12:
case 13:
case 14: printf("Мне %d лет", k);break;
default:
switch (k % 10){
case 1: printf("Мне %d год", k);break;
case 2:
case 3:
case 4: printf("Мне %d года", k);break;
case 5:
case 6:
case 7:
case 8:
case 9:
case 0: printf("Мне %d лет", k);break;
}
}
return 0;
}
