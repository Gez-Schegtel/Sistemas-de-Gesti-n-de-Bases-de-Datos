#!/bin/bash

usuario=root
password=password

mysqldump -u $usuario -p$password --no-data --routines --triggers --source-data shoutdb > respaldo_shoutdb_$(date +\%Y-\%m-\%d).sql
mysql -u $usuario -p$password shoutdb < respaldo_shoutdb_$(date +\%Y-\%m-\%d).sql