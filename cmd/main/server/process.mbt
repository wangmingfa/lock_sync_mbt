///|
priv struct App {
  pid : Int
  process_name : String
}

///|
async fn get_running_apps(app_name : String) -> ReadOnlyArray[App] {
  // macos
  if @lib.is_macos() {
    let (code, data) = @process.collect_stdout("pgrep", ["-fl", app_name])
    guard code is 0 else { return [] }
    /// 格式：
    /// 8480 /Applications/Deskflow.app/Contents/MacOS/Deskflow
    /// 8486 /Applications/Deskflow.app/Contents/MacOS/deskflow-core server
    let arr = data
      .text()
      .trim()
      .split("\n")
      .map(line => lexmatch line {
        (("[[:digit:]]+" as pid) "[[:space:]]+", process_name) => {
          let pid = @strconv.parse_int(pid) catch { _ => return None }
          Some(App::{ pid, process_name: process_name.to_string() })
        }
        _ => return None
      })
      .collect()
      .filter_map(v => v)
    return ReadOnlyArray::from_array(arr)
  }

  // windows
  if @lib.is_windows() {
    let (code, data) = @process.collect_stdout("Get-Process", [app_name])
    guard code is 0 else { return [] }
    /// 格式：
    /// NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
    /// ------    -----      -----     ------      --  -- -----------
    /// 117    79.88     149.91     927.36   37488   1 deskflow
    let apps = data.text().trim().split("\n")[2:]
      .filter_map(line => lexmatch line {
        (
          ("[[:digit:]]+" as _npm)
          "[[:space:]]+"
          ("[[:digit:]]+\.[[:digit:]]+" as _pm)
          "[[:space:]]+"
          ("[[:digit:]]+\.[[:digit:]]+" as _ws)
          "[[:space:]]+"
          ("[[:digit:]]+\.[[:digit:]]+" as _cpu)
          "[[:space:]]+"
          ("[[:digit:]]+" as pid)
          "[[:space:]]+"
          ("[[:digit:]]+" as _si)
          "[[:space:]]+"
          ("[[:alpha:]]+" as process_name),
          _
        ) => {
          let pid = @strconv.parse_int(pid) catch { _ => return None }
          Some(App::{ pid, process_name: process_name.to_string() })
        }
        _ => None
      })
      .collect()
    return ReadOnlyArray::from_array(apps)
  }
  // 暂不支持linux作为服务端
  return []
}

///|
async fn stop_app(app_name : String) -> Unit {
  println("stopping \{app_name}...")
  let apps = get_running_apps(app_name)
  if apps.is_empty() {
    println("could not find running apps named \"\{app_name}\"")
    return
  }
  for app in apps {
    let { pid, process_name } = app
    let res = @process.run("kill", ["-9", pid.to_string()])
    guard res is 0 else { continue }
    println("关闭 [\{pid}]\{process_name} 成功")
  }
}

///|
async fn start_app(app_name : String, app_path : String) -> Unit {
  println("starting \{app_name}...")
  let res = @process.run("open", [app_path])
  guard res is 0 else { return }
  println("start \{app_name} success")
}
