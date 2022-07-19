#!/bin/bash

# Create the temp directory for the php-fpm module
mkdir /run/php-fpm

# start the php-fpm module
/usr/sbin/php-fpm

# start apache
/usr/sbin/httpd -D "FOREGROUND"