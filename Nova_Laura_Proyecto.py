import csv
import re
import statistics
import matplotlib.pyplot as plt

# FUNCION PARA CARGAR DATOS

def cargar_datos(nombre_archivo):

    base_datos = []
    contador_lineas = 0
    
    separador = input("Ingrese el separador del archivo (; o ,): ")

    # Abrir archivo CSV
    archivo = open(nombre_archivo,'r',encoding='utf-8')

    # Leer archivo CSV
    datos_archivo = csv.reader(archivo,delimiter=separador)

    # RECORRER FILAS
    
    for fila in datos_archivo:
        # Saltar encabezado
        if contador_lineas == 0:
            contador_lineas = contador_lineas + 1
        else:
            fecha = ""
            valor = None
            
            # BUSCAR FECHA EN TODA LA FILA
        
            for elemento in fila:
                texto = str(elemento)
                fecha_detectada = re.search(r'\d{1,4}[/-]\d{1,4}[/-]\d{2,4}',texto)

                if fecha_detectada:
                    fecha = fecha_detectada.group()

            # BUSCAR NUMERO EN TODA LA FILA
        
            for elemento in fila:
                texto = str(elemento)
                texto = texto.replace(",", ".")

                # Verificar si es numero
                if texto.replace(".", "").isdigit():
                    numero = float(texto)

                    # Evitar años
                    if numero < 500:
                        valor = numero

            # GUARDAR DATOS
    
            if fecha != "" and valor != None:
                base_datos.append([fecha, valor])
    archivo.close()
    return base_datos


# FUNCION ESTADISTICAS
def calcular_estadisticas(datos):
    if len(datos) == 0:
        return 0, 0, 0
    columna_valores = []
    for fila in datos:
        columna_valores.append(fila[1])

    media = (sum(columna_valores)/len(columna_valores))
    mediana = statistics.median(columna_valores)
    moda = statistics.mode(columna_valores)

    return media, mediana, moda


# FUNCION GRAFICA
def hacer_grafica(datos):
    if len(datos) == 0:
        print("No hay datos para mostrar.")
        return
    eje_y = []
    años = []
 
    # EXTRAER DATOS
    for fila in datos:
        eje_y.append(fila[1])
        fecha = fila[0]
        
        # DIVIDIR LA FECHA
        partes_fecha = re.split(r'[/-]',fecha)

        # DETECTAR DONDE ESTA EL AÑO
        # Caso:
        # 1990-03-31
        if len(partes_fecha[0]) == 4:
            año = partes_fecha[0]
        # Caso:
        # 31/03/1990
        else:
            año = partes_fecha[-1]
        años.append(año)

    # CREAR GRAFICA
    plt.figure(figsize=(12,5))
    plt.plot(eje_y,color='blue')
    plt.title("Analisis Ambiental - Ciencias del Sistema Tierra")
    plt.xlabel("Años")
    plt.ylabel("Valores")

    # MOSTRAR SOLO ALGUNOS AÑOS
    cantidad_datos = len(años)
    salto = int(cantidad_datos / 10)
    if salto < 1:
        salto = 1
    posiciones = []
    etiquetas = []
    i = 0

    while i < cantidad_datos:
        posiciones.append(i)
        etiquetas.append(años[i])
        i = i + salto

    plt.xticks(posiciones,etiquetas,rotation=45)
    plt.grid(True)
    plt.show()


# FUNCION BUSCAR
def buscar_dato(datos):
    fecha_buscar = input("Ingrese la fecha a buscar: ")
    encontrado = False

    for fila in datos:
        if fila[0] == fecha_buscar:
            print("Fecha:", fila[0])
            print("Valor:", fila[1])

            encontrado = True

    if encontrado == False:
        print("Fecha no encontrada.")


# FUNCION EDITAR

def editar_dato(datos):
    fecha_editar = input("Ingrese la fecha a editar: ")

    encontrado = False

    for fila in datos:
        if fila[0] == fecha_editar:
            nuevo_valor = float(input("Ingrese el nuevo valor: "))
            fila[1] = nuevo_valor
            print("Dato actualizado.")

            encontrado = True

    if encontrado == False:
        print("No se encontro la fecha.")


# FUNCION ELIMINAR
def eliminar_dato(datos):
    fecha_eliminar = input("Ingrese la fecha a eliminar: ")
    nueva_lista = []

    encontrado = False

    for fila in datos:
        if fila[0] != fecha_eliminar:
            nueva_lista.append(fila)

        else:
            encontrado = True

    if encontrado == True:
        print("Registro eliminado.")

    else:
        print("No se encontro la fecha.")

    return nueva_lista


# MENU PRINCIPAL

def programa():
    archivo_usuario = input("Ingrese el nombre del archivo CSV (ej: Precipitacion.csv): ")

    # Cargar datos
    base_datos = cargar_datos(archivo_usuario)
    print("\nDatos cargados:",len(base_datos))
    opcion = "0"
    
    # MENU
    while opcion != "6":
        print("\n====================")
        print("REGISTROS:",len(base_datos))

        print("====================")
        print("1. Ver estadisticas")
        print("2. Ver grafica")
        print("3. Buscar dato")
        print("4. Editar dato")
        print("5. Eliminar dato")
        print("6. Salir")

        opcion = input("Seleccione una opcion: ")

        # ESTADISTICAS
       
        if opcion == "1":
            media, mediana, moda = (calcular_estadisticas(base_datos))
            print("\n--- RESULTADOS ---")
            print("Media:",round(media,2))
            print("Mediana:",round(mediana,2))
            print("Moda:",moda)

        
        # GRAFICA
 
        elif opcion == "2":
            hacer_grafica(base_datos)

        
        # BUSCAR

        elif opcion == "3":
            buscar_dato(base_datos)

        # EDITAR
        
        elif opcion == "4":
            editar_dato(base_datos)
      
        # ELIMINAR
        elif opcion == "5":
            base_datos = eliminar_dato(base_datos)

        # SALIR

        elif opcion == "6":
            print("Cerrando sistema.")

# INICIAR PROGRAMA

programa()
