ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-apache

# system updates
RUN apt-get -y update
RUN apt-get -y upgrade

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# install php extensions
RUN install-php-extensions \
    zip \
    intl \
    xdebug \
    mysqli \
    opcache \
    gd

# enable some Apache modules
RUN a2enmod rewrite headers

# copy over configuration files
COPY config/php.ini /usr/local/etc/php/
COPY config/xdebug.ini /usr/local/etc/php/conf.d/
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
