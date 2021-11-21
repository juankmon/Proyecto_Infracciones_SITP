import pandas as pd
import numpy as np
import pandas_profiling




# Lee el archivo de excel

#datos=pd.ExcelFile('c:/Camilo/Datos_Covid.xlsx')
datos=pd.ExcelFile('C:/KONRAD LORENZ/Especialización_Analítica_estratégica_de_datos/Semestre_1/Gestión_Estratégica_de_proyectos_de_analítica_de_datos/01.PROYECTO/para_gds/base.xlsx')


# Se pasa a un dataframe

df=datos.parse('ene 2019-jun 20212')

#Hacemos lo siguiente (solo si )
#df=df.drop(['NOTAS','RESOLUCION','PETICION','APLICACION_ID'],axis=1)

 

 

# Calidad de datos

profile = df.profile_report()
 
profile = df.profile_report(title='Pandas Profiling Report')

profile.to_file(output_file="output.html")