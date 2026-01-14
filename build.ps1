# 1. 定义文件路径
$TARGET_FILE = "cmd/main/moon.pkg.json"
$BACKUP_FILE = "$TARGET_FILE.bak"

# 2. 执行备份
if (Test-Path $TARGET_FILE) {
    Copy-Item $TARGET_FILE $BACKUP_FILE -Force
}

try {
    # 3. 执行替换操作 (模拟 sed)
    # 读取内容，过滤掉包含 cc-link-flags 的行，然后写回
    (Get-Content $TARGET_FILE) | Where-Object { $_ -notmatch 'cc-link-flags' } | Set-Content $TARGET_FILE
    Write-Host "已临时移除 cc-link-flags" -ForegroundColor Cyan

    # --- 原有构建逻辑开始 ---
    moon update
    
    $OS_NAME = "Windows"
    moon build --release

    $ARCH_NAME = $env:PROCESSOR_ARCHITECTURE
    if ($ARCH_NAME -eq 'AMD64') { $ARCH_NAME = 'x86_64' }

    Copy-Item "_build/native/release/build/cmd/main/main.exe" "lock_sync_mbt-$OS_NAME-$ARCH_NAME.exe"
    Write-Host "构建完成: lock_sync_mbt-$OS_NAME-$ARCH_NAME.exe" -ForegroundColor Green
    # --- 原有构建逻辑结束 ---

}
catch {
    Write-Error "构建过程中出现错误: $_"
}
finally {
    # 4. 无论成功还是失败，只要有备份就还原
    if (Test-Path $BACKUP_FILE) {
        Move-Item $BACKUP_FILE $TARGET_FILE -Force
        Write-Host "文件 $TARGET_FILE 已还原" -ForegroundColor Gray
    }
}