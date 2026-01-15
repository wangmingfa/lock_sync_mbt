///|
struct DateTime {
  year : Int
  month : Int // 1-12
  day : Int // 1-31
  hour : Int // 0-23
  min : Int // 0-59
  sec : Int // 0-59
  msec : Int // 0-999
} derive(Default)


///|
#owned(datetime)
extern "C" fn timestamp_ms_to_locale(timestamp : Int64, datetime: DateTime) -> Int = "timestamp_ms_to_locale"

///|
pub fn now() -> UInt64 {
  @env.now()
}

///|
pub fn now_datetime() -> DateTime {
  try! ts_to_datetime(now())
}

///|
pub fn now_datetime_str() -> String {
  let { year, month, day, hour, min, sec, .. } = try! ts_to_datetime(now())
  let month = "\{month}".pad_start(2, '0')
  let day = "\{day}".pad_start(2, '0')
  let hour = "\{hour}".pad_start(2, '0')
  let min = "\{min}".pad_start(2, '0')
  let sec = "\{sec}".pad_start(2, '0')
  "\{year}-\{month}-\{day} \{hour}:\{min}:\{sec}"
}

///|
pub fn ts_to_datetime(timestamp : UInt64) -> DateTime raise Failure{
  let dateTime = DateTime::default()
  let res = timestamp_ms_to_locale(timestamp.reinterpret_as_int64(), dateTime)
  guard res == 0 else {
    raise fail("无效的时间戳 \{timestamp}")
  }
  dateTime
}
