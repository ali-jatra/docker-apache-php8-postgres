FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install dependencies + lib untuk gd + certbot + tools lain
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libzip-dev \
    certbot \
    python3-certbot-apache \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    gnupg2 \
    ca-certificates \
    wget \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_pgsql zip gd \
    && a2enmod rewrite

# Install Node.js v22.3.1
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && node -v \
    && npm -v

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Set PHP memory limit
# Tingkatkan batasan resource PHP
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/memory-limit.ini \
 && echo "max_execution_time = 300" > /usr/local/etc/php/conf.d/execution-time.ini \
 && echo "max_input_time = 300" > /usr/local/etc/php/conf.d/input-time.ini \
 && echo "upload_max_filesize = 100M" > /usr/local/etc/php/conf.d/upload-size.ini \
 && echo "post_max_size = 100M" > /usr/local/etc/php/conf.d/post-size.ini \
 && echo "Timeout 300" >> /etc/apache2/apache2.conf

 # COPY custom php.ini dari host ke container
COPY custom-php.ini /usr/local/etc/php/conf.d/

EXPOSE 80 443

