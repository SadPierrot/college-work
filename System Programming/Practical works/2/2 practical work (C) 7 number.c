#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <math.h>
int main() {
int f, f1, f2, eps, num, num1, num3, fac;
double s, sum;
int err = scanf("%lf", &eps);
if (err < 0) {
	perror("Ошибка ввода");	
}
else if (err == 0) {
	perror("Ожидалось число");
}

f = 0;
f1 = 1;
f2 = 0;
sum = 0;
num = 1;
num1 = 1;
s = 0;
fac = 1;

do {
	f = f1 + f2;
	f1 = f2;
	f2 = f;
	num1 = num1 * 3;
	fac = fac * num;
	num = num + 1;
    sum = (f * num1) / fac
	s = s + sum;
} while
(sum < eps);
err = printf("%lf", s);
if (err < 0) {
	perror("Ошибка вывода");
}

return 0;

}