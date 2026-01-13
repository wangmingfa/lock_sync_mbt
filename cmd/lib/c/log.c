#include <stdio.h>
#include <time.h>

#if defined(_WIN32)
  #define LOCALTIME(t, tm) localtime_s((tm), (t))
#else
  #define LOCALTIME(t, tm) localtime_r((t), (tm))
#endif

#define LOG(fmt, ...) do {                                      \
    time_t _t = time(NULL);                                     \
    struct tm _tm;                                              \
    LOCALTIME(&_t, &_tm);                                       \
    printf("[%04d-%02d-%02d %02d:%02d:%02d] " fmt "\n",         \
        _tm.tm_year + 1900,                                     \
        _tm.tm_mon + 1,                                         \
        _tm.tm_mday,                                            \
        _tm.tm_hour,                                            \
        _tm.tm_min,                                             \
        _tm.tm_sec,                                             \
        ##__VA_ARGS__);                                         \
    fflush(stdout);                                             \
} while (0)
