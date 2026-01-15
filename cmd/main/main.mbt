///|
async fn main {
  guard @env.current_dir() is Some(dir) else { return }
  let args = @env.args()
  @lib.info("dir: \{dir}")
  @lib.info("args: \{args}")
  if args.length() < 2 {
    println(
      (
        #| 用法:
        #|   lock_sync_mbt.exe <mode>
        #| 
        #| 说明:
        #|   mode     运行模式，支持server、client
        #| 
        #| 示例:
        #|   lock_sync_mbt.exe server   # 锁定系统
        #|   lock_sync_mbt.exe client   # 执行同步操作
      ),
    )
    return
  }
  match args[1] {
    "server" => @server.run(@common.load_server_config())
    "client" => @client.run(@common.load_client_config())
    a => println("不支持的模式：\{a}")
  }
}
