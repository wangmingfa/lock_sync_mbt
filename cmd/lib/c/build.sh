#!/bin/bash

# 处理软链接，获取真实物理路径
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # 如果是软链接，则继续寻找
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

echo "脚本真实的物理目录是: $SCRIPT_DIR"

OUTPUT_DIR="$SCRIPT_DIR/../../../_build/native/release/build/cmd/lib"

mkdir -p "$OUTPUT_DIR"

# macos编译
macos_lock_file="$SCRIPT_DIR/macos_lock.c"
clang -c "$macos_lock_file" -o macos_lock.o && ar rcs liblib.a macos_lock.o && mv liblib.a macos_lock.o "$OUTPUT_DIR"