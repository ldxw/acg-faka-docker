# 基于官方 PHP 8.1 镜像构建
FROM php:8.1-apache

# 安装所需的依赖
RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libssl-dev \
    openssl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip sockets

# 获取源代码目录的环境变量，默认为 acg-faka
ARG SOURCE_DIR=acg-faka

# 显式创建临时目录
RUN mkdir -p /mnt/acg-faka-bak

# 复制本地构建的源码到html目录
COPY ${SOURCE_DIR}/ /var/www/html

# 复制文件到目标目录（备份目录）
RUN cp -a /var/www/html/. /mnt/acg-faka-bak

# 复制 start-chmod.sh 脚本到容器中
COPY start-chmod.sh /usr/local/bin/start-chmod.sh

# 赋予脚本执行权限
RUN chmod +x /usr/local/bin/start-chmod.sh

# 确保权限正确
RUN chown -R www-data:www-data /var/www/html
RUN chown -R www-data:www-data /mnt/acg-faka-bak

# 设置 Apache 配置
RUN a2enmod rewrite

# 使用 ENTRYPOINT 来执行脚本并启动 Apache
ENTRYPOINT ["sh", "-c", "/usr/local/bin/start-chmod.sh && apache2-foreground"]
