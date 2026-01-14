#pragma once

/* 平台枚举 */
typedef enum {
    PLATFORM_UNKNOWN = 0,
    PLATFORM_WINDOWS,
    PLATFORM_MACOS,
    PLATFORM_LINUX
} platform_t;

/* 获取当前平台（编译期确定） */
platform_t get_platform(void);

/* 便捷判断 */
int is_windows(void);
int is_macos(void);
int is_linux(void);
