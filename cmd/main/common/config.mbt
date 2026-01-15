///|
pub struct ServerClient {
  name : String
  url : String
} derive(FromJson)

///|
pub struct ServerConfig {
  token : String
  clients : FixedArray[ServerClient]
} derive(FromJson)

///|
pub struct ClientConfig {
  token : String
  listen : String
  allowed_servers : FixedArray[String]
} derive(FromJson)

///|
pub enum ConfgType {
  Server
  Client
}

///|
async fn load_config(config_type : ConfgType) -> (ServerConfig?, ClientConfig?) {
  guard @env.current_dir() is Some(dir) else {
    raise fail("找不到运行目录")
  }
  let config_file_path = "\{dir}/config.json"
  let exist = @fs.exists(config_file_path) catch {
    _ => raise fail("配置文件加载失败")
  }
  if !exist {
    raise fail("找不到配置文件")
  }
  let file_content = @fs.read_file(config_file_path).json()
  guard file_content is Object(config)
  @lib.info("使用配置文件 \{config_file_path}")
  match config_type {
    Server => {
      guard config.get("server") is Some(config)
      (Some(@json.from_json(config)), None)
    }
    Client => {
      guard config.get("client") is Some(config)
      (None, Some(@json.from_json(config)))
    }
  }
}

///|
pub async fn load_server_config() -> ServerConfig {
  load_config(Server).0.unwrap()
}

///|
pub async fn load_client_config() -> ClientConfig {
  load_config(Client).1.unwrap()
}
