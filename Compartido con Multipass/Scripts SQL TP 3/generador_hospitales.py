import csv
import random

# Lista de hospitales predefinidos
hospitales = ['Hospital Favaloro', 'Sanatorio Francescoli', 'Hospital Italiano']

# Nombre del archivo CSV
archivo_hospital = 'hospital.csv'

# Cabeceras de las columnas en el archivo CSV
cabeceras_hospital = ['nombre']

# Cantidad de hospitales (en este caso 3)
cantidad_registros = len(hospitales)

# Crear y escribir los datos en el archivo CSV
with open(archivo_hospital, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=cabeceras_hospital, delimiter=';')
    writer.writeheader()  # Escribir las cabeceras

    # Generar solo tres hospitales y escribirlos en el archivo
    for hospital in hospitales:
        datos_hospital = {
            'nombre': hospital,
        }
        writer.writerow(datos_hospital)  # Escribir los datos en el archivo inmediatamente

print(f"{cantidad_registros} registros generados y exportados a {archivo_hospital}")
