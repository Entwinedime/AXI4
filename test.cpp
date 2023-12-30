#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>

int main() {
    uint8_t a[4];
    uint8_t (&b)[4] = a;
    a[0] = 1;

    std::cout << (int)b[0] << std::endl;
    return 0;
}