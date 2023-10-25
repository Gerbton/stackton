ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm

WORKDIR /var/www

COPY shell /tmp/shell
RUN chmod +x /tmp/shell/*.sh
RUN /tmp/shell/install-common.sh

RUN echo "PHP_VERSION=${PHP_VERSION}"
