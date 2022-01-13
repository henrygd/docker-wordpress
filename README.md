# WordPress Docker Container

Fork of [TrafeX/docker-wordpress](https://github.com/TrafeX/docker-wordpress). Changes:

- Uses existing wordpress files
- Healthcheck runs wp-cron (disable in wp-config.php)
- Add php8-session
- Add php redis extension
- Add libvips support
- Optionally adds a few plugins:
  - [VIPS Image Editor](https://github.com/henrygd/vips-image-editor) for better image processing (libvips is baked into the image)
  - [Redis Object Cache](https://wordpress.org/plugins/redis-cache/) (add [connection parameters](https://github.com/rhubarbgroup/redis-cache/wiki/Connection-Parameters) to wp-config.php)
  - [Disable Media Pages](https://wordpress.org/plugins/disable-media-pages/) because images don't need their own page

## Usage

See [docker-compose.yml](docker-compose.yml) for an example. You should bind mount existing wordpress files on the host (migrated site or fresh install) and use an external database / redis server. Expose port 80 or use with something like cloudflare tunnel or [nginx-proxy-manager](https://github.com/jc21/nginx-proxy-manager) or [traefik](https://github.com/traefik/traefik).

## Info

Lightweight WordPress container with Nginx 1.20 & PHP-FPM 8.0 based on Alpine Linux.

- Used in production for my own sites, making it stable, tested and up-to-date
- Optimized for 100 concurrent users
- Optimized to only use resources when there's traffic (by using PHP-FPM's ondemand PM)
- Built on the lightweight Alpine Linux distribution
- Small Docker image size
- Uses PHP 8.0 for better performance, lower cpu usage & memory footprint
- Can safely be updated without losing data
- Fully configurable because wp-config.php uses the environment variables you can pass as an argument to the container

### WP-CLI

This image includes [wp-cli](https://wp-cli.org/) which can be used like this:

    docker exec <your container name> /usr/local/bin/wp --path=/usr/src/wordpress <your command>

## Inspired by

- https://hub.docker.com/_/wordpress/
- https://codeable.io/wordpress-developers-intro-to-docker-part-two/
- https://github.com/TrafeX/docker-php-nginx/
- https://github.com/etopian/alpine-php-wordpress
