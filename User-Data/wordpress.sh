# Ivan Humara Miranda
#!/bin/bash
# Actualizar el sistema e instalar Wordpress
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt install -y apache2 curl git unzip ghostscript libapache2-mod-php mysql-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xml

# Actualizar los repositorios
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update

# Instalar las dependencias de WordPress
sudo DEBIAN_FRONTEND=noninteractive apt install -y apache2 curl rsync git unzip ghostscript libapache2-mod-php mysql-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xml
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp-cli

# Limpiar los directorios de Wordpress y asignar los permisos correctos
sudo rm -rf /var/www/html/*
sudo chmod -R 755 /var/www/html
sudo chown -R www-data:www-data /var/www/html

# Reainiciar apache 
sudo a2enmod rewrite
sudo systemctl restart apache2

# Configurar la base de datos en RDS
sudo -u www-data wp-cli core download --path='/var/www/html'
sudo -u www-data wp-cli core config --dbname=wordpress_db --dbuser=admin --dbpass=Admin123 --dbhost='cms-database.c7aaohdxnqio.us-east-1.rds.amazonaws.com' --dbprefix=wp_ --path='/var/www/html'
sudo -u www-data wp-cli core install --url='http://w-ivanhumara.duckdns.org' --title='Soporte - Ivan' --admin_user='ivan' --admin_password='Admin1' --admin_email='ihumaram01@educantabria.es' --path='/var/www/html'
sudo -u www-data wp-cli plugin install supportcandy --activate --path='/var/www/html'
sudo -u www-data wp-cli plugin install user-registration --activate --path='/var/www/html'
sudo -u www-data wp-cli plugin install wps-hide-login --activate --path='/var/www/html'
sudo -u www-data wp-cli option update wps_hide_login_url admin-ivan --path='/var/www/html'
sudo -u www-data wp-cli cap add "subscriber" "read" --path='/var/www/html'
sudo -u www-data wp-cli cap add "subscriber" "create_ticket" --path='/var/www/html'
sudo -u www-data wp-cli cap add "subscriber" "view_own_ticket" --path='/var/www/html'
sudo -u www-data wp-cli option update default_role "subscriber" --path='/var/www/html'

# Asignar titulos de la pagina principal de Wordpress
sudo -u www-data wp-cli option update users_can_register 1 --path='/var/www/html'
sudo -u www-data wp-cli post create --post_title="Mi cuenta" --post_content="[user_registration_my_account]" --post_status="publish" --post_type="page" --path='/var/www/html' --porcelain
sudo -u www-data wp-cli post create --post_title="Registro" --post_content="[user_registration_form id="9"]" --post_status="publish" --post_type="page" --path='/var/www/html' --porcelain
sudo -u www-data wp-cli post create --post_title="Tickets" --post_content="[supportcandy]" --post_status="publish" --post_type="page" --path='/var/www/html' --porcelain

# Configurar el archivo de configuracion wp-config.php
sudo sed -i '1d' /var/www/html/wp-config.php

sudo sed -i '1i\
<?php if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])) {\
    $list = explode(",", $_SERVER["HTTP_X_FORWARDED_FOR"]);\
    $_SERVER["REMOTE_ADDR"] = $list[0];\
}\
$_SERVER["HTTP_HOST"] = "w-ivanhumara.duckdns.org";\
$_SERVER["REMOTE_ADDR"] = "w-ivanhumara.duckdns.org";\
$_SERVER["SERVER_ADDR"] = "w-ivanhumara.duckdns.org";\
' /var/www/html/wp-config.php

# Activar las configuraciones
sudo a2enmod ssl
sudo a2enmod headers
sudo a2ensite default-ssl.conf
sudo a2dissite 000-default.conf
sudo systemctl restart apache2
sudo systemctl status apache2