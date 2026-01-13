# Windows Build Script for lock_sync_mbt

# 更新依赖
moon update

# Release 构建
moon build --release

# 获取系统类型
$OS_NAME = if ($env:OS -eq 'Windows_NT') { 'Windows' } else { 'Windows' }

# 获取架构类型 (x86_64, AMD64, arm64, etc.)
$ARCH_NAME = $env:PROCESSOR_ARCHITECTURE
if ($ARCH_NAME -eq 'AMD64') {
    $ARCH_NAME = 'x86_64'
}

# 复制并重命名输出文件
Copy-Item "_build/native/release/build/cmd/main/main.exe" "lock_sync_mbt-$OS_NAME-$ARCH_NAME.exe"
