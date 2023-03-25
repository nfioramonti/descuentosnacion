library(tidyverse)
library(tidygeocoder)
library(sf)
library(tmap)


com_barrio <- read.delim("data/Comercios de Barrio.txt",
                         sep = ";") %>% 
  dplyr::select(1,2) %>% 
  mutate(ciudad = "Ciudad Autónoma de Buenos Aires") %>%
  geocode(street = Dirección.del.Local, 
          method = 'osm', 
          city = ciudad,
          lat = latitude , 
          long = longitude)

carnicerias <- read.delim("data/Carnicerias.txt",
                         sep = ";",
                         row.names = NULL) %>% 
  dplyr::select(1,2) %>% 
  distinct(Nombre.del.Comercio, Dirección.del.Local, .keep_all = TRUE) %>% 
  mutate(ciudad = "Ciudad Autónoma de Buenos Aires") %>%
  geocode(street = Dirección.del.Local, 
          method = 'osm', 
          city = ciudad,
          lat = latitude , 
          long = longitude) %>%
  distinct(latitude, longitude, .keep_all = TRUE)



tmap_mode("view")
tm_shape(com_barrio %>% 
           drop_na() %>%
           st_as_sf(coords = c("longitude", "latitude"))) +
  tm_sf(col = "blue")

tmap_mode("view")
tm_shape(carnicerias %>% 
           drop_na() %>%
           st_as_sf(coords = c("longitude", "latitude"))) +
  tm_sf(col= "red")
