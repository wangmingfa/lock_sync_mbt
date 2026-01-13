#!/bin/bash
moon update
moon build --release
# 获取系统类型 (Linux, Darwin, etc.)
OS_NAME=$(uname -s)
# 获取架构类型 (x86_64, aarch64, arm64, i386)
ARCH_NAME=$(uname -m)
cp _build/native/release/build/cmd/main/main.exe "lock_sync_mbt-$OS_NAME-$ARCH_NAME.exe"