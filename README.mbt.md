# lock_sync_mbt

监听电脑锁屏/解锁状态，同步通知到其他客户端。

## 功能特性

- 监听本地电脑锁屏/解锁事件
- 多客户端状态同步
- 跨平台支持（Windows / Linux / macOS）

## 项目结构

```
lock_sync_mbt/
├── cmd/
│   ├── main/
│   │   ├── server/    # 服务端模块
│   │   └── client/    # 客户端模块
├── build.sh           # Linux/macOS 构建脚本
├── build.ps1          # Windows 构建脚本
└── README.md
```

## 编译

### Linux / macOS

```bash
./build.sh
```

### Windows

```powershell
.\build.ps1
```

构建产物：`lock_sync_mbt-<系统>-<架构>.exe`

## 运行

```bash
# 服务端
./lock_sync_mbt-<系统>-<架构>.exe server

# 客户端
./lock_sync_mbt-<系统>-<架构>.exe client
```

## 调试
```bash
# 服务端
moon run cmd/main server
# 客户端
moon run cmd/main client
```

## 配置

程序启动时自动读取 `config.json` 配置文件：

```json
{
  // 服务端配置
  "server": {
    "token": "认证令牌",
    "clients": [
      {
        "name": "客户端名称",
        "url": "http://<客户端IP>:<端口>/lock"
      }
    ]
  },
  // 客户端配置
  "client": {
    "token": "认证令牌",
    "os": "windows",          // 操作系统类型 windows/linux/macos
    "listen": "0.0.0.0:9123", // 监听地址和端口
    "allowed_servers": [
      "服务端IP"
    ]
  }
}
```

| 字段 | 说明 |
|------|------|
| `server.token` | 服务端认证令牌，用于通知客户端 |
| `server.clients` | 要通知的客户端列表 |
| `client.token` | 客户端认证令牌，用于验证服务端请求 |
| `client.os` | 客户端操作系统类型 |
| `client.listen` | 客户端监听地址和端口 |
| `client.allowed_servers` | 允许连接的服务端 IP 列表 |

## 环境要求

- [MoonBit](https://www.moonbitlang.cn/) 开发环境
