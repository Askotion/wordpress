#!/bin/bash


# Developer: Kay Probst
# Version: 1.0
# Description: Use this script to inciate a new wordpress instace for the given domain ($1)
# Usage: 
#       ./newinstance <domainname> 

#===================================================================#

function delay()
{
    sleep 0.2;
}

CURRENT_PROGRESS=0
function progress()
{
    PARAM_PROGRESS=$1;
    PARAM_STATUS=$2;

    if [ $CURRENT_PROGRESS -le 0 -a $PARAM_PROGRESS -ge 0 ]  ; then echo -ne "[..........................] (0%)  $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 5 -a $PARAM_PROGRESS -ge 5 ]  ; then echo -ne "[#.........................] (5%)  $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 10 -a $PARAM_PROGRESS -ge 10 ]; then echo -ne "[##........................] (10%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 15 -a $PARAM_PROGRESS -ge 15 ]; then echo -ne "[###.......................] (15%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 20 -a $PARAM_PROGRESS -ge 20 ]; then echo -ne "[####......................] (20%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 25 -a $PARAM_PROGRESS -ge 25 ]; then echo -ne "[#####.....................] (25%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 30 -a $PARAM_PROGRESS -ge 30 ]; then echo -ne "[######....................] (30%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 35 -a $PARAM_PROGRESS -ge 35 ]; then echo -ne "[#######...................] (35%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 40 -a $PARAM_PROGRESS -ge 40 ]; then echo -ne "[########..................] (40%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 45 -a $PARAM_PROGRESS -ge 45 ]; then echo -ne "[#########.................] (45%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 50 -a $PARAM_PROGRESS -ge 50 ]; then echo -ne "[##########................] (50%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 55 -a $PARAM_PROGRESS -ge 55 ]; then echo -ne "[###########...............] (55%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 60 -a $PARAM_PROGRESS -ge 60 ]; then echo -ne "[############..............] (60%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 65 -a $PARAM_PROGRESS -ge 65 ]; then echo -ne "[#############.............] (65%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 70 -a $PARAM_PROGRESS -ge 70 ]; then echo -ne "[###############...........] (70%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 75 -a $PARAM_PROGRESS -ge 75 ]; then echo -ne "[#################.........] (75%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 80 -a $PARAM_PROGRESS -ge 80 ]; then echo -ne "[####################......] (80%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 85 -a $PARAM_PROGRESS -ge 85 ]; then echo -ne "[#######################...] (90%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 90 -a $PARAM_PROGRESS -ge 90 ]; then echo -ne "[##########################] (100%) $PARAM_PHASE \r" ; delay; fi;
    if [ $CURRENT_PROGRESS -le 100 -a $PARAM_PROGRESS -ge 100 ];then echo -ne 'Done!                                            \n' ; delay; fi;

    CURRENT_PROGRESS=$PARAM_PROGRESS;

}



# Test if the user puts a Argument and start message
if [[ $# -eq 0 ]] ; then
    clear
    echo 'You have to define in a Hostname!'
    echo 'Usage: ./newinstance <domainname> <mysql_pw> '
    exit 0
fi


echo "Setup started! Please wait a few seconds / minutes until finish!"
sleep 2
clear
progress 10 "Initialize"
sleep 1
#===================================================================#

# Create Apache vHost and enable it

vhostconfig="000-$1.site.conf"

clear
progress 20 " Create Apache vHost and enable it.."
sleep 1
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

clear
progress 30 " Create Apache vHost and enable it.. Done!"
sleep 1
#===================================================================#

# Create mysql database

clear
progress 40 " Create mysql database.."
sleep 1
echo "create database $1;" | mysql -u root -p $2
clear
progress 50 " Create mysql database... Done!"
sleep 1

#===================================================================#

# Issue SSL Certificate with letsencrypt

clear
progress 60 " Issue SSL Certificate with letsencrypt.."
sleep 1
/root/git/letsencrypt/certbot-auto --apache -d $1.site --email ssl@$1.site
clear
progress 70 " Issue SSL Certificate with letsencrypt... Done!"
sleep 1

#===================================================================#

# Install wordpress

clear
progress 80 "  Install and copying wordpress.. "
sleep 1
/root/git/letsencrypt/certbot-auto --apache -d $1.site --email ssl@$1.site

wget -q https://de.wordpress.org/latest-de_DE.zip -O /var/www/html/$1/latest.zip
unzip /var/www/html/$1/latest.zip
cp /var/www/html/$1/wp-config-sample.php /var/www/html/$1/wp-config.php


sed -i -e "s/wordpress/$1/g" /var/www/html/$1/wp-config.php
sed -i -e "s/wordpressuser/root/g" /var/www/html/$1/wp-config.php
sed -i -e "s/password/$2/g" /var/www/html/$1/wp-config.php
clear
progress 90 " Install and copying wordpress... Done!"
sleep 1

#===================================================================#

# Ending Script

clear
progress 100 " Finished!"
sleep 1
clear
echo "#=========================================================================#"
echo "Installation finished! Please now login into your brand new wordpress site!"
echo "Admin Area: https://$1.site/"
echo "#=========================================================================#"









