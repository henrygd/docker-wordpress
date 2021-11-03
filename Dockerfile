FROM alpine:3.14

# Install packages
RUN apk --no-cache add \
  php7 \
  php7-fpm \
  php7-mysqli \
  php7-json \
  php7-openssl \
  php7-curl \
  php7-zlib \
  php7-xml \
  php7-phar \
  php7-intl \
  php7-dom \
  php7-xmlreader \
  php7-xmlwriter \
  php7-exif \
  php7-fileinfo \
  php7-sodium \
  php7-gd \
  php7-simplexml \
  php7-ctype \
  php7-mbstring \
  php7-zip \
  php7-opcache \
  php7-iconv \
  php7-pecl-imagick \
  php7-session \
  php7-tokenizer \
  php7-pecl-redis \
  nginx \
  supervisor \
  curl \
  bash \
  less \
  redis

# Create symlink so programs depending on `php` still function
RUN ln -s /usr/bin/php7 /usr/bin/php

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Redis options
RUN echo -e "maxmemory 128mb\nmaxmemory-policy allkeys-lru\nsave 600 100" >> /etc/redis.conf

# wp-content volume
#VOLUME /var/www/wp-content
# WORKDIR /var/www/wp-content
#RUN chown -R nobody.nobody /var/www

# WordPress
# ENV WORDPRESS_VERSION 5.7.2
# ENV WORDPRESS_SHA1 c97c037d942e974eb8524213a505268033aff6c8

# RUN mkdir -p /usr/src

# Upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN mkdir -p /usr/src/wordpress && chown -R nobody.nobody /usr/src/wordpress

WORKDIR /usr/src

# Add WP CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# WP config
# COPY wp-config.php /usr/src/wordpress
# RUN chown nobody.nobody /usr/src/wordpress/wp-config.php && chmod 640 /usr/src/wordpress/wp-config.php

# Append WP secrets
# COPY wp-secrets.php /usr/src/wordpress
# RUN chown nobody.nobody /usr/src/wordpress/wp-secrets.php && chmod 640 /usr/src/wordpress/wp-secrets.php

# Entrypoint to copy wp-content
# COPY entrypoint.sh /entrypoint.sh
# ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# healthcheck runs cron queue every 5 mintes - add disable_cron to wp-config
HEALTHCHECK --interval=300s CMD curl --silent --fail http://127.0.0.1/wp-cron.php?doing_wp_cron