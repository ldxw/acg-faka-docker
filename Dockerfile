# 基于官方 PHP 8.1 镜像构建
FROM php:8.1-apache

# 环境变量，用于判断是否下载远程压缩包
ARG DOWNLOAD_SOURCE=false
ARG SOURCE_URL=https://wiki.mcy.im/channel/mcy-latest.zip  # 默认远程压缩包 URL

RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libssl-dev \
    openssl \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip sockets

# 判断是否下载远程压缩包
RUN if [ "$DOWNLOAD_SOURCE" = "true" ]; then \
        curl -L $SOURCE_URL -o source.zip && \
        unzip source.zip -d /var/www/html && \
        rm source.zip; \
    fi

# 如果没有下载远程源码，则复制本地的应用代码
RUN if [ "$DOWNLOAD_SOURCE" = "false" ]; then \
        cp -a /acg-faka/. /var/www/html/; \
    fi

# 显式创建备份目录
RUN mkdir -p /mnt/html_backup

# 备份 /var/www/html 到 /mnt/html_backup
RUN cp -a /var/www/html/. /mnt/html_backup/

# 复制 start-chmod.sh 脚本到容器中
COPY start-chmod.sh /usr/local/bin/start-chmod.sh

# 赋予脚本执行权限
RUN chmod +x /usr/local/bin/start-chmod.sh

# 确保权限正确
RUN chown -R www-data:www-data /var/www/html
RUN chown -R www-data:www-data /mnt/html_backup

# 设置 Apache 配置
RUN a2enmod rewrite

# 使用 ENTRYPOINT 来执行脚本并启动 Apache
ENTRYPOINT ["sh", "-c", "/usr/local/bin/start-chmod.sh && apache2-foreground"]
