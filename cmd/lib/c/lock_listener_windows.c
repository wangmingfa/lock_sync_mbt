#ifdef _WIN32

#include "lock_listener.h"
// #include <windows.h>
// #include <wtsapi32.h>

// #pragma comment(lib, "Wtsapi32.lib")

// typedef struct {
//     int flags;
//     lock_state_cb cb;
//     void *userdata;
// } LockWaitContext;

// static LockWaitContext *g_ctx = NULL;

// static LRESULT CALLBACK hidden_wnd_proc(
//     HWND hwnd,
//     UINT msg,
//     WPARAM wparam,
//     LPARAM lparam
// ) {
//     (void)hwnd;
//     (void)lparam;

//     if (msg == WM_WTSSESSION_CHANGE && g_ctx) {
//         if ((wparam == WTS_SESSION_LOCK) &&
//             (g_ctx->flags & LOCK_WAIT_LOCK)) {

//             g_ctx->cb(1, g_ctx->userdata);
//             PostQuitMessage(0);
//             return 0;
//         }

//         if ((wparam == WTS_SESSION_UNLOCK) &&
//             (g_ctx->flags & LOCK_WAIT_UNLOCK)) {

//             g_ctx->cb(0, g_ctx->userdata);
//             PostQuitMessage(0);
//             return 0;
//         }
//     }

//     return DefWindowProc(hwnd, msg, wparam, lparam);
// }

// void lock_wait_once(
//     int flags,
//     lock_state_cb cb,
//     void *userdata
// ) {
//     if (!cb || flags == 0) return;

//     LockWaitContext ctx = {
//         .flags = flags,
//         .cb = cb,
//         .userdata = userdata
//     };
//     g_ctx = &ctx;

//     HINSTANCE hinst = GetModuleHandle(NULL);

//     WNDCLASS wc = {0};
//     wc.lpfnWndProc = hidden_wnd_proc;
//     wc.hInstance = hinst;
//     wc.lpszClassName = TEXT("LockListenerHiddenWindow");

//     RegisterClass(&wc);

//     HWND hwnd = CreateWindowEx(
//         0,
//         wc.lpszClassName,
//         TEXT(""),
//         0,
//         0, 0, 0, 0,
//         HWND_MESSAGE,
//         NULL,
//         hinst,
//         NULL
//     );

//     WTSRegisterSessionNotification(
//         hwnd,
//         NOTIFY_FOR_THIS_SESSION
//     );

//     MSG msg;
//     while (GetMessage(&msg, NULL, 0, 0) > 0) {
//         TranslateMessage(&msg);
//         DispatchMessage(&msg);
//     }

//     WTSUnRegisterSessionNotification(hwnd);
//     DestroyWindow(hwnd);
//     g_ctx = NULL;
// }

/* 其他平台占位实现 */
void lock_wait_once(int flags, lock_state_cb cb, void *userdata) {
    (void)flags;
    (void)cb;
    (void)userdata;
}

#endif /* _WIN32 */
