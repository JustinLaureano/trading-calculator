FROM rockylinux:8

# Init Setup
RUN dnf update -y && dnf upgrade -y

# Add web user
RUN adduser webuser && gpasswd -a webuser wheel

# Install general utilities
RUN dnf install -y curl nano wget git net-tools dnf-utils

# Install apache
RUN dnf install -y httpd httpd-tools

# Set custom apache config
COPY conf.d/00-default.conf /etc/httpd/conf.d/00-default.conf

# Add user to apache group
RUN usermod -a -G apache webuser

# Install php
RUN dnf install -y epel-release \
        http://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf module reset -y php && \
    dnf module enable -y php:remi-8.0 && \
    dnf install -y php php-curl php-fpm php-posix

# Install Composer
COPY --from=composer:2.2.4 /usr/bin/composer /usr/local/bin/composer

# Install Node.js
RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash -
RUN dnf install -y make nodejs
# RUN npm config set registry ${NPM_REGISTRY}
RUN npm install -g @vue/cli

# Create custom script directory
RUN mkdir /usr/local/scripts

# Copy custom scripts
COPY scripts/ /usr/local/scripts/

# Make the custom scripts executable
RUN chmod u+x /usr/local/scripts/*

# Make default work directory the web server root
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Set web directory permissions
RUN chown -R webuser:apache /var/www/html

# Expose apache port
EXPOSE 80

# Run startup script on container start
CMD ["/usr/local/scripts/startup.sh"]
