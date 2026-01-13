///|
async fn send_200(conn : @http.ServerConnection) -> Unit {
  conn.send_response(200, "OK")
}

///|
async fn send_403(conn : @http.ServerConnection, data? : String = "") -> Unit {
  conn..send_response(403, "Forbiden")..write(data)
}

///|
async fn send_404(conn : @http.ServerConnection, data? : String = "") -> Unit {
  conn..send_response(404, "NotFound")..write(data)
}
