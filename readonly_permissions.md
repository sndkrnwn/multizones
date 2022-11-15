find /var/www/html -type f -iname "*" -print0 | xargs -I {} -0 chmod 0444 {}
find /var/www/html -type d -iname "*" -print0 | xargs -I {} -0 chmod 0544 {}