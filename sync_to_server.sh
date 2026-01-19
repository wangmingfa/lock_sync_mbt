#!/usr/bin/env bash
set -e

# ===== 配置区 =====
REMOTE_USER="wmf"
REMOTE_HOST="wmf2.com"
REMOTE_DIR="/home/wmf/code/lock_sync_mbt"
SSH_PORT=8022
# ==================

echo "📦 Syncing git-tracked files via rsync..."

# 确保在 git 仓库中
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "❌ Not a git repository"
  exit 1
}

# rsync 需要一个文件列表，用 process substitution
rsync -avz \
  --delete \
  --files-from=<(git ls-files) \
  -e "ssh -p $SSH_PORT" \
  ./ \
  "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"

echo "✅ Sync completed!"
