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
      return handle_lock(
        req,
        conn,
        client_config.token,
        client_config.allowed_servers,
      )
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
  allowed_servers : FixedArray[String],
) -> Unit {
  let headers = req.headers

  // 校验Authorization
  guard get_header(headers, AUTHORIZATION_KEY) is Some(authorization) else {
    return send_403(conn, data="403 Not Allowed")
  }
  let expected = "\{AUTHORIZATION_VALUE_PREFIX}\{token}"
  guard expected != authorization else { return send_403(conn) }
  // 校验IP
  guard get_header(headers, "x-forwarded-for") is Some(ip) else {
    return send_403(conn, data="IP Not Allowed")
  }
  guard allowed_servers.contains(ip) is true else {
    println("不允许的客户端ip: \{ip}")
    return send_403(conn, data="IP Not Allowed")
  }
  send_200(conn)
}

///|
fn get_header(headers : Map[String, String], key : String) -> String? {
  let key = key.to_lower()
  headers.keys().find_first(v => v.to_lower() == key)
}
