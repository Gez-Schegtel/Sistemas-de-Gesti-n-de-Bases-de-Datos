#!/bin/bash

# Ruta para almacenar los respaldos
backup_path=~/dumps/bd2024

# Credenciales de la base de datos
user="DBA"
password="12345"

# Respaldo "full"
mysqldump -u $user -p$password --source-data=2 bd2024 >$backup_path/bck_full_bd2024_$(date +\%Y-\%m-\%d_\%H:%M).sql
