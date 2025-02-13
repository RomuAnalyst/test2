install.packages("rvest")
install.packages("dplyr")
install.packages("readr")

library(rvest)
library(dplyr)
library(readr)

get_daily_data <- function() {
  # Spécifier l'URL du site web
  url <- "https://www.lemonde.fr/"
  
  # Lire le contenu de la page web
  page <- read_html(url)
  
  # Extraire les titres des articles
  titles <- page %>%
    html_nodes(".article__title") %>%
    html_text()
  
  # Créer un dataframe avec les titres et la date actuelle
  data <- data.frame(
    date = Sys.Date(),
    title = titles
  )
  
  # Enregistrer les données dans un fichier CSV avec la date actuelle
  file_name <- paste0("daily_data_", Sys.Date(), ".csv")
  write_csv(data, file_name)
  
  cat("Données sauvegardées dans le fichier :", file_name, "\n")
}

get_daily_data()
