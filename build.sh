#!/bin/bash

FILE="cmd/main/moon.pkg.json"
BACKUP="${FILE}.bak"

moon update
# 获取系统类型 (Linux, Darwin, etc.)
OS_NAME=$(uname -s)
# 如果是linux，去掉cmd/main/moon.pkg.json中的cc-link-flags那一行
# 使用单一等号保证兼容性
if [ "$OS_NAME" = "Linux" ]; then
    echo "当前为Linux操作系统, 临时移除cc-link-flags..."
    
    # 1. 创建备份
    cp "$FILE" "$BACKUP"
    # 2. 设置 trap（捕捉 EXIT 信号）
    # EXIT 是一个伪信号，无论脚本是执行完退出、报错退出、还是被 Ctrl+C 杀掉，都会触发
    trap 'mv "$BACKUP" "$FILE" && echo "已还原 $FILE"' EXIT

    # 兼容性较好的 sed 写法（备份后删除备份）
    # 或者如果你确定只在 Linux 运行，维持原样即可
    sed -i '/cc-link-flags/d' "$FILE"
    
    # 额外检查：确保删除后 JSON 依然合法（简单检查）
    # 提示：如果担心逗号问题，建议使用 jq 等工具进行处理
fi

moon build --release
# 获取架构类型 (x86_64, aarch64, arm64, i386)
ARCH_NAME=$(uname -m)
# 可执行文件路径
EXE_PATH="lock_sync_mbt-$OS_NAME-$ARCH_NAME.exe"
cp _build/native/release/build/cmd/main/main.exe "$EXE_PATH"
# 定义颜色变量
RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
NC='\033[0m' # No Color (重置)
echo -e "✅已生成可执行文件：$RED$EXE_PATH$NC"