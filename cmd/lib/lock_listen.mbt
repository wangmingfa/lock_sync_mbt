///|
type MacOSLockStateCallback = FuncRef[(Int, Int) -> Unit]

///|
#cfg(not(platform="windows"))
extern "C" fn macos_lock_wait_once(
  flags : Int,
  callback : MacOSLockStateCallback,
  userdata : Int,
) -> Unit = "macos_lock_wait_once"

///|
pub(all) enum LockState {
  Locked
  UnLocked
}

///|
#cfg(not(platform="windows"))
pub fn lock_listen(listen_state : LockState) -> Unit {
  let flags = if listen_state is Locked { 1 } else { 0 }
  macos_lock_wait_once(flags, fn(_, _) {  }, 0)
}
