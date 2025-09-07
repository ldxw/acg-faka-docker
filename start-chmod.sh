#!/bin/bash

# 重新设置 /var/www/html 目录的权限
echo "Setting permissions for /var/www/html"
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# 结束脚本
echo "Permissions set successfully"
