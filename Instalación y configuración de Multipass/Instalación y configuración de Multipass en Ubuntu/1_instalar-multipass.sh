#!/bin/bash

#######################################################################
#
# Instalar Multipass y configurar driver predeterminado
#
#######################################################################

clear
echo 'Iniciando nstalación de Multipass...'
date
sudo snap install multipass
multipass set client.gui.autostart=false

echo 'Instalando y configurando libvirt...'
sudo apt install -y libvirt-daemon-system virt-manager
sudo snap connect multipass:libvirt
# multipass stop --all
# sudo snap restart multipass.multipassd
multipass set local.driver=libvirt

echo 'Terminando...'
date
