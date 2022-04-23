#include <stdio.h>

int copy_string(char* dst, const char* src, int size);

int string_length(const char* string)
{
    asm(
        ".intel_syntax noprefix\n\t"
        "xor rax, rax\n\t"
        "mov rcx, -1\n\t"

        "mov rdi, [rbp - 8]\n\t"
        "repne scasb\n\t"

        "not rcx\n\t"
        "dec rcx\n\t"
        "mov rax, rcx\n\t"
        ".att_syntax prefix\n\t"
    );
}

int main()
{
    const char* str = "test";
    char buf[100];

    printf("SRC: %s\nlen: %d\n", str, string_length(str));

    copy_string(buf, str, string_length(str));

    printf("COPIED: %s\n", buf);

    return 0;
}
