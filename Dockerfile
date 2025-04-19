FROM php:8.2-fpm

# Laravel に必要な拡張をインストール
RUN apt-get update && apt-get install -y \
    nginx \
    git unzip curl zip libzip-dev libpq-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
COPY . /var/www

# Laravel セットアップ
RUN composer install --no-dev --optimize-autoloader \
    && chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# nginx.conf を配置
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# 起動時に nginx と php-fpm 両方を実行
CMD service php8.2-fpm start && nginx -g "daemon off;"
