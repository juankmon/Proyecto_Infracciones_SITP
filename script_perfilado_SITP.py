import pandas as pd
import numpy as np
import pandas_profiling




# Lee el archivo de excel

#datos=pd.ExcelFile('c:/Camilo/Datos_Covid.xlsx')
datos=pd.ExcelFile('C:/KONRAD LORENZ/Especialización_Analítica_estratégica_de_datos/Semestre_1/Análisis_de_caso_1/proyecto_fin_caso_1/perfilado_SITP/BaseSITP.xlsx')


# Se pasa a un dataframe
# Nombre de la hoja
df=datos.parse('Infracciones')

#Hacemos lo siguiente (solo si )
#df=df.drop(['NOTAS','RESOLUCION','PETICION','APLICACION_ID'],axis=1)

 

 

# Calidad de datos

profile = df.profile_report()
 
profile = df.profile_report(title='Pandas Profiling Report')

profile.to_file(output_file="output.html")