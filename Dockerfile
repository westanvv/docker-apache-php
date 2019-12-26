FROM php:7.3-apache

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
        git \
        imagemagick \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-turbo-progs \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libssl-dev \
        libzip-dev \
        msmtp \
        msmtp-mta \
        ca-certificates \
        unzip \
        wget \
        zlib1g-dev \
        libmemcached-dev \
        mc \
        openssh-server \
        gnupg \
    && pecl install \
        mcrypt-1.0.2 \
        xdebug \
    && docker-php-ext-install \
        bcmath \
        curl \
        exif \
        intl \
        mbstring \
        pdo_mysql \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        simplexml \
        soap \
        xml \
        xsl \
        zip \
        tokenizer \
        json \
        iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-enable \
        xdebug \
        mcrypt

#####################################
# Human Language and Character Encoding Support:
# Install intl and requirements
#####################################

RUN apt-get install -y \
        zlib1g-dev \
        libicu-dev g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

#####################################
# GHOSTSCRIPT:
#####################################

# Install the ghostscript extension
# for PDF editing

RUN apt-get install -y \
        poppler-utils \
        ghostscript

#####################################
# LDAP:
#####################################
RUN apt-get install -y \
        libldap2-dev \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap

#####################################
# Image optimizers:
#####################################
USER root
RUN apt-get install -y --force-yes \
        jpegoptim \
        optipng \
        pngquant \
        gifsicle

######################################
## NodeJS
######################################
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

######################################
## Grunt
######################################
RUN npm i -g grunt-cli gulp-cli

#####################################
# Composer
#####################################
RUN curl -s https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

#####################################
# FIX Apache
#####################################
RUN rm -R /etc/apache2/sites-enabled/

#####################################
# SSH
#####################################
RUN rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -A
RUN echo 'root:root' | chpasswd
RUN mkdir /run/sshd
RUN chmod 0755 /run/sshd

#####################################
# Mail configration
#####################################
RUN touch /etc/msmtprc
RUN chmod 0600 /etc/msmtprc

#####################################
# Coping configration
#####################################
COPY ./configs/custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY ./configs/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./configs/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./configs/sshd_config /etc/ssh/sshd_config
COPY ./configs/apache2.conf /etc/apache2/apache2.conf
COPY ./configs/virtualhost.conf /etc/apache2/sites-enabled/virtualhost.conf
COPY ./configs/ssl/server.crt /etc/apache2/ssl/server.crt
COPY ./configs/ssl/server.key /etc/apache2/ssl/server.key
COPY ./configs/msmtprc /etc/msmtprc
RUN rm -rf ./configs

#####################################
# Last touch
#####################################
RUN mkdir /tmp/logs
RUN mkdir /tmp/php
RUN chown -R www-data:www-data ./
RUN chmod -R 777 /var/www
RUN chmod -R 777 /tmp

EXPOSE 22

CMD apache2-foreground | /usr/sbin/sshd -D
