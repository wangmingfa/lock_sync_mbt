#include "macos_lock.h"
#include <stdio.h>
#include "log.c"

static void on_event(int locked, void *ud)
{
    if (locked)
    {
        printf("[test] screen locked\n");
    }
    else
    {
        printf("[test] screen unlocked\n");
    }
    fflush(stdout);
}

int main(void)
{
    // 监听锁屏
    LOG("[test] waiting for LOCK only...");
    fflush(stdout);

    macos_lock_wait_once(
        MACOS_WAIT_LOCK,
        on_event,
        NULL);

    // 监听解锁
    LOG("[test] waiting for UNLOCK only...");
    macos_lock_wait_once(
        MACOS_WAIT_UNLOCK,
        on_event,
        NULL);

    LOG("[test] done\n");
    return 0;
}
