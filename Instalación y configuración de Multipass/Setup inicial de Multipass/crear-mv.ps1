# Crear una MV con los parámetros de nombre, cantidad de procesadores,
# tamaño de disco y cantidad de memoria RAM deseados.
# Este script funciona para Windows.
# Nombre de la MV basado en el nombre de la máquina host:

$nombremv = "mv-$([System.Guid]::NewGuid().ToString().Substring(0, 8))"

# Cantidad de procesadores
$cpu = 2

# Tamaño de disco
$disco = "30G"

# Cantidad de memoria RAM
$memoria = "3G"

Clear-Host
Get-Date

Write-Host "Creando máquina virtual '$nombremv' con:`n- Procesadores: $cpu`n- Tamaño de disco: $disco`n- Memoria RAM: $memoria`n..."
multipass launch -n $nombremv -c $cpu -d $disco -m $memoria 22.04
multipass set local.privileged-mounts=true
multipass mount $env:USERPROFILE $nombremv:Home
multipass set client.primary-name=$nombremv
multipass info $nombremv

Write-Host "Máquina virtual creada. Preparando para su uso..."
multipass exec $nombremv -- sudo apt update
multipass exec $nombremv -- sudo apt -y upgrade
multipass restart $nombremv

Get-Date

multipass exec $nombremv -- sudo apt install -y avahi-daemon winbind language-pack-es manpages-es

multipass exec $nombremv -- sudo update-locale LANG=es_AR.UTF-8
