#!/bin/bash
################################################################################
# collect_data.sh
#
# Scapes an input directory for geolocation exif data.
#
# January 15, 2015
################################################################################

output=exif_data.json

# Echo to stderr
stderr() {
    echo "$@" 1>&2
}
# Echo to stderr and exit
error() {
    echo -e "\n$@" 1>&2
    exit 1
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
        error "error: please install '$dep'"
    fi
done

# Check that the user gave us a directory
if [ ! -d "$1" ]; then
    error "error: '$1' is not a directory"
fi

# Collect GPS data
stderr "Gathering data..."
exiftool -f -fast -json -recurse -progress\
         -coordFormat "%.8f"\
         -GPSAltitude -GPSAltitudeRef -GPSLatitude -GPSLongitude -GPSCoordinates\
         -if 'length($GPSAltitude) && length($GPSAltitudeRef) &&\
              length($GPSLatitude) && length($GPSLongitude)'\
         "$1" > "$output"

# Check whether or not we got any data
if [ ! -s "$output" ]; then
    rm "$output"
    error "error: couldn't find any geolocation data :("
fi

# Convert Lat. and Long. to numbers
sed -i 's/\("GPSLatitude": "\)\([0-9]*\.[0-9]*\) [NE]/\1\2/g' "$output"
sed -i 's/\("GPSLongitude": "\)\([0-9]*\.[0-9]*\) [SW]/\1-\2/g' "$output"
