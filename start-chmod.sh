#!/bin/bash

# 设置目标目录
TARGET_DIR="/var/www/html"

# 获取当前所有者和组
CURRENT_OWNER=$(stat -c %U:%G $TARGET_DIR)

# 检查是否是 www-data:www-data
if [ "$CURRENT_OWNER" != "www-data:www-data" ]; then
  echo "Permissions are not set correctly. Fixing permissions..."
  # 重新设置所有权和权限
  chown -R www-data:www-data $TARGET_DIR
  chmod -R 755 $TARGET_DIR
  echo "Permissions fixed."
else
  echo "Permissions are correct."
fi

# 结束脚本
echo "Finished setting permissions."
