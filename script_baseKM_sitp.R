#_________________________________Analisis Base Kilómetros_________________________________________________________
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
BaseKM <- read_excel("C:/KONRAD LORENZ/Especialización_Analítica_estratégica_de_datos/Semestre_1/Análisis_de_caso_1/proyecto_fin_caso_1/Bases_de_datos/BaseKM.xlsx", 
                     col_types = c("date", "text", "text", 
                                   "numeric", "numeric"))
View(BaseKM)

#Copiamos base de datos en una variable 
bd_km <- BaseKM

#Convertimos la base en una tibble
bd_km <- tbl_df(bd_km)


#Resumen de base
summary(bd_km)

#
ggplot(bd_km, aes(`Suma de Prog Def`, fill = `Suma de Prog Def`))+
  geom_bar()

ggplot(bd_km, aes(`Suma de Prog Def`))+
  geom_boxplot()


#Boxplot de Kilometros programados por empresa
library(forcats)

bd_km %>%
  mutate(class = fct_reorder(Empresa, `Suma de Prog Def`, .fun='median')) %>%
  ggplot( aes(x=reorder(Empresa, `Suma de Prog Def`), y=`Suma de Prog Def`, fill=Empresa)) + 
  geom_boxplot() +
  xlab("Empresa") +
  theme(legend.position="none") +
  xlab("")

#Boxplot de Kilometros ejecutados por empresa
bd_km %>%
  mutate(class = fct_reorder(Empresa, `Suma de Ejecut Def`, .fun='median')) %>%
  ggplot( aes(x=reorder(Empresa, `Suma de Ejecut Def`), y=`Suma de Ejecut Def`, fill=Empresa)) + 
  geom_boxplot() +
  xlab("Empresa") +
  theme(legend.position="none") +
  xlab("")