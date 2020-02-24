//==============================================НОМЕР 1.2-10=============================================================
// Вторая практическая работа. Задача: Написать программу на Си по варинатам (2-0-19)
//=======================================================================================================================

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <math.h>
int main() {
	int f, f1, f2, num, num1, num2, num3, fac;
	double s, sum, eps;
	int err = scanf("%lf", &eps);
	if (err < 0) {
		perror("Ошибка ввода");
	}
	else if (err == 0) {
		perror("Ожидалось число");
	}

	f = 1;
	f1 = 1;
	f2 = 0;
	sum = 0;
	num = 2;
	num1 = 1;
	num2 = 3;
	num3 = 3;
	fac = 2; 

	do {
		f = f1 + f2;
		f1 = f2;
		f2 = f; 
		num1 = num1 * 16;
		fac = fac * num;
		num = num + 1; 
		num2 = sqrt(num3);
		num3 = num3 + 1; 
		sum = (f * num1 * num2) / fac; 
		s = s + sum;
	} while
		(sum < eps);
		err = printf("%lf", s);
	if (err < 0) {
		perror("Ошибка вывода");
	}

	return 0;

}
