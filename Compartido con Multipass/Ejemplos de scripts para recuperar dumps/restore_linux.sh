#!/bin/bash
# Script para restaurar archivos de MySQL en Unix/Linux
# Usuario: root
# Contraseña: password
# Base de datos: nombre_base_datos

MYSQL_USER="root"
MYSQL_PASS="password"
DB_NAME="nombre_base_datos"

# Restaurar cada archivo
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" <"desarrollo_tpf_escultores.sql"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" <"desarrollo_tpf_eventos.sql"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" <"desarrollo_tpf_imagenes.sql"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" <"desarrollo_tpf_obras.sql"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" <"desarrollo_tpf_participa.sql"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" <"desarrollo_tpf_usuarios.sql"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" <"desarrollo_tpf_vota.sql"

echo "Restauración completada."
