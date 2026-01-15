///|
pub fn log_prefix() -> String {
  "[\{now_datetime_str()}]"
}

///|
#callsite(autofill(loc))
pub fn info(msg : String, loc~ : SourceLoc) -> Unit {
  let _ = loc
  println("[INFO] \{log_prefix()} \{msg}")
}
