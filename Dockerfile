FROM php:8.2-apache

WORKDIR /var/www/html

COPY . .

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    && docker-php-ext-install zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create Laravel folders
RUN mkdir -p bootstrap/cache \
    && mkdir -p storage/framework/cache \
    && mkdir -p storage/framework/sessions \
    && mkdir -p storage/framework/views

RUN chmod -R 775 storage bootstrap/cache

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 80
