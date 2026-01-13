///|
const DESKFLOW_APP_NAME = "Deskflow"

///|
const DESKFLOW_APP_PATH = "/Applications/Deskflow.app"

///|
pub async fn run(server_config : @common.ServerConfig) -> Unit {
  while true {
    println("等待锁屏...")
    @lib.lock_listen(@lib.LockState::Locked)
    println("已锁屏🔒，通知其它客户端锁屏并关闭Deskflow")
    notify_to_all_clients(server_config)
    stop_app(DESKFLOW_APP_NAME)
    println("等待解锁...")
    @lib.lock_listen(@lib.LockState::UnLocked)
    println("已解锁🔓")
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
    let (res, _) = @http.post(url, b"", headers~) catch {
      e => {
        println("请求 \{url} 失败: \{e}")
        continue
      }
    }
    if res.code == 200 {
      println("通知客户端 \{name}(\{url}) 成功")
    } else {
      println("通知客户端 \{name}(\{url}) 失败")
    }
  }
}

///|
async fn stop_app(app_name : String) -> Unit {
  println("stopping \{app_name}...")
  let (code, data) = @process.collect_stdout("pgrep", ["-fl", app_name])
  guard code is 0 else { return }
  let lines = data
    .text()
    .split("\n")
    .map(line => line
      .split(" ")
      .filter(v => !v.is_blank())
      .map(v => v.trim())
      .collect())
    .collect()
  guard lines.length() > 0 else {
    println("Couldn't find any running apps named \"\{app_name}\"")
    return
  }
  for line in lines {
    guard line is [pid, app_path, ..] else { continue }
    let res = @process.run("kill", ["-9", pid.to_string()])
    guard res is 0 else { continue }
    println("关闭 [\{pid}]\{app_path} 成功")
  }
}

///|
async fn start_app(app_name : String, app_path : String) -> Unit {
  println("starting \{app_name}...")
  let res = @process.run("open", [app_path])
  guard res is 0 else { return }
  println("start \{app_name} success")
}
