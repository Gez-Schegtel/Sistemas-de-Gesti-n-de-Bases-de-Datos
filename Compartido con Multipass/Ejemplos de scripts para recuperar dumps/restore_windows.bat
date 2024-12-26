@echo off
REM Script para restaurar archivos de MySQL en Windows
REM Usuario: root
REM Contraseña: password
REM Base de datos: nombre_base_datos

set MYSQL_USER=root
set MYSQL_PASS=password
set DB_NAME=nombre_base_datos

REM Restaurar cada archivo
mysql -u %MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "desarrollo_tpf_escultores.sql"
mysql -u %MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "desarrollo_tpf_eventos.sql"
mysql -u %MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "desarrollo_tpf_imagenes.sql"
mysql -u %MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "desarrollo_tpf_obras.sql"
mysql -u %MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "desarrollo_tpf_participa.sql"
mysql -u %MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "desarrollo_tpf_usuarios.sql"
mysql -u %MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "desarrollo_tpf_vota.sql"

echo Restauración completada.
pause

