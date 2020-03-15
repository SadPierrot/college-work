#include<stdio.h>
char *valoct (char *s, int *n) {
int num=0;
int pow=1;
int i, j;

printf("%s\n", s);
for (i=0; s[i]; i++) ; //находим длину строки
for (j=i-1; j>=0; j--) {
num += pow * (s[j] - '0');
pow *= 8;

}
*n=num;
return 0;
}
int main() {
char *snum = "77";
int n;
//printf("Enter a number: ");
//scanf("%c", snum);
valoct(snum, &n);
printf("%d", n);
}