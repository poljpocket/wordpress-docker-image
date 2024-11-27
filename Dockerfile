ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-apache

# system updates
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install curl git zip zlib1g-dev libpng-dev libjpeg62-turbo-dev libwebp-dev libfreetype6-dev libcurl4-openssl-dev libonig-dev libzip-dev libicu-dev

# install necessary PHP extensions
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install curl
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache
RUN docker-php-ext-install intl

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install gd

# enable some Apache modules
RUN a2enmod rewrite headers

# copy over configuration files
COPY config/php.ini /usr/local/etc/php/
COPY config/default.conf /etc/apache2/sites-enabled/

# copy scripts
WORKDIR /scripts
COPY scripts .
RUN chmod +x *

# expose volume for our backup
VOLUME /backup

# make files editable from outside
ENV WEB_USER_ID=33
ENV WEB_GROUP_ID=33

WORKDIR /var/www/html

CMD ["/scripts/run.sh"]
