#include "command.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <moonbit.h>

int run_command_stream(const char *cmd, line_cb cb, void *userdata)
{
    if (!cmd || !cb)
        return -1;

#if defined(_WIN32) || defined(_WIN64)
    FILE *fp = _popen(cmd, "rb");
#else
    FILE *fp = popen(cmd, "r");
#endif

    if (!fp)
        return -1;

    uint8_t *buf = moonbit_make_bytes(1024, 0);
    size_t n;

    while ((n = fread(buf, 1, sizeof(buf), fp)) > 0)
    {
        cb(buf, n, userdata);
    }

#if defined(_WIN32) || defined(_WIN64)
    int ret = _pclose(fp);
#else
    int ret = pclose(fp);
#endif
    return ret;
}
