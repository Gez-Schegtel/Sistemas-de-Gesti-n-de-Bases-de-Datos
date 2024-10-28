#!/bin/bash

# Ruta para almacenar los respaldos
backup_path=~/dumps/sakila

# Credenciales de la base de datos
user="DBA"
password="12345"

# Crear el directorio si no existe
mkdir -p $backup_path

# Respaldo completo comprimido
mysqldump -u $user -p$password --source-data=2 sakila | gzip >$backup_path/bck_full_sakila_$(date +\%Y-\%m-\%d_\%H:%M).sql.gz
