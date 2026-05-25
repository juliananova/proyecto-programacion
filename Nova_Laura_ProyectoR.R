
library(ggplot2)

# FUNCION PARA CARGAR DATOS

cargar_datos <- function(nombre_archivo) {

    # Lista vacia donde se guardaran los datos
  base_datos <- data.frame(
    Fecha = character(),
    Valor = numeric(),
    stringsAsFactors = FALSE)
  
  # EL USUARIO ESCRIBE EL SEPARADOR

  separador <- readline("Ingrese el separador del archivo (; o ,): ")
  
  # LEER ARCHIVO CSV

  datos <- read.csv(
    nombre_archivo,
    sep = separador,
    stringsAsFactors = FALSE,
    fileEncoding = "UTF-8"
  )
  
  # RECORRER FILAS
  for(i in 1:nrow(datos)) {
    
    fecha <- ""
    valor <- NA
    
    # RECORRER COLUMNAS
    for(j in 1:ncol(datos)) {
      elemento <- as.character(
        datos[i,j])
      
      # BUSCAR FECHA CON REGEX
      patron_fecha <- gregexpr("\\d{1,4}[/-]\\d{1,4}[/-]\\d{2,4}",elemento)
      
      resultado <- regmatches(elemento,patron_fecha)
      
      if(length(resultado[[1]]) > 0) {fecha <- resultado[[1]][1]}
      
      # BUSCAR NUMEROS
      elemento <- gsub(",",".",elemento)
      numero <- suppressWarnings(as.numeric(elemento))
      
      # Evitar usar años como:
      # 1990 o 2020
      if(!is.na(numero) && numero < 500) {valor <- numero}
    }
    
    # GUARDAR DATOS VALIDOS
    if(fecha != "" && !is.na(valor)) {nueva_fila <- data.frame(
        Fecha = fecha,
        Valor = valor,
        stringsAsFactors = FALSE)
      
      base_datos <- rbind(base_datos,nueva_fila)
    }
  }
  
  return(base_datos)
}

# FUNCION ESTADISTICAS
calcular_estadisticas <- function(datos) {
  
  if(nrow(datos) == 0) {
    
    return(c(0,0,0))}
  
  # MEDIA
  media <- mean(datos$Valor)
  

  # MEDIANA
  mediana <- median(datos$Valor)
  
  # MODA
  tabla <- table(datos$Valor)
  
  moda <- names(tabla[tabla == max(tabla)])[1]
  
  return(c(media, mediana, moda))
  }

# FUNCION GRAFICA
hacer_grafica <- function(datos) {
  if(nrow(datos) == 0) {
    print("No hay datos para graficar")
    return()
  }
  
  # EXTRAER AÑOS
  años <- c()
  for(i in 1:nrow(datos)) {
    fecha <- as.character(datos$Fecha[i])
    
    partes <- unlist(strsplit(fecha,"/|-"))
    
    # Detectar el año
    if(nchar(partes[1]) == 4) {año <- partes[1]} 
    else {año <- partes[length(partes)]}
    años <- c(años, año)
  }
  
  # MOSTRAR SOLO ALGUNOS AÑOS
  cantidad <- length(años)
  salto <- round(cantidad / 10)
  if(salto < 1) {salto <- 1}
  
  posiciones <- seq(1,cantidad,by = salto)
  etiquetas <- años[posiciones]
  
  # GRAFICA
  grafica <- ggplot(datos,
    aes(x = 1:nrow(datos),y = Valor)) +
    geom_line(color = "blue") +
    ggtitle("Analisis Ambiental - Ciencias del Sistema Tierra") +
    xlab("Años") +
    ylab("Valores Ambientales") +
    scale_x_continuous(breaks = posiciones,labels = etiquetas) +
    theme_minimal()
  print(grafica)
}

# FUNCION BUSCAR DATO
buscar_dato <- function(datos) {
  fecha_buscar <- readline("Ingrese fecha a buscar: ")
  encontrado <- FALSE
  for(i in 1:nrow(datos)) {
    if(datos$Fecha[i] == fecha_buscar) {
      print(datos[i,])
      encontrado <- TRUE
    }
  }
  
  if(encontrado == FALSE) {
    print("Fecha no encontrada")
  }
}

# FUNCION EDITAR DATO
editar_dato <- function(datos) {
  fecha_editar <- readline("Fecha a editar: ")
  encontrado <- FALSE
  for(i in 1:nrow(datos)) {
    if(datos$Fecha[i] == fecha_editar) {
      nuevo <- as.numeric(readline("Nuevo valor: "))
      
      datos$Valor[i] <- nuevo
      encontrado <- TRUE
      print("Dato actualizado")
    }
  }
  
  if(encontrado == FALSE) {
    print("Fecha no encontrada")
  }
  
  return(datos)
}


# FUNCION ELIMINAR DATO

eliminar_dato <- function(datos) {
  fecha_eliminar <- readline("Fecha a eliminar: ")
  nueva_base <- data.frame(
    Fecha = character(),
    Valor = numeric(),
    stringsAsFactors = FALSE)

  encontrado <- FALSE
  for(i in 1:nrow(datos)) {
    if(datos$Fecha[i] != fecha_eliminar) {
      nueva_base <- rbind(nueva_base,datos[i,])
    }
    
    else {
      encontrado <- TRUE
    }
  }
  
  if(encontrado == TRUE) {
    print("Registro eliminado")
  }
  
  else {
    print("Fecha no encontrada")
  }
  
  return(nueva_base)
}

# MENU PRINCIPAL
programa <- function() {
  archivo <- readline("Ingrese el nombre del archivo CSV: ")
  base_datos <- cargar_datos(archivo)
  print(paste("Datos cargados:",nrow(base_datos)))
  opcion <- 0
  
  while(opcion != 6) {
    cat("\n========================\n")
    cat("REGISTROS:",nrow(base_datos),"\n")
    
    cat("========================\n")
    cat("1. Ver estadisticas\n")
    cat("2. Ver grafica\n")
    cat("3. Buscar dato\n")
    cat("4. Editar dato\n")
    cat("5. Eliminar dato\n")
    cat("6. Salir\n")
    
    opcion <- as.numeric(readline("Seleccione opcion: "))
    

    # OPCION 1
    if(opcion == 1) {
      resultados <- calcular_estadisticas(base_datos)
      
      cat("\n--- RESULTADOS ---\n")
      cat("Media:",round(as.numeric(resultados[1]),2),"\n")
      cat("Mediana:",round(as.numeric(resultados[2]),2),"\n")
      cat("Moda:",resultados[3],"\n")
    }
    
    # OPCION 2
    else if(opcion == 2) {
      hacer_grafica(base_datos)
    }

    # OPCION 3
    else if(opcion == 3) {
      buscar_dato(base_datos)
    }

    # OPCION 4
     else if(opcion == 4) {
      base_datos <- editar_dato(base_datos)
    }
    
    # OPCION 5
    else if(opcion == 5) {
      base_datos <- eliminar_dato(base_datos)
    }

    # OPCION 6
    else if(opcion == 6) {
      print("Cerrando sistema...")
    }
  }
}

# INICIAR PROGRAMA
programa()