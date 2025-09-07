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
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip sockets

# 获取远程压缩包 URL（可以手动填写）
ARG DOWNLOAD_SOURCE=false
ARG SOURCE_URL=https://wiki.mcy.im/channel/mcy-latest.zip  # 默认远程压缩包 URL

# 显式创建临时目录
RUN mkdir -p /mnt/acg-faka

# 复制本地构建的源码到临时目录
COPY acg-faka/ /mnt/acg-faka/

# 判断是否下载远程压缩包
RUN if [ "$DOWNLOAD_SOURCE" = "true" ]; then \
        curl -L $SOURCE_URL -o source.zip && \
        unzip source.zip -d /mnt/source && \
        rm source.zip; \
    fi

# 如果没有下载远程源码，则复制本地的应用代码
RUN if [ "$DOWNLOAD_SOURCE" = "false" ]; then \
        cp -a /mnt/acg-faka/. /var/www/html/; \
    else \
        cp -a /mnt/source/. /var/www/html/; \
        # 如果下载了远程源码，删除本地复制的文件以节省体积
        rm -rf /mnt/acg-faka; \
    fi

# 显式创建备份目录
RUN mkdir -p /mnt/html_backup

# 备份 /var/www/html 到 /mnt/html_backup
RUN cp -a /var/www/html/. /mnt/html_backup/

# 复制 .htaccess 文件到容器内的正确位置（如果需要）
# COPY .htaccess /var/www/html/.htaccess

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
