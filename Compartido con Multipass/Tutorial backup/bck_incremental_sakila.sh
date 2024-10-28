#!/bin/bash

# Ruta para almacenar los respaldos
backup_path=~/dumps/sakila

# Obtener el último archivo binlog y su posición
current_binlog=$(sudo ls /var/lib/mysql | grep -E "binlog\.[0-9]{6}" | sort | tail -n 1)

# Hacemos el respaldo incremental
sudo mysqlbinlog /var/lib/mysql/$current_binlog >$backup_path/bck_incremental_sakila_$(date +\%Y-\%m-\%d_\%H:%M).sql

# Enviar correo de notificación
echo "Respaldo incremental completado para sakila" | mail -s "Respaldo Incremental Sakila" velazcoschegtel@ca.frre.utn.edu.ar
