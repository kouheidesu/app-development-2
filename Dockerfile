FROM php:8.2-fpm

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    git curl zip unzip libonig-dev libxml2-dev libpq-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Composer インストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# プロジェクトファイルのコピー
COPY . /var/www

WORKDIR /var/www

RUN composer install --no-dev --optimize-autoloader

# Laravel ストレージ権限設定
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
