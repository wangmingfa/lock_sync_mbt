#include "command.h"
#include <stdio.h>
#include <stdint.h>

void print_line(const uint8_t *buf, size_t len, void *userdata) {
    // 转为字符串打印
    printf("C received: ");
    for (size_t i = 0; i < len; i++) {
        putchar(buf[i]);
    }
    printf("\n");
}

int main() {
    run_command_stream("echo hello world", print_line, NULL);
    return 0;
}
