#!/bin/bash

usuario=root
password=password

mysql -u $usuario -p$password <shout.sql
mysql -u $usuario -p$password <prc_cobertura.sql
mysql -u $usuario -p$password <trg_solapamiento.sql
mysql -u $usuario -p$password <cargar_datos.sql
mysql -u $usuario -p$password <prc_edad.sql
mysql -u $usuario -p$password <fnc_edad.sql
mysql -u $usuario -p$password <evt_edad.sql


