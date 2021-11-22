#_________________________________Proyecto_SITP_CASO_1_________________________________________________________
#Librerias a utilizar

library(openxlsx) #Para realizar funciones de excel en R
library(lubridate) #Para trabajar con fechas
library(dplyr) #Para manejar sentencias sql en R
library(readxl) #Para leer bases de datos de excel
library(ggplot2)#Para visualizaciones / graficos
library(gplots)#Para visualizar tablas de contingencia
library(tidyr)#Para preparación de datos
library(sqldf)
library(funModeling)#Me ayuda a tratar alta cardinalidad en las variables


#Importamos Base de datos principal del proyecto
library(readxl)
BaseSITP <- read_excel("C:/KONRAD LORENZ/Especialización_Analítica_estratégica_de_datos/Semestre_1/Análisis_de_caso_1/proyecto_fin_caso_1/BaseSITP.xlsx", 
                       col_types = c("numeric", "text", "text", 
                                     "text", "numeric", "numeric", "text", 
                                     "text", "text", "text", "text", "text", 
                                     "text", "text", "text", "text", "text", 
                                     "text"))
View(BaseSITP)

#Copiamos base de datos en una variable 
bd <- BaseSITP

#Convertimos la base en una tibble
bd <- tbl_df(bd)

##############################_ETAPA_ENTENDIMIENTO_DE_LOS_DATOS_#####################

#Observamos nuestra base de datos
bd 
#En ella nos encontramos que la totalidad de sus variables son Cualitativas




#_________________Distribuciones de Frecuencia_____________________________

# Creamos graficos de barras
# . Aquí podemos observar la Moda de para cada una de nuestras variables

# Variable Área
ggplot(bd, aes(Área, fill = Área))+
  geom_bar()

# Variable Empresa
ggplot(bd, aes(Empresa, fill = Empresa))+
  geom_bar()

# Variable Tipo de novedad
ggplot(bd, aes(`Tipo de novedad`, fill = `Tipo de novedad`))+
  geom_bar()  ##Pendiente Revisar

# Variable Fecha Novedad
ggplot(bd, aes(`Fecha Novedad`, fill = `Fecha Novedad`))+
  geom_bar() ##Pendiente Revisar


ggplot(bd, aes(`Fecha Novedad`))+
  geom_histogram(color="white")

summary(bd$`Fecha Novedad`) # podemos analizar este summary?


# Variable Tipo de Concesión
ggplot(bd, aes(`Tipo de concesión`, fill = `Tipo de concesión`))+
  geom_bar()

# Variable Mecanismo de observación
ggplot(bd, aes(`Mecanismo de observación`, fill = `Mecanismo de observación`))+
  geom_bar()

# Variable Ruta
# ggplot(bd, aes(Ruta, fill = Ruta))+
#  geom_bar()   #Pendiente Revisar

# Variable Vehículo
#ggplot(bd, aes(Vehículo, fill = Vehículo))+
#  geom_bar()  #Pendiente Revisar

# Variable Puntos
ggplot(bd, aes(Puntos, fill = Puntos))+
  geom_bar()

##################_Proceso de ETL_#########################

#Luego de realizar un análisis univariable, tanto lo ejecutado anteriormente como
#un perfilado que se realizó en pandas profiling:


#____Limpieza de Datos

#transformamos variable 'Fecha Novedad' de tipo general a date
bd$`Fecha Novedad` <- convertToDate(bd$`Fecha Novedad`)

#Transformamos variable 'Hora Novedad' de tipo general a hora formato iso 8601
bd$`Hora Novedad` <- convertToDateTime(bd$`Hora Novedad`)
bd$`Hora Novedad` <-  substr(bd$`Hora Novedad`,12,19)


#Se quitaron tíldes de toda la base ______??¿¿


# - Se encuentra alta cardinalidad en la variable 'Tipo de novedad':
#     para ello vamos a conservar los 8 calores mas frecuentes 
#     con 8 grupos de novedades por los mas frecuentes

#        -- I5025: atencion en via
#        -- I5006: vehiculo desaceado
#        -- I5003-2: mal funcionamiento
#        -- I6019: desacato autoridad
#        -- I8024: no manejo preventivo
#        -- I5003-4: alarmas en testigos
#        -- I6026: Exceso de velocidad 20km/h - 60km/h
#        -- otros: pertenencen los 56 tipos de novedes restantes

#DIAGRAMA DE PARETO
# La función 'freq', del paquete 'funModeling', recupera el porcentaje acumulado que nos ayudará a hacer el corte. 
frec_novedades <- freq(bd, 'Tipo de novedad', plot = F)

# Dado que 'frec_novedades' es una tabla ordenada por frecuencia, inspeccionemos las primeras 6 filas que tienen la mayor participación
frec_novedades[1:7,]

#Vemos que estas 7 tienen casi el 70% de las novedades y podemos asignar categoría
# -otra- a las novedades restantes

bd$`Tipo de novedad` <- ifelse(bd$`Tipo de novedad` %in% frec_novedades[1:7,'Tipo de novedad'], bd$`Tipo de novedad`, 'otros')

freq(bd, 'Tipo de novedad')
freq(bd, 'Descripcion')



#___haremos lo mismo pero con la variable Ruta___ >>Falta analizar el agrupamiento<<
#frec_ruta <- freq(bd, 'Ruta', plot = F)
#frec_ruta[1:40,]


#___haremos lo mismo pero con la variable Conductor___>>Falta analizar el agrupamiento<<
#frec_conductor <- freq(bd, 'Conductor', plot = F)
#frec_conductor[1:40,]

#___haremos lo mismo pero con la variable Vehiculo___>>Falta analizar el agrupamiento<<
#frec_vehiculo <- freq(bd, 'Vehículo', plot = F)
#frec_vehiculo[1:40,]



#Borraremos la variable 'Unidad de medida', ya que no me sirve para mi analisis
colnames(bd)
bd <- bd[,-17]


#Borraremos la variable descripción y >>>crearemos un donde nos resuma esta<<<
colnames(bd)
bd <- bd[,-17]

bd <- mutate(bd, Descripcion =ifelse(as.character(bd$`Tipo de novedad`) == "I6019", "desacato autoridad", 
                                      ifelse(as.character(bd$`Tipo de novedad`) == "I5025", "atención en via",
                                             ifelse(as.character(bd$`Tipo de novedad`) == "I5006", "vehiculo desaceado", 
                                                    ifelse(as.character(bd$`Tipo de novedad`) == "I5003-2", "mal funcionamiento", 
                                                           ifelse(as.character(bd$`Tipo de novedad`) == "I8024", "no manejo preventivo", 
                                                                  ifelse(as.character(bd$`Tipo de novedad`) == "I5003-4", "alarmas en testigos", 
                                                                         ifelse(as.character(bd$`Tipo de novedad`) == "I6026", "Exceso de velocidad", "otras novedades"))))))))




#Cambiaremos los NA de la variable conductor por ceros '0'
bd <- mutate_at(bd, c("Conductor"), ~replace(., is.na(.), 0))

#Ahora crearemos una nueva variable donde nos diga que si la novedad está asociada con un conductor o no
bd <- mutate(bd, Asocia_conductor = ifelse(as.integer(Conductor) == 0, FALSE, TRUE))


#Borraremos la variable conductor
#colnames(bd)
#bd <- bd[,-15]

#Borraremos la variable vehículo
#colnames(bd)
#bd <- bd[,-14]


#________ >>>> CONTINUAR AQUÍ <<<<< 
#Separeremos la base por cada año 2019, 2020, 2021
#bd_2019 <- bd %>% filter(`Fecha Novedad` <= 2020-01-01)


#____________Tablas de Contingencia___________________

#Tabla contingencia variables (Area, Empresa)
#tcontin_area_empresa <- table(bd$Área, bd$Empresa) 

#balloonplot(t(tcontin_area_empresa),main = "Tabla Contingencia", xlab="",ylab="",
#            label = FALSE, show.margins = FALSE)



#____________Análisis de Correspondencias___________________







#Exportar base limpia
setwd("C:/Users/juanc_7e6c1si/Desktop/Datos_R")
write.table(bd,file ="base_SITP_limpia.csv" ,sep=";",row.names = F)
