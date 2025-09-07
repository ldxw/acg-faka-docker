#!/bin/bash

# 设置目标目录和备份目录
TARGET_DIR="/var/www/html"
BACKUP_DIR="/mnt/html_backup"

# 检查挂载目录是否为空
if [ ! "$(ls -A $TARGET_DIR)" ]; then
  echo "$TARGET_DIR is empty. Copying backup files..."
  # 如果挂载目录为空，则复制备份文件到目标目录
  cp -a $BACKUP_DIR/* $TARGET_DIR/
  echo "Backup files copied to $TARGET_DIR."
else
  echo "$TARGET_DIR is not empty. No action needed."
fi

# 设置权限
echo "Setting permissions for $TARGET_DIR"
chown -R www-data:www-data $TARGET_DIR
chmod -R 755 $TARGET_DIR

echo "Permissions and backup check completed."
