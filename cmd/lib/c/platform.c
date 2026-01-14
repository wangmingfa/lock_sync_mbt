#include "platform.h"

/*
 * 说明：
 * - 这是“编译期”判断
 * - 最安全、最常用
 * - 不依赖 libc / OS API
 */

platform_t get_platform(void) {
#if defined(_WIN32) || defined(_WIN64)
    return PLATFORM_WINDOWS;
#elif defined(__APPLE__) && defined(__MACH__)
    return PLATFORM_MACOS;
#elif defined(__linux__)
    return PLATFORM_LINUX;
#else
    return PLATFORM_UNKNOWN;
#endif
}

int is_windows(void) {
#if defined(_WIN32) || defined(_WIN64)
    return 1;
#else
    return 0;
#endif
}

int is_macos(void) {
#if defined(__APPLE__) && defined(__MACH__)
    return 1;
#else
    return 0;
#endif
}

int is_linux(void) {
#if defined(__linux__)
    return 1;
#else
    return 0;
#endif
}
