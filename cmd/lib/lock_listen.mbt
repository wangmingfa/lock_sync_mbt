///|
type LockStateCallback = FuncRef[(Int, Int) -> Unit]

///|
extern "C" fn lock_wait_once(
  flags : Int,
  callback : LockStateCallback,
  userdata : Int,
) -> Unit = "lock_wait_once"

///|
pub(all) enum LockState {
  Locked
  UnLocked
}

///|
pub fn lock_listen(listen_state : LockState) -> Unit {
  let flags = if listen_state is Locked { 1 } else { 2 }
  lock_wait_once(flags, fn(_, _) {  }, 0)
}
