# Librerías
library(leaflet)
library(sf)
library(tidyverse)
library(raster)
library(terra)
library(tidyterra)
library(htmlwidgets)


# Cargar datos
datos_mapa <- read_csv("datos_estatales_mapa.csv")
mexico_sf <- st_read("estados_32.geojson")


# Filtro para el indicador 360 (tasa de suicidios) y el año más reciente disponible 
indicador_suicidios <- datos_mapa %>%
  filter(no == 360) %>% 
  filter(year == max(year))

# Unimos los datos al shapefile usando la clave de la entidad como llave 
mapa_final <- mexico_sf %>%
  left_join(indicador_suicidios, by = c("CVE_EDO" = "cve_ent"))

#Verficiación de coordenadas
mapa_final <- st_transform(mapa_final, crs = 4326)
class(mapa_final)

# Construcción del mapa 

# Definimos una paleta de colores continua en tonos rojos 
paleta <- colorNumeric(palette = "Reds", domain = mapa_final$valor)

# Creamos el mapa interactivo
mapa_interactivo <- leaflet(mapa_final) %>%
  addTiles() %>% # Mapa base predeterminado
  addPolygons(
    fillColor = ~paleta(valor),      # Color según el valor 
    fillOpacity = 0.8,
    color = "black",                 # Color del borde original
    weight = 1,
    # Hover 
    label = ~ENTIDAD,                
    highlightOptions = highlightOptions(
      weight = 3,                   
      color = "white",               
      bringToFront = TRUE
    ),
    # Pop up cuando se haga click
    popup = ~paste0(
      "<b>Entidad: </b>", ENTIDAD, "<br>",           
      "<b>Indicador: </b> Tasa de suicidios<br>",    
      "<b>Valor: </b>", format(valor, big.mark = ","), "<br>", 
      "<b>Año: </b>", year                            
    )
  ) %>%

  addLegend(
    pal = paleta, 
    values = ~valor, 
    title = "Tasa de Suicidios", 
    position = "bottomright"
  )


# Mostrar el mapa
mapa_interactivo

#Exportar como html
saveWidget(widget = mapa_interactivo, 
           file = "mapa_interactivo_suicidios.html", 
           selfcontained = TRUE)
