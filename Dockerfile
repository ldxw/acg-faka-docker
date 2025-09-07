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

# 复制应用代码或远程下载并解压文件
# 如果选择下载远程压缩包
RUN if [ "$DOWNLOAD_SOURCE" = "true" ]; then \
        curl -L $SOURCE_URL -o source.zip && \
        unzip source.zip -d /var/www/html && \
        rm source.zip; \
    else \
        # 否则复制默认的应用代码
        COPY acg-faka /var/www/html; \
    fi

# 确保权限正确
RUN chown -R www-data:www-data /var/www/html

# 设置 Apache 配置
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html
