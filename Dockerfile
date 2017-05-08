FROM webdevops/php-apache-dev

WORKDIR /home

COPY docker-config/php.ini /tmp/custom_php.ini
RUN cat /tmp/custom_php.ini > /opt/docker/etc/php/php.ini
