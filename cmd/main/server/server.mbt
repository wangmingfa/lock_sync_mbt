///|
const DESKFLOW_APP_NAME = "Deskflow"

///|
const DESKFLOW_APP_PATH = "/Applications/Deskflow.app"

///|
pub async fn run(server_config : @common.ServerConfig) -> Unit {
  if @lib.match_platform([Windows, Linux]) {
    println("暂不支持Windows、Linux作为服务端")
    return
  }
  while true {
    @lib.info("等待锁屏...")
    @lib.lock_listen(@lib.LockState::Locked)
    @lib.info("已锁屏🔒，通知其它客户端锁屏并关闭Deskflow")
    notify_to_all_clients(server_config)
    stop_app(DESKFLOW_APP_NAME)
    @async.sleep(1000)
    // 等待解锁
    @lib.info("等待解锁...")
    @lib.lock_listen(@lib.LockState::UnLocked)
    @lib.info("已解锁🔓")
    @async.sleep(1000)
    start_app(DESKFLOW_APP_NAME, DESKFLOW_APP_PATH)
    @async.pause()
  }
}

///|
async fn notify_to_all_clients(server_config : @common.ServerConfig) -> Unit {
  for client in server_config.clients {
    let { name, url } = client
    let headers = {}
    headers[@client.AUTHORIZATION_KEY] = "\{@client.AUTHORIZATION_VALUE_PREFIX}\{server_config.token}"
    let (res, data) = @http.post(url, b"", headers~) catch {
      e => {
        println("请求 \{url} 失败: \{e}")
        continue
      }
    }
    if res.code == 200 {
      println("通知客户端 \{name}(\{url}) 成功")
    } else {
      println(
        "通知客户端 \{name}(\{url}) 失败: \{res.reason} | \{data.text()}",
      )
    }
  }
}
