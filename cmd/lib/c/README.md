
# `macos_lock.c`编译&运行

为方便`.gitignore`忽略可执行文件，所以都加了`.o`后缀

```bash
# 编译
clang -c macos_lock.c -o macos_lock.o && ar rcs liblib.a macos_lock.o

# 执行测试
clang macos_lock_test.c macos_lock.c -framework CoreFoundation -o macos_lock_test.o && ./macos_lock_test.o && rm ./macos_lock_test.o
```