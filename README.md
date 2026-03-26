# Analisis-Socioeconomico-Mexico-R
Análisis de indicadores de salud, tecnología y demografía en México utilizando R y Leaflet

## Contenido del Script Principal (`script_problemario.R`)

Este script contiene el flujo de trabajo completo para el análisis de indicadores socioeconómicos nacionales, estatales y municipales de México. Los procesos incluidos son:

### 1. Análisis de Series de Tiempo y Comparativa Estatal
* [cite_start]**Cálculo de Variaciones:** Análisis de la evolución de tasas de mortalidad (Diabetes) entre años específicos[cite: 53].
* [cite_start]**Visualización Dinámica:** Creación de gráficas de líneas para comparar múltiples estados, utilizando personalización de fuentes (Times New Roman) y colores específicos por entidad para facilitar la lectura[cite: 53].

### 2. Análisis Municipal: Zona Metropolitana de Monterrey (ZMM)
* [cite_start]**Filtrado Avanzado:** Selección de los 13 municipios que integran la ZMM (Apodaca, San Pedro, Monterrey, etc.) a partir de bases de datos municipales masivas[cite: 1].
* [cite_start]**Visualización de Fecundidad:** Gráfica de barras de la Tasa de Fecundidad Adolescente para el año más reciente (2019), ordenada por valor para identificar disparidades intra-metropolitanas[cite: 2, 3].
* [cite_start]**Estética Profesional:** Implementación de la librería `wesanderson` para la aplicación de paletas de colores cinematográficas y limpieza de temas con `theme_minimal()`[cite: 53].

### 3. Reestructuración de Datos (Data Reshaping)
* [cite_start]**Pivot_wider:** Transformación de microdatos de suscripciones celulares (indicador 98) de formato "largo" a una matriz comparativa "ancha" por años (2000-2020), facilitando la lectura de panel para 32 entidades[cite: 5, 7, 9].
* **Pivot_longer:** Reversión del proceso para asegurar la integridad de los datos, verificando dimensiones finales (160 registros) y convirtiendo variables temporales a formato numérico para futuros análisis[cite: 10, 12, 14, 15].

## Requisitos para Ejecución
Para replicar este análisis, es necesario contar con las siguientes librerías instaladas:
`tidyverse`, `wesanderson`, `extrafont`.
