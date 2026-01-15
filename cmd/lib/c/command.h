#ifndef COMMAND_H
#define COMMAND_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*line_cb)(const uint8_t *buf, size_t len, void *userdata);

int run_command_stream(const char *cmd, line_cb cb, void *userdata);

#ifdef __cplusplus
}
#endif

#endif
