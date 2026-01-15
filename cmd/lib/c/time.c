#include <stdint.h>
#include <time.h>

typedef struct {
    int year;
    int month;  // 1-12
    int day;    // 1-31
    int hour;   // 0-23
    int min;    // 0-59
    int sec;    // 0-59
    int msec;   // 0-999
} DateTime;

int timestamp_ms_to_locale(int64_t timestamp_ms, DateTime* out) {
    if (!out) return -1;

    time_t seconds = (time_t)(timestamp_ms / 1000);

    int msec = (int)(timestamp_ms % 1000);
    if (msec < 0) msec += 1000;

    struct tm tm_local;

#if defined(_WIN32)
    if (localtime_s(&tm_local, &seconds) != 0)
        return -1;
#else
    if (localtime_r(&seconds, &tm_local) == NULL)
        return -1;
#endif

    out->year  = tm_local.tm_year + 1900;
    out->month = tm_local.tm_mon + 1;
    out->day   = tm_local.tm_mday;
    out->hour  = tm_local.tm_hour;
    out->min   = tm_local.tm_min;
    out->sec   = tm_local.tm_sec;
    out->msec  = msec;

    return 0;
}
