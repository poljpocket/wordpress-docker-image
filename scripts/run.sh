#!/bin/bash

# mod the www-data user to reflect outside user IDs
usermod -u $WEB_USER_ID www-data
groupmod -g $WEB_GROUP_ID www-data

# see if we need to copy over the backup from the mapped volume
if [[ ! -f /backup/copied ]]; then
  cp /backup/* /var/www/html/
  touch /backup/copied
  chown www-data:www-data /backup/copied
fi

# reflect changes in files too
chown -R www-data:www-data .

exec apache2-foreground
