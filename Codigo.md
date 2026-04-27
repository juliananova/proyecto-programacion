# proyecto-programacion
import csv
import re
import statistics
import matplotlib.pyplot as plt

def cargar_datos(nombre_archivo):
    base_datos = []
    contador_lineas = 0
    
    archivo = open(nombre_archivo, mode='r', encoding='utf-8')
    datos_archivo = csv.reader(archivo, delimiter=';') 
    
    for fila in datos_archivo:
        if contador_lineas == 0:
            contador_lineas = contador_lineas + 1
        else:
            if len(fila) >= 2:
                
                match = re.search(r'\d{1,4}[/-]\d{1,4}[/-]\d{2,4}', fila[0])
                if match:
                    fecha = match.group()
                    numero_texto = fila[1].replace(',', '.')
                    numero = float(numero_texto)
                    base_datos.append([fecha, numero])
    
    archivo.close()
    return base_datos


def calcular_estadisticas(datos):
    if len(datos) == 0:
        return 0, 0, 0
    
    columna_valores = []
    for fila in datos:
        columna_valores.append(fila[1])
    
    media = sum(columna_valores) / len(columna_valores)
    mediana = statistics.median(columna_valores)
    moda = statistics.mode(columna_valores)
    
    return media, mediana, moda


def hacer_grafica(datos):
    if len(datos) == 0:
        print("No hay datos para mostrar.")
        return

    eje_x = []
    eje_y = []
    for fila in datos:
        eje_x.append(fila[0])
        eje_y.append(fila[1])
    
    plt.figure(figsize=(10, 5))
    plt.plot(eje_x, eje_y, color='green')
    plt.title("Analisis de Datos - Ciencias del Sistema Tierra")
    plt.xlabel("Fechas")
    plt.ylabel("Valores")
    plt.xticks(eje_x[::24], rotation=45)
    plt.grid(True)
    plt.tight_layout()
    plt.show()

def programa():
    archivo_usuario = input("Escribe el nombre del archivo (ej: ClimateEngine.csv): ")
    
    
    base_datos = cargar_datos(archivo_usuario)
    
    opcion = "0"
    while opcion != "6":
        print(" REGISTROS EN MEMORIA:", len(base_datos))
        print("1. Ver Estadisticas")
        print("2. Ver Grafica")
        print("3. Buscar dato por fecha")
        print("4. Editar temperatura")
        print("5. Eliminar registro")
        print("6. Salir")
        
        opcion = input("Seleccione una opcion: ")
        
        if opcion == "1":
            res_media, res_mediana, res_moda = calcular_estadisticas(base_datos)
            print("\n--- RESULTADOS ---")
            print("Media:", round(res_media, 2))
            print("Mediana:", res_mediana)
            print("Moda:", res_moda)
            
        elif opcion == "2":
            hacer_grafica(base_datos)
            
        elif opcion == "3":
            busqueda = input("Ingresa la fecha exacta a buscar: ")
            encontrado = False
            for fila in base_datos:
                if fila[0] == busqueda:
                    print("Valor encontrado:", fila[1])
                    encontrado = True
            if encontrado == False:
                print("Esa fecha no esta en la base de datos.")
                
        elif opcion == "4":
    
            fecha_editar = input("¿Que fecha quieres modificar?: ")
            encontrado = False
            for fila in base_datos:
                if fila[0] == fecha_editar:
                    nuevo_valor = float(input("Escribe el nuevo valor: "))
                    fila[1] = nuevo_valor
                    print("¡Dato actualizado!")
                    encontrado = True
            if encontrado == False:
                print("No se encontro esa fecha.")
                
        elif opcion == "5":
            fecha_borrar = input("Ingresa la fecha que deseas eliminar: ")
            lista_nueva = []
            encontrado = False
            
            for fila in base_datos:
                if fila[0] == fecha_borrar:
                    encontrado = True
                    
                else:
                    lista_nueva.append(fila)
            
            base_datos = lista_nueva
            if encontrado == True:
                print("El registro ha sido borrado de la memoria.")
            else:
                print("No se encontro esa fecha para borrar.")
        
        elif opcion == "6":
            print("Cerrando el sistema")

programa()
