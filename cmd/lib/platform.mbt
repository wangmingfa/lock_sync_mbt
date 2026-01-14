///|
pub extern "C" fn get_platform() -> Platform = "get_platform"

///|
pub enum Platform {
  Unknown = 0
  Windows
  MacOS
  Linux
}

///|
pub fn is_windows() -> Bool {
  get_platform() is Windows
}

///|
pub fn is_macos() -> Bool {
  get_platform() is MacOS
}

///|
pub fn is_linux() -> Bool {
  get_platform() is Linux
}
