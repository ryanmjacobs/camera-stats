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
abort() {
    echo -e "\n$@" 1>&2
    exit 1
}

# Show usage if we got no arguments
if [ $# -eq 0 ]; then
    stderr "Scapes an input directory for geolocation exif data."
    stderr "Usage: $0 [directory...]"
    exit 1
fi

# Check for dependencies: exiftool, tee
stderr "Checking dependencies..."
for dep in exiftool tee; do
    if ! type "$dep"; then
        abort "error: please install '$dep'"
    fi
done

# Check that the user gave us *existing* directories
for dir in "$@"; do
    if [ ! -d "$dir" ]; then
        abort "error: '$dir' is not a directory"
    fi
done

# Collect GPS data
stderr "Gathering data..."
exiftool -f -fast -json -recurse -progress\
         -coordFormat "%.8f"\
         -GPSAltitude -GPSAltitudeRef -GPSLatitude -GPSLongitude -GPSCoordinates\
         -if 'length($GPSAltitude) && length($GPSAltitudeRef) &&\
              length($GPSLatitude) && length($GPSLongitude)'\
         "$@" > "$output"

# Check whether or not we got any data
if [ ! -s "$output" ]; then
    rm "$output"
    abort "error: couldn't find any geolocation data :("
fi

# Convert Lat. and Long. to numbers
sed -i 's/\("GPSLatitude": "\)\([0-9]*\.[0-9]*\) [NE]/\1\2/g' "$output"
sed -i 's/\("GPSLongitude": "\)\([0-9]*\.[0-9]*\) [SW]/\1-\2/g' "$output"
