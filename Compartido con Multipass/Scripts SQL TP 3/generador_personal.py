import csv
from faker import Faker
import random
from faker.exceptions import UniquenessException
import datetime

# Crear una instancia de Faker
fake = Faker('es_ES')  # Usar el local de España para datos más realistas en español

# Lista de barrios predefinidos (puedes modificarla según tus necesidades)
hospitales = ['Hospital Favaloro', 'Sanatorio Francescoli', 'Hospital Italiano']
# domicilios = ['Laboral', 'Personal', 'Otro']
# estados_civiles = ['Soltero', 'Casado', 'Divorciado', 'Viudo']
# sexos = ['F', 'M']
# pisos = [None, '1A', '2B', '3C', '4D']

# Nombre del archivo CSV
archivo_personal = 'personal.csv'

# Cabeceras de las columnas en el archivo CSV
cabeceras_personal= ['dni', 'nombre', 'apellidos', 'direccion', 'telefono', 'fecha_ingreso', 'nombre_hospital', 'sueldo']

# Cantidad de registros a generar
cantidad_registros = 100

# Crear y escribir los datos en el archivo CSV
with open(archivo_personal, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=cabeceras_personal, delimiter=';')
    writer.writeheader()  # Escribir las cabeceras
    
    # Generar datos aleatorios y escribirlos en el archivo uno por uno
    for _ in range(cantidad_registros):
        # Intentar generar valores únicos con múltiples intentos
        max_attempts = 1000000
        for _ in range(max_attempts):
            try:
                dni = fake.unique.random_int(min=10000000, max=99999999)
                break
            except UniquenessException:
                fake.unique.clear() # Es necesario "reiniciar el generador" cuando hay alguna falla
        else:
            raise Exception("No se pudieron generar valores únicos después de múltiples intentos.")
        
        datos_personal = {
            'dni': dni,
            'nombre': fake.first_name(),
            'apellidos': fake.last_name(),
            'direccion': fake.street_name(),
            'telefono': random.randint(1, 9999),
            'fecha_ingreso': fake.date_between(start_date=datetime.date(1980, 1, 1), end_date=datetime.date(2024, 1, 1)),
            'nombre_hospital': random.choice(hospitales),
            'sueldo': fake.pyfloat(left_digits=7, right_digits=2, positive=True, min_value=100000, max_value=1000000)
        }
        
        writer.writerow(datos_personal)  # Escribir los datos en el archivo inmediatamente

print(f"{cantidad_registros} registros generados y exportados a {archivo_personal}")
