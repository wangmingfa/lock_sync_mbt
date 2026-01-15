///|
type RunCommandStreamCallback[T] = FuncRef[(Bytes, Int64, T) -> Unit]

///|
type UserData = @buffer.Buffer

///|
#borrow(cmd, userdata)
extern "C" fn run_command_stream(
  cmd : Bytes,
  callback : RunCommandStreamCallback[UserData],
  userdata : UserData,
) -> Int = "run_command_stream"

///|
pub fn run_command(cmd : String) -> (Int, &@io.Data) {
  let buffer = @buffer.new()
  let code = run_command_stream(
    @encoding/utf8.encode(cmd),
    fn(data, len, buffer) {
      let data = data[0:len.to_int()].to_bytes()
      buffer.write_bytes(data)
    },
    buffer,
  )
  return (code, buffer.to_bytes())
}
