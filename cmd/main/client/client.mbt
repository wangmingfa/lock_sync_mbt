///|
pub async fn run(client_config : @common.ClientConfig) -> Unit {
  println("=================客户端模式=================")
  let addr = @socket.Addr::parse(client_config.listen) catch { e => raise e }
  println("地址：http://\{addr.to_string()}")
  @http.Server::new(addr, reuse_addr=true).run_forever(async fn(
    req,
    reader,
    conn,
  ) {
    let url = req.path
    let params = reader.read_all().text()
    println("url: \{req.path}, params: \{params}")
    if url == "/lock" {
      return handle_lock(req, conn, client_config.token, client_config)
    }
    send_404(conn, data="`\{url}` not found")
  })
}

///|
pub const AUTHORIZATION_KEY = "Authorization"

///|
pub const AUTHORIZATION_VALUE_PREFIX = "Bearer "

///|
async fn handle_lock(
  req : @http.Request,
  conn : @http.ServerConnection,
  token : String,
  client_config : @common.ClientConfig,
) -> Unit {
  let headers = req.headers

  // 校验Authorization
  guard get_header(headers, AUTHORIZATION_KEY) is Some(authorization) else {
    return send_403(conn, data="403 Not Allowed")
  }
  let expected = "\{AUTHORIZATION_VALUE_PREFIX}\{token}"
  guard expected != authorization else {
    return send_403(conn, data="Authentication Failed")
  }
  // 校验IP（addr里面包含了ip和端口，格式为：127.0.0.1:8080）
  let ip = conn.client_addr().to_string().split(":").collect()[0].to_string()
  let allowed_servers = client_config.allowed_servers
  guard allowed_servers.contains(ip) is true else {
    println("不允许的客户端ip: \{ip}")
    return send_403(conn, data="IP Not Allowed")
  }
  lock_screen()
  send_200(conn)
}

///|
pub async fn lock_screen() -> Unit {
  let (code, output) = match @lib.get_platform() {
    Windows => {
      println("Windows锁屏")
      // moonbit运行无法锁屏，改用c语言
      /// @process.collect_output_merged("rundll32.exe", [
      ///   "user32.dll,LockWorkStation",
      /// ])
      @lib.run_command("rundll32.exe user32.dll,LockWorkStation")
    }
    Linux => {
      println("Linux锁屏")
      @process.collect_output_merged("loginctl", ["lock-session"])
    }
    MacOS => {
      println("MacOS锁屏")
      // 请注意，此操作需要授权：设置->隐私与安全性->辅助功能->点击+，添加对应的程序
      // 如果是在独立的终端应用运行当前程序，则添加对应的终端应用
      // 如果是在vscode等IDE里面，则添加对应的IDE即可
      @process.collect_output_merged("osascript", [
        "-e", "tell application \"System Events\" to key code 12 using {control down, command down}",
      ])
    }
    _ => {
      println("不支持的操作系统，无法锁屏")
      panic()
    }
  }
  let text = output.text()
  let has_output = !text.is_blank()
  let msg = if code == 0 { "成功" } else { "失败" }
  let msg = msg + (if has_output { ":" } else { "" })
  println("锁屏\{msg}")
  println(output.text())
}

///|
#cfg(platform="linux")
async fn lock_screen() -> Unit {
  let _ = @process.run("loginctl", ["lock-session"])

}

///|
fn get_header(headers : Map[String, String], key : String) -> String? {
  let key = key.to_lower()
  headers.keys().find_first(v => v.to_lower() == key)
}
