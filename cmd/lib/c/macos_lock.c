#include "macos_lock.h"
#include <CoreFoundation/CoreFoundation.h>

typedef struct {
    int flags;
    int fired;
    lock_state_cb cb;
    void *userdata;
} LockWaitContext;

static void notification_callback(
    CFNotificationCenterRef center,
    void *observer,
    CFStringRef name,
    const void *object,
    CFDictionaryRef userInfo
) {
    if (!observer || !name) return;

    LockWaitContext *ctx = (LockWaitContext *)observer;
    if (ctx->fired) return;

    if ((ctx->flags & MACOS_WAIT_LOCK) &&
        CFStringCompare(name, CFSTR("com.apple.screenIsLocked"), 0)
            == kCFCompareEqualTo) {

        ctx->fired = 1;
        ctx->cb(1, ctx->userdata);
        CFRunLoopStop(CFRunLoopGetCurrent());
        return;
    }

    if ((ctx->flags & MACOS_WAIT_UNLOCK) &&
        CFStringCompare(name, CFSTR("com.apple.screenIsUnlocked"), 0)
            == kCFCompareEqualTo) {

        ctx->fired = 1;
        ctx->cb(0, ctx->userdata);
        CFRunLoopStop(CFRunLoopGetCurrent());
        return;
    }
}

void macos_lock_wait_once(
    int flags,
    lock_state_cb cb,
    void *userdata
) {
    if (!cb || flags == 0) {
        return;
    }

    LockWaitContext ctx = {
        .flags = flags,
        .fired = 0,
        .cb = cb,
        .userdata = userdata
    };

    CFNotificationCenterRef center =
        CFNotificationCenterGetDistributedCenter();

    if (flags & MACOS_WAIT_LOCK) {
        CFNotificationCenterAddObserver(
            center,
            &ctx,
            notification_callback,
            CFSTR("com.apple.screenIsLocked"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately
        );
    }

    if (flags & MACOS_WAIT_UNLOCK) {
        CFNotificationCenterAddObserver(
            center,
            &ctx,
            notification_callback,
            CFSTR("com.apple.screenIsUnlocked"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately
        );
    }

    CFRunLoopRun();

    // 清理 observer（按 flags）
    if (flags & MACOS_WAIT_LOCK) {
        CFNotificationCenterRemoveObserver(
            center,
            &ctx,
            CFSTR("com.apple.screenIsLocked"),
            NULL
        );
    }

    if (flags & MACOS_WAIT_UNLOCK) {
        CFNotificationCenterRemoveObserver(
            center,
            &ctx,
            CFSTR("com.apple.screenIsUnlocked"),
            NULL
        );
    }
}
