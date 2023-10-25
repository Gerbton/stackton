ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-fpm

ARG UID=1000
ARG USER=www-data
ARG NODE_VERSION=16
ARG NVM_DIR=/root/.nvm
ARG XDEBUG_VERSION

WORKDIR /var/www

RUN usermod -u ${UID} $USER

# Install common packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    vim \
    curl \
    libedit-dev \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libpq-dev \
    libonig-dev \
    libmagickwand-dev \
    git \
    zip \
    unzip \
    python3

# NVM
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && echo "source $NVM_DIR/nvm.sh" >> ~/.bashrc \
    && /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION" \
    && /bin/bash -c "source $NVM_DIR/nvm.sh && npm install -g yarn"

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mbstring \
    mysqli \
    pdo_mysql \
    zip \
    opcache

# Install Xdebug
COPY shell/install-xdebug.sh /tmp/shell/install-xdebug.sh
RUN chmod +x /tmp/shell/install-xdebug.sh \
    && /tmp/shell/install-xdebug.sh

RUN pecl install imagick && docker-php-ext-enable xdebug mysqli gd imagick
