#!/bin/bash
moon update
moon build --release
# 获取系统类型 (Linux, Darwin, etc.)
OS_NAME=$(uname -s)
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