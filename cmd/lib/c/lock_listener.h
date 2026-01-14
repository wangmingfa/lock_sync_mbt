#ifndef LOCK_LISTENER_H
#define LOCK_LISTENER_H

#ifdef __cplusplus
extern "C" {
#endif

#define LOCK_WAIT_LOCK   1
#define LOCK_WAIT_UNLOCK 2

// state: 1 = locked, 0 = unlocked
typedef void (*lock_state_cb)(int state, void *userdata);

// 阻塞，直到收到一次 lock / unlock
void lock_wait_once(
    int flags,
    lock_state_cb cb,
    void *userdata
);

#ifdef __cplusplus
}
#endif

#endif
