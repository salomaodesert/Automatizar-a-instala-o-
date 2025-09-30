#!/bin/bash



# === CONFIGURAÇÕES ===

GLPI_VERSION="10.0.12"

DB_NAME="glpidb"

DB_USER="glpiuser"

DB_PASS="glpipass"

DB_ROOT_PASS="rootpass" # Troque conforme necessário



echo "==== Atualizando sistema ===="

apt update && apt upgrade -y



echo "==== Instalando Apache, MariaDB e PHP ===="

apt install -y apache2 mariadb-server mariadb-client

apt install -y php php-mysql php-xml php-cli php-curl php-gd php-mbstring php-intl php-ldap php-zip php-bz2 php-imap



echo "==== Habilitando Apache e MariaDB ===="

systemctl enable apache2

systemctl enable mariadb

systemctl start apache2

systemctl start mariadb



echo "==== Configurando banco de dados ===="

mysql -u root <<EOF

UPDATE mysql.user SET Password = PASSWORD('${DB_ROOT_PASS}') WHERE User = 'root';

FLUSH PRIVILEGES;

CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';

GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';

FLUSH PRIVILEGES;

EOF



echo "==== Baixando o GLPI ${GLPI_VERSION} ===="

cd /tmp

wget https://lnkd.in/dZ9waV3V



echo "==== Extraindo GLPI ===="

tar -xvzf glpi-${GLPI_VERSION}.tgz

mv glpi /var/www/html/



echo "==== Ajustando permissões ===="

chown -R www-data:www-data /var/www/html/glpi

chmod -R 755 /var/www/html/glpi



echo "==== Ativando módulo rewrite no Apache ===="

a2enmod rewrite

systemctl restart apache2



echo "==== Instalação finalizada ===="

echo "Acesse: http://SEU_IP/glpi para finalizar a instalação via interface web."

echo "Banco de Dados: ${DB_NAME}"

echo "Usuário do BD: ${DB_USER}"

echo "Senha do BD: ${DB_PASS}"

