#!/bin/bash
################################################################################
# collect_data.sh
#
# Scapes an input directory for geolocation exif data.
#
# January 15, 2015
################################################################################

# Echo to stderr
stderr() {
    echo "$@" 1>&2
}

# Show usage if we got the wrong num. of args
if [ $# -ne 1 ]; then
    stderr "Scapes an input directory for geolocation exif data."
    stderr "Usage: $0 <directory>"
    exit 1
fi

# Check for dependencies: exiftool, tee
stderr "Checking dependencies..."
for dep in exiftool tee; do
    if ! type "$dep"; then
        stderr "error: please install '$dep'"
        exit 1
    fi
done

# Check that the user gave us a directory
if [ ! -d "$1" ]; then
    stderr "error: '$1' is not a directory"
    exit 1
fi

# Collect GPS data
stderr "Gathering data..."
exiftool -f -fast -json -recurse -progress\
         -GPSAltitude -GPSAltitudeRef -GPSLatitude -GPSLongitude\
         -if 'length($GPSAltitude) && length($GPSAltitudeRef) &&\
              length($GPSLatitude) && length($GPSLongitude)'\
         "$1" > exif_data.json
