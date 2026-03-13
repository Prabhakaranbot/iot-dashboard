FROM php:8.2-apache

WORKDIR /var/www/html

COPY . .

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev

# Install PHP extensions
RUN docker-php-ext-install zip gd

RUN touch database/database.sqlite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create Laravel required folders
RUN mkdir -p bootstrap/cache \
    && mkdir -p storage/framework/cache \
    && mkdir -p storage/framework/sessions \
    && mkdir -p storage/framework/views

# Permissions
RUN chmod -R 775 storage bootstrap/cache

# Install Laravel packages
RUN composer install --no-dev --optimize-autoloader

EXPOSE 80
