#!/bin/bash


# Developer: Kay Probst
# Version: 1.0
# Description: Use this script to inciate a new wordpress instace for the given domain ($1)
# Usage: 
#       ./newinstance <domainname> 

#===================================================================#

# Test if the user puts a Argument
if [[ $# -eq 0 ]] ; then
    clear
    echo 'You have to define in a Hostname!'
    echo 'Usage: ./newinstance <domainname> <mysql_pw> '
    exit 0
fi

#===================================================================#

# Create Apache vHost and enable it

vhostconfig="000-$1.site.conf"

cp /etc/apache2/sites-available/000-wordpress.conf /etc/apache2/sites-available/$vhostconfig
sed -i -e "s/DOMAINNAME/$1.site/g" /etc/apache2/sites-available/$vhostconfig
sed -i -e "s/DIRECTORY/$1.site/g" /etc/apache2/sites-available/$vhostconfig
sed -i -e "s/MAIL/$1.site/g" /etc/apache2/sites-available/$vhostconfig
mkdir -p /var/www/html/$1.site
cd /etc/apache2/sites-available/
a2ensite $vhostconfig
cd ~/
/etc/init.d/apache2 reload
chown -R 33.33 /var/www/html/$1/

#===================================================================#

# Create mysql database

echo "create database $1;" | mysql -u root -p $2

#===================================================================#

# Issue SSL Certificate with letsencrypt

/root/git/letsencrypt/certbot-auto --apache -d $1.site --email ssl@$1.site

#===================================================================#

# Install wordpress

/root/git/letsencrypt/certbot-auto --apache -d $1.site --email ssl@$1.site

wget -q https://de.wordpress.org/latest-de_DE.zip -O /var/www/html/$1/latest.zip
unzip /var/www/html/$1/latest.zip
cp /var/www/html/$1/wp-config-sample.php /var/www/html/$1/wp-config.php


sed -i -e "s/wordpress/$1/g" /var/www/html/$1/wp-config.php
sed -i -e "s/wordpressuser/root/g" /var/www/html/$1/wp-config.php
sed -i -e "s/password/$2/g" /var/www/html/$1/wp-config.php


#===================================================================#

# Ending Script
clear
echo "#=========================================================================#"
echo "Installation finished! Please now login into your brand new wordpress site!"
echo "Admin Area: https://$1.site/setup"
echo "#=========================================================================#"









