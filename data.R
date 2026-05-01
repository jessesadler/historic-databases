## Library database finder table ##

library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(glue)
library(googlesheets4)

url <- "https://docs.google.com/spreadsheets/d/1u8MCicLr4dUyaJH-xb-Ul8a2jpyeKRg9mglQo9Af8No/edit?usp=sharing"

# URLs
data_urls <- read_sheet(url, sheet = 3, range = "A1:C276") # cells

urls_tbl <- data_urls |>
  select(database = "Hyperlinked title", url = "Raw URL") |>
  filter(str_starts(url, "http")) |>  # remove rows without
  mutate(
    link = glue::glue("<a href='{url}' target = '_blank'>{database}</a>")
      )

write_csv(urls_tbl, "data/urls.csv")



# Geography ---------------------------------------------------------------

geographic_space <- read_sheet(url, 1) |>
  rename(geography = `...1`)


geo_tidy <- geographic_space |>
  pivot_longer(-geography, names_to = "database") |>
  filter(!is.na(value)) |>
  select(database, geography)


write_csv(geo_tidy, "data/geography.csv")


# Period ------------------------------------------------------------------

period <- read_sheet(url, 2) |>
  rename(period = `...1`)

period_tidy <- period |>
  pivot_longer(-period, names_to = "database") |>
  filter(!is.na(value)) |>
  select(database, period)

write_csv(period_tidy, "data/period.csv")
