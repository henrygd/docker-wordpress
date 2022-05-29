# WordPress Docker Container

Lightweight WordPress container with Nginx & PHP-FPM 8.1 based on Alpine Linux.

Fork of [TrafeX/docker-wordpress](https://github.com/TrafeX/docker-wordpress). Changes:

- Designed to use existing wordpress files (installs fresh copy if no files found)
- Healthcheck runs wp-cron (disabled automatically in wp-config.php)
- Add php8-session
- Add php redis extension
- Add libvips support
- Allows cron commands to be specified
- Allows installation of user specified plugins at run time
- Optionally installs a few recommended plugins:
  - [VIPS Image Editor](https://github.com/henrygd/vips-image-editor) for better image processing (libvips is baked into the image)
  - [Redis Object Cache](https://wordpress.org/plugins/redis-cache/) (see [docker-compose.yml](docker-compose.yml) for connection params)
  - [Disable Media Pages](https://wordpress.org/plugins/disable-media-pages/) because images don't need their own page

## Usage

See [docker-compose.yml](docker-compose.yml) for an example. You should use an external database / redis container. Expose port 80 or use with something like cloudflare tunnel or [nginx-proxy-manager](https://github.com/jc21/nginx-proxy-manager) or [traefik](https://github.com/traefik/traefik).

If you don't mount existing wordpress files, it will install a fresh copy automatically. This may take a second so don't worry if you get a 502 error. After setup, restart the container to update wp-config and install plugins.

### WP-CLI

This image includes [wp-cli](https://wp-cli.org/) which can be used like this:

    docker exec <your container name> /usr/local/bin/wp --path=/usr/src/wordpress <your command>
