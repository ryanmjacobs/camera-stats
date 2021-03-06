#!/usr/bin/env Rscript
################################################################################
# gen_map.r
#
# Generate a map using the gathered geolocation data.
# Before running './gen_map.r', first run './collect_data.sh'.
#
# January 15, 2015
################################################################################

packrat::init()
library("jsonlite")
library("plotGoogleMaps")

# Load in json data
data <- fromJSON("exif_data.json")
data$GPSLongitude <- as.numeric(data$GPSLongitude)
data$GPSLatitude  <- as.numeric(data$GPSLatitude)

# Create spatial point data frame
spdf <- data[c("SourceFile", "GPSCoordinates", "GPSLongitude", "GPSLatitude")]
coordinates(spdf) = ~GPSLongitude+GPSLatitude
proj4string(spdf) <- CRS("+proj=longlat +ellps=WGS84")

# Plot spatial points on Google Maps
m <- plotGoogleMaps(spdf, filename="map.html")
