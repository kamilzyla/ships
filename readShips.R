library(dplyr)
library(geosphere)
library(readr)

readShips <- function(csv, rds) {
  # Using file.exists this way might introduce a race condition or access
  # problem, however it's fine as long as we run a single app instance.
  if (file.exists(rds)) {
    message("Reading precomputed ship data")
    ships <- readRDS(rds)
  } else {
    message("Reading raw ship data")
    ships <-
      .readShipsCsv(csv) %>%
      .maxDistancePerShip() %>%
      .uniqueNames()
    saveRDS(ships, rds)
  }
  return(ships)
}

.readShipsCsv <- function(csv) {
  csv %>%
    read_csv(
      col_types = cols_only(
        "ship_type" = "f",
        "SHIPNAME" = "c",
        "SHIP_ID" = "c",
        "DATETIME" = "T",
        "LAT" = "d",
        "LON" = "d"
      )
    ) %>%
    select(
      type = "ship_type",
      name = "SHIPNAME",
      id = "SHIP_ID",
      time = "DATETIME",
      lat = "LAT",
      lon = "LON"
    )
}

.maxDistancePerShip <- function(df) {
  df %>%
    group_by(type, name, id) %>%
    group_modify(~ .maxDistance(.x)) %>%
    ungroup()
}

# Append IDs to names where necessary to uniquely identify each ship with
# (type, name) pair.
.uniqueNames <- function(df) {
  df %>%
    group_by(type, name) %>%
    mutate(n = n_distinct(id)) %>%
    ungroup() %>%
    mutate(name = if_else(n > 1, paste(name, id), name), .keep = "unused")
}

.maxDistance <- function(df) {
  df <- arrange(df, time)
  df <- bind_cols(
    head(df, -1) %>% select(lat1 = lat, lon1 = lon),
    tail(df, -1) %>% select(lat2 = lat, lon2 = lon)
  )
  df %>%
    mutate(dist = distGeo(cbind(lon1, lat1), cbind(lon2, lat2))) %>%
    slice_max(dist) %>%
    slice_tail()
}
