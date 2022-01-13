#! /bin/bash

# terminate on errors
set -e

# install plugins
if [ "$INSTALL_PLUGINS" = "true" ] ; then
    if [ ! "$(ls -A "/usr/src/wordpress/wp-content/plugins/vips-image-editor" 2>/dev/null)" ]; then
        echo 'Adding plugin: vips-image-editor'
        cd /usr/src/wordpress && wp plugin install --activate https://github.com/henrygd/vips-image-editor/releases/latest/download/vips-image-editor.zip
    fi

    if [ ! "$(ls -A "/usr/src/wordpress/wp-content/plugins/redis-cache" 2>/dev/null)" ]; then
        echo 'Adding plugin: redis-cache'
        cd /usr/src/wordpress && wp plugin install redis-cache
    fi

    if [ ! "$(ls -A "/usr/src/wordpress/wp-content/plugins/disable-media-pages" 2>/dev/null)" ]; then
        echo 'Adding plugin: disable-media-pages'
        cd /usr/src/wordpress && wp plugin install --activate disable-media-pages
    fi

    chown -R nobody: /usr/src/wordpress/wp-content/plugins
else
    echo "not installing plugins..."
fi

exec "$@"