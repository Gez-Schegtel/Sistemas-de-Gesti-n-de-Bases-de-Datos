#!/bin/bash

#######################################################################
#
# Crear una MV con los parámetros de nombre, cantidad de procesadores,
# tamaño de disco y cantidad de memoria RAM deseados.
#
#######################################################################

# Nombre de la MV basado en el nombre de la máquina host:
nombremv="mv-$((RANDOM))"

# Cantidad de procesadores
cpu=2

# Tamaño de disco
disco=30G

# Cantidad de memoria RAM
memoria=3G

clear
date

echo "Creando máquina virtual '$nombremv' con:
- Procesadores: $cpu
- Tamaño de disco: $disco
- Memoria RAM: $memoria
..."
multipass launch -n $nombremv -c $cpu -d $disco -m $memoria 22.04 
multipass mount $HOME $nombremv:Home 
multipass set client.primary-name=$nombremv
multipass info $nombremv

echo "Máquina virtual creada."
# multipass exec -n $nombremv -- sudo apt update
# multipass exec -n $nombremv -- sudo apt -y upgrade
# multipass restart $nombremv

date

