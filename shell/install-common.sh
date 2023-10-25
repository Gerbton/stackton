#!/bin/bash

UID=${UID:-1000}
USER=${USER:-www-data}
NODE_VERSION=${NODE_VERSION_ENV:-16}
NVM_DIR=${NVM_DIR:-/root/.nvm}
XDEBUG_VERSION=${XDEBUG_VERSION_ENV:-}

usermod -u $UID $USER

# Install common packages
apt-get update && apt-get install -y \
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

# Install PHP extensions
docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mbstring \
    mysqli \
    pdo_mysql \
    zip \
    opcache

if [ -z "$XDEBUG_VERSION" ]; then
  pecl install xdebug
else
  pecl install xdebug-$XDEBUG_VERSION
fi

pecl install imagick && docker-php-ext-enable xdebug mysqli gd imagick

# NVM
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && echo "source $NVM_DIR/nvm.sh" >> ~/.bashrc \
    && /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION" \
    && /bin/bash -c "source $NVM_DIR/nvm.sh && npm install -g yarn"

# Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
