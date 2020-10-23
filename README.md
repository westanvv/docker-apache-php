This is Apache + PHP 7.3 Docker Image

## Installed packages:

- nodejs
- yarn
- grunt
- gulp
- composer
- git
- wget
- imagemagick
- msmtp
- unzip
- memcached
- mc
- openssh-server
- gnupg
- poppler-utils
- ghostscript
- jpegoptim
- optipng
- pngquant
- gifsicle
- curl

## Installed PHP libraries:

- mcrypt
- xdebug
- bcmath
- curl
- exif
- intl
- mbstring
- pdo_mysql
- mysqli
- opcache
- pcntl
- pdo_mysql
- simplexml
- soap
- xml
- xsl
- zip
- tokenizer
- json
- iconv
- ldap

## XDebug

- XDebug is turned **off** by default
- **_Only_** for Windows - open port `9000` in firewall (or public network for Idea)
- **_Only_** for Linux - you need to alias your local IP: `sudo ifconfig en0 10.254.254.254 netmask 255.255.255.0 up`
- **_Only_** for MAC OS - you need to alias your local IP: `sudo ifconfig en0 alias 10.254.254.254 255.255.255.0`
- Create `PHP Remote Debug` and set **Idea key** to `docker`

<img src="./images/adding_remote_debug.png" width="400" />

- Create **Server** and set directory mappings

<img src="./images/creating_server.png" width="400" />

- **_Note_** that the last Intellij Idea creates a connection on the first run. You just to accept a connection

## SSH connection

If it is necessary, there is a possibility to create ssh connection inside docker container:

<img src="./images/ssh_connection.png" width="400" />

    host: 127.0.0.1
    login: root
    pass: root

## Build commands

    docker build -t php7-apache .
    docker tag php7-apache:latest vnemchenko/php7-apache:latest
    docker push vnemchenko/php7-apache:latest

## Full docker-compose configuration

      application:
        image: vnemchenko/php7-apache
        volumes:
          - ${PATH_TO_SOURCE_DIRECTORY}:/var/www
          - ${PATH_TO_DOCKER_CONFIGS}/custom.ini:/usr/local/etc/php/conf.d/custom.ini
          - ${PATH_TO_DOCKER_CONFIGS}/xdebug.ini:/usr/local/etc/php/conf.d/xdebug.ini
          - ${PATH_TO_DOCKER_CONFIGS}/opcache.ini:/usr/local/etc/php/conf.d/opcache.ini
          - ${PATH_TO_DOCKER_CONFIGS}/apache2.conf:/etc/apache2/apache2.conf
          - ${PATH_TO_DOCKER_CONFIGS}/virtualhost.conf:/etc/apache2/sites-enabled/virtualhost.conf
          - ${PATH_TO_DOCKER_CONFIGS}/msmtprc:/etc/msmtprc
          - ${PATH_TO_TMP_DIRECTORIES}:/tmp/php
          - ${PATH_TO_LOG_DIRECTORIES}:/tmp/logs
        ports:
          - ${YOUR_HTTP_PORT}:80
          - ${YOUR_HTTPS_PORT}:443
          - ${YOUR_SSH_PORT}:22
        environment:
          - PHP_IDE_CONFIG=${YOUR_PHP_IDE_CONFIG}
          - XDEBUG_CONFIG=${YOUR_XDEBUG_CONFIG}
          
## Minimal docker-compose configuration

      application:
        image: vnemchenko/php7-apache
        volumes:
          - ${PATH_TO_SOURCE_DIRECTORY}:/var/www
        ports:
          - ${YOUR_HTTP_PORT}:80
