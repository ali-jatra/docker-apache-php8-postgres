FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install dependencies + lib untuk gd
RUN apt-get update && apt-get install -y \
    git \
    libzip-dev \
    zip \
    unzip \
    npm \
    certbot \
    python3-certbot-apache \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_pgsql zip gd \
    && a2enmod rewrite \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

EXPOSE 80 443
