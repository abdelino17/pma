#!/bin/bash

LATEST_VERSION=$(curl -sS 'https://api.github.com/repos/phpmyadmin/phpmyadmin/releases/latest' | awk -F '"' '/tag_name/{print $4}')
DOWNLOAD_URL="https://api.github.com/repos/phpmyadmin/phpmyadmin/tarball/$LATEST_VERSION"

echo "Downloading phpMyAdmin $LATEST_VERSION"
wget $DOWNLOAD_URL -q --show-progress -O 'phpmyadmin.tar.gz'

mkdir phpmyadmin && tar xf phpmyadmin.tar.gz -C phpmyadmin --strip-components 1

rm phpmyadmin.tar.gz

CMD=/vagrant/scripts/site-types/laravel.sh
CMD_CERT=/vagrant/scripts/create-certificate.sh

# Create an SSL certificate
sudo bash $CMD_CERT phpmyadmin.test

sudo bash $CMD phpmyadmin.test $(pwd)/phpmyadmin 80 443 7.3

echo "Installing dependencies for phpMyAdmin"
cd phpmyadmin && composer update --no-dev

sudo service nginx reload
