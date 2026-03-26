# Librerías
library(tidyverse)
library(readr)
library(wesanderson)


# Cargar datos
indicadores_estatales <- read_csv("datos_problemario/indicadores_estatales.csv")

indicadores_municipales <- read_csv("datos_problemario/indicadores_municipales.csv") 

cat_edos <- read_csv("datos_problemario/cat_edos.csv") 
cat_mun <- read_csv("datos_problemario/cat_mun.csv") 

metadatos_estatales <- read_csv("datos_problemario/metadatos_estatales.csv") 



################# Ejercicio 4. Mutate. ################# 
# Suscripciones celulares (no = 98)

# Filtro los años 2005 y 2020, añado los nombre completos de las entidades, cambio el formato de la tabla de largo a ancho para poder hacer operaciones entre columnas después, añado 2 nueva columnas para calcular los cambios % y abs.

cambio_celulares <- indicadores_estatales %>%
  filter(no == 98, year %in% c(2005, 2020)) %>% 
  left_join(cat_edos, by = "cve_ent") %>% 
  pivot_wider(names_from = year, values_from = valor, names_prefix = "año_") %>% 
  mutate(
    cambio_abs = año_2020 - año_2005, 
    cambio_pct = (cambio_abs / año_2005) * 100 
  )

# Para mostrar solo las variables de interés
cambio_celulares %>% 
  arrange(desc(cambio_pct)) %>% 
  select(entidad, cambio_pct)  

# Respuesta: Durango fue el estado con mayor crecimiento porcentual en adopción de celulares entre 2005 y 2020 con un incremento de 390%



################# Ejercicio 5. geom_line ################# 

# Preparación de datos: filtrado de años y entidades (nombre completos añadidos)
datos_diabetes <- indicadores_estatales %>%
  filter(no == 36, year >= 2000 & year <= 2023) %>%
  left_join(cat_edos, by = "cve_ent") %>%
  filter(entidad %in% c("Chiapas", "Tabasco", "Puebla", "Nuevo León", "Sonora"))


# Gráfica
grafica_diabetes <- ggplot(datos_diabetes, aes(x = year, y = valor, color = entidad)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Evolución de la Mortalidad por Diabetes en México (2000-2023)",
    x = "Año",
    y = "Defunciones por cada 100k hab.",
    color = "Estado"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom") #modificación

# Mostrar gráfica
grafica_diabetes



################# Ejercicio 8. personalización de gráfica ################# 

grafica_diabetes_final <- grafica_diabetes +
  labs(
    title = "Mortalidad por Diabetes en México (2000-2023)",
    subtitle = "Instituto Nacional de Estadística y Geografía",
    caption = "Defunciones por cada 100,000 habitantes",
    x = "Año",
    y = "Tasa por 100k hab.",
    color = "Entidad" 
  ) +
  scale_color_manual(values = c(
    "Chiapas" = "#D67D97", 
    "Tabasco" = "#A3D38C", 
    "Puebla" = "brown", # Restricción obligatoria 
    "Nuevo León" = "#2D4B85", 
    "Sonora" = "#14A989"
  )) +
  scale_y_continuous(breaks = seq(0, 200, by = 50)) + 
  theme_minimal() +
  theme(
    text = element_text(family = "Times New Roman"), 
    plot.title = element_text(face = "bold", size = 16),
    legend.position = "right"
  )

#Mostrar gráfica
grafica_diabetes_final



################# Ejercicio 12. join con datos municipales ################# 

municipios_mty <- c("Apodaca", "Cadereyta Jiménez", "El Carmen", "García", 
                    "San Pedro Garza García", "General Escobedo", "Guadalupe", 
                    "Juárez", "Monterrey", "Salinas Victoria", 
                    "San Nicolás de los Garza", "Santa Catarina", "Santiago")

#Filtrar indicador y municipios de Mty
datos_fecundidad <- indicadores_municipales %>%
  filter(`Clave de indicador` == 138) %>%
  filter(`Nombre de la metrópoli` == "Monterrey") %>% 
  filter(Municipio %in% municipios_mty) 

# Filtrar por año más reciente
anio_reciente <- max(datos_fecundidad$Año)

datos_grafica_mty <- datos_fecundidad %>%
  filter(Año == anio_reciente)

# Gráfica de barras
grafica_fecundidad_mty <- ggplot(datos_grafica_mty, 
                                 aes(x = reorder(Municipio, Valor), 
                                     y = Valor, 
                                     fill = Municipio)) +
  geom_col() + 
  coord_flip() + 
  scale_fill_manual(values = wes_palette("Darjeeling1", n = 13, type = "continuous")) +
  labs(
    title = "Fecundidad Adolescente en la Zona Metropolitana de Monterrey", 
    subtitle = paste("Indicador: Fecundidad adolescente (138) | Año: 2019"),  
    x = "Municipio",
    y = "Tasa de Fecundidad",
    caption = "Elaboración propia con datos del Instituto Nacional de Estadística y Geografía"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none", 
    text = element_text(family = "Times New Roman"),
    plot.title = element_text(face = "bold", size = 14)
  )

# Visualizar
grafica_fecundidad_mty



################# Ejercicio 13. pivot wider ################# 

# Filtrar indicadores y años, excluir las claves no deseadas, traer los nombres de los estados, seleccionar valores deseados, pivotear
celulares_ancho <- indicadores_estatales %>%
  filter(no == 98, 
         year %in% c(2000, 2005, 2010, 2015, 2020)) %>%
  filter(!cve_ent %in% c("00", "33", "34", "99")) %>%
  left_join(cat_edos, by = "cve_ent") %>%
  select(cve_ent, entidad, year, valor) %>%
  pivot_wider(names_from = year, 
              values_from = valor)

# Resultado
show(celulares_ancho)



################# Ejercicio 14. pivot longer ################# 

# Pivotea todo excepto la clave y el nombre del estado, se convuerte 'year' a dato numérico
celulares_largo <- celulares_ancho %>%
  pivot_longer(cols = -c(cve_ent, entidad), 
               names_to = "year", 
               values_to = "valor") %>%
  mutate(year = as.numeric(year))

#Resultado
show(celulares_largo)
