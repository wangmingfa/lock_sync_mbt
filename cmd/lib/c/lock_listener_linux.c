#ifdef __linux__

#include "lock_listener.h"
#include <dbus/dbus.h>
#include <stdio.h>
#include <unistd.h>

typedef struct {
    int flags;
    int fired;
    lock_state_cb cb;
    void *userdata;
} LockWaitContext;

static void handle_lock_signal(DBusMessage* msg, LockWaitContext* ctx) {
    if (ctx->fired) return;
    if (!msg) return;

    const char *member = dbus_message_get_member(msg);
    if (!member) return;

    if (strcmp(member, "ActiveChanged") == 0) {
        DBusMessageIter args;
        if (dbus_message_iter_init(msg, &args) && dbus_message_iter_get_arg_type(&args) == DBUS_TYPE_BOOLEAN) {
            dbus_bool_t active;
            dbus_message_iter_get_basic(&args, &active);
            if ((ctx->flags & WAIT_LOCK) && active) {
                ctx->fired = 1;
                ctx->cb(1, ctx->userdata);
            } else if ((ctx->flags & WAIT_UNLOCK) && !active) {
                ctx->fired = 1;
                ctx->cb(0, ctx->userdata);
            }
        }
    }
}

void lock_wait_once(int flags, lock_state_cb cb, void *userdata) {
    if (!cb || flags == 0) return;

    LockWaitContext ctx = { flags, 0, cb, userdata };

    DBusError err;
    dbus_error_init(&err);

    DBusConnection* conn = dbus_bus_get(DBUS_BUS_SESSION, &err);
    if (dbus_error_is_set(&err) || !conn) {
        fprintf(stderr, "Failed to connect to D-Bus: %s\n", err.message);
        dbus_error_free(&err);
        return;
    }

    dbus_bus_add_match(conn,
        "type='signal',interface='org.freedesktop.ScreenSaver',member='ActiveChanged'",
        &err);
    if (dbus_error_is_set(&err)) {
        fprintf(stderr, "Failed to add D-Bus match: %s\n", err.message);
        dbus_error_free(&err);
        return;
    }

    while (!ctx.fired) {
        dbus_connection_read_write_dispatch(conn, -1);
        DBusMessage* msg = dbus_connection_pop_message(conn);
        if (msg) {
            handle_lock_signal(msg, &ctx);
            dbus_message_unref(msg);
        }
        usleep(1000);
    }
}

#endif /* __linux__ */
