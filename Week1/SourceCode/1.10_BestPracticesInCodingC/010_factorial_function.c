int factorial(int n) {
int fac = 1;
int i;
for(i = 2; i <= n; ++i)
fac *= i;
return fac;
}
