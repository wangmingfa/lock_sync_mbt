///|
pub extern "C" fn get_platform() -> Platform = "get_platform"

///|
pub(all) enum Platform {
  Unknown = 0
  Windows
  MacOS
  Linux
} derive(Eq)

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

///|
pub fn match_platform(platforms : Array[Platform]) -> Bool {
  let platform = get_platform()
  platforms.contains(platform)
}
