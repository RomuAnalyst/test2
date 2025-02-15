# Installer les packages nécessaires si ce n'est pas déjà fait
# Installer les packages nécessaires si absent

to_install <- c("tidyverse", "httr2") 

new_packages <- to_install[!(to_install %in% installed.packages()[,"Package"])]

if(length(new_packages)) install.packages(new_packages)

# Charger les bibliothèques
library(tidyverse)
library(httr2)

# Get forecast URL from NWS
NWS_base_url <- 'https://api.weather.gov'
NWS_response <- request(NWS_base_url) |> 
  req_url_path_append(
    'points',
    '38.8894,-77.0352'
  ) |> 
  req_perform()

# Extract forecast URL
forecast_url <- NWS_response |> 
  resp_body_json() |> 
  pluck('properties', 'forecastHourly')

# Get actual forecast data
forecast_response <- request(forecast_url) |> 
  req_perform()

# Bring data into tibble format
extracted_data <- forecast_response |> 
  resp_body_json() |> 
  pluck('properties', 'periods') |> 
  map_dfr( # iterates over each list and binds rows to a tibble
    \(x) {
      tibble(
        time = x |> pluck('startTime'),
        temp_F = x |> pluck('temperature'),
        rain_prob = x |> pluck('probabilityOfPrecipitation', 'value'),
        forecast = x |> pluck('shortForecast')
      )
    }
  )
extracted_data

jsonlite::toJSON(extracted_data, pretty = TRUE)
