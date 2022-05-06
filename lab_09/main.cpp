#include <cstdio>
#include <iostream>
#include <iomanip>
#include <ctime>

void fpu_sin(long double);

float add_floats(float a, float b);
float mul_floats(float a, float b);

float fpu_add_floats(float a, float b);
float fpu_mul_floats(float a, float b);

double add_doubles(double a, double b);
double mul_doubles(double a, double b);

double fpu_add_doubles(double a, double b);
double fpu_mul_doubles(double a, double b);

long double add_long_doubles(long double a, long double b);
long double mul_long_doubles(long double a, long double b);

long double fpu_add_long_doubles(long double a, long double b);
long double fpu_mul_long_doubles(long double a, long double b);

template <typename Num, Num Fn(Num, Num)>
double measure_time(Num a, Num b)
{
    Num c;
    int iters = 10000;
    clock_t now = clock();

    for (int i = 0; i < iters; i++)
        c = Fn(a, b);

    return static_cast<double>(clock() - now) / iters;
}

void test_float()
{
    float a = 100, b = 20;

    double time = measure_time<float, fpu_add_floats>(a, b);
    printf("float add fpu: %lf\n", time);

    time = measure_time<float, add_floats>(a, b);
    printf("float add no fpu: %lf\n", time);

    time = measure_time<float, fpu_mul_floats>(a, b);
    printf("float mul fpu: %lf\n", time);

    time = measure_time<float, mul_floats>(a, b);
    printf("float mul no fpu: %lf\n", time);
}

void test_double()
{
    double a = 100, b = 20;

    double time = measure_time<double, fpu_add_doubles>(a, b);
    printf("double add fpu: %lf\n", time);

    time = measure_time<double, add_doubles>(a, b);
    printf("double add no fpu: %lf\n", time);

    time = measure_time<double, fpu_mul_doubles>(a, b);
    printf("double mul fpu: %lf\n", time);

    time = measure_time<double, mul_doubles>(a, b);
    printf("double mul no fpu: %lf\n", time);
}

void test_long_double()
{
    long double a = 100, b = 20;

    double time = measure_time<long double, fpu_add_long_doubles>(a, b);
    printf("long double add fpu: %lf\n", time);

    time = measure_time<long double, add_long_doubles>(a, b);
    printf("long double add no fpu: %lf\n", time);

    time = measure_time<long double, fpu_mul_long_doubles>(a, b);
    printf("long double mul fpu: %lf\n", time);

    time = measure_time<long double, mul_long_doubles>(a, b);
    printf("long double mul no fpu: %lf\n", time);
}

int main()
{
    test_float();
    test_double();
    test_long_double();

    printf("\n===========================\nSin test:\n");

    long double fpu_pi;

    __asm__(
        ".intel_syntax noprefix         \n\t"
        "finit                          \n\t"
        "fldpi                          \n\t"
        "fstpt [rbp-16]                 \n\t"
        ".att_syntax prefix             \n\t"
    );

    printf("\nFPU_PI: %.62llf\n", fpu_pi);

    fpu_sin(fpu_pi);

    printf("\nPI: 3.14\n");

    fpu_sin(3.14);

    printf("\nPI: 3.141596\n");

    fpu_sin(3.141596);

    return 0;
}

void fpu_sin(long double pi)
{
    long double pi2 = pi / 2;
    long double sin_pi;
    long double sin_pi2;

    __asm__(
        ".intel_syntax noprefix     \n\t"
        "finit                      \n\t"
        "fldt [rbp+16]               \n\t"
        "fsin                       \n\t"
        "fstpt [rbp-48]                \n\t"
        "fldt [rbp-32]                    \n\t"
        "fsin                       \n\t"
        "fstpt [rbp-64]               \n\t"
        ".att_syntax prefix         \n\t"
    );

    std::cout << "sin( pi ) = " << std::setprecision(20) << sin_pi << std::endl;
    std::cout << "sin(pi/2) = " << std::setprecision(20) << sin_pi2 << std::endl;
}

float add_floats(float a, float b)
{
    float c = a + b;

    return c;
}

float mul_floats(float a, float b)
{
    float c = a * b;

    return c;
}

float fpu_add_floats(float a, float b)
{
    float c;

    __asm__(
        ".intel_syntax noprefix     \n\t"
        "finit                      \n\t"
        "fld dword ptr [rbp - 20]   \n\t"
        "fadd dword ptr [rbp - 24]  \n\t"
        "fstp dword ptr [rbp - 4]   \n\t"
        ".att_syntax prefix         \n\t"
    );

    return c;
}

float fpu_mul_floats(float a, float b)
{
    float c;

    __asm__(
        ".intel_syntax noprefix     \n\t"
        "finit                      \n\t"
        "fld dword ptr [rbp - 20]   \n\t"
        "fmul dword ptr [rbp - 24]  \n\t"
        "fstp dword ptr [rbp - 4]   \n\t"
        ".att_syntax prefix         \n\t"
    );

    return c;
}

double add_doubles(double a, double b)
{
    double c = a + b;

    return c;
}

double mul_doubles(double a, double b)
{
    double c = a * b;

    return c;
}

double fpu_add_doubles(double a, double b)
{
    double c;

    __asm__(
        ".intel_syntax noprefix     \n\t"
        "finit                      \n\t"
        "fld qword ptr [rbp - 24]   \n\t"
        "fadd qword ptr [rbp - 32]  \n\t"
        "fstp qword ptr [rbp - 8]   \n\t"
        ".att_syntax prefix         \n\t"
    );

    return c;
}

double fpu_mul_doubles(double a, double b)
{
    double c;

    __asm__(
        ".intel_syntax noprefix     \n\t"
        "finit                      \n\t"
        "fld qword ptr [rbp - 24]   \n\t"
        "fmul qword ptr [rbp - 32]  \n\t"
        "fstp qword ptr [rbp - 8]   \n\t"
        ".att_syntax prefix         \n\t"
    );

    return c;
}

long double add_long_doubles(long double a, long double b)
{
    long double c = a + b;

    return c;
}

long double mul_long_doubles(long double a, long double b)
{
    long double c = a * b;

    return c;
}

long double fpu_add_long_doubles(long double a, long double b)
{
    long double c;

    __asm__(
        ".intel_syntax noprefix     \n\t"
        "finit                      \n\t"
        "fldt [rbp + 16]            \n\t"
        "fldt [rbp + 32]            \n\t"
        "faddp st(1), st            \n\t"
        "fstpt [rbp - 16]           \n\t"
        ".att_syntax prefix         \n\t"
    );

    return c;
}

long double fpu_mul_long_doubles(long double a, long double b)
{
    long double c;

    __asm__(
        ".intel_syntax noprefix     \n\t"
        "finit                      \n\t"
        "fldt [rbp + 16]            \n\t"
        "fldt [rbp + 32]            \n\t"
        "fmulp st(1), st            \n\t"
        "fstpt [rbp - 16]           \n\t"
        ".att_syntax prefix         \n\t"
    );

    return c;
}
