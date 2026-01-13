#ifndef MACOS_LOCK_H
#define MACOS_LOCK_H

#ifdef __cplusplus
extern "C" {
#endif

#define MACOS_WAIT_LOCK    1
#define MACOS_WAIT_UNLOCK  2

typedef void (*lock_state_cb)(int locked, void *userdata);

// 阻塞等待一次锁屏或解锁（由 flags 控制）
void macos_lock_wait_once(
    int flags,
    lock_state_cb cb,
    void *userdata
);

#ifdef __cplusplus
}
#endif

#endif
