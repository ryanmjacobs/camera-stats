camera-stats
============

![map.html](https://raw.githubusercontent.com/ryanmjacobs/camera-stats/master/map.html.png)

Getting it
----------
First of all, clone the repo and enter it:
```
$ git clone https://github.com/ryanmjacobs/camera-stats
$ cd camera-stats
```

Dependencies
------------
Go ahead and grab R and GDAL. Typically you can run:
```
$ sudo apt-get install r-base libgdal-dev
```
Then install 'packrat' for R,
```
$ sudo R
> install.packages("packrat")
> quit()
Save workspace image? [y/n/c]: n
```

Grab some data!
---------------
We're gonna need some data to plot :smile:
```
$ ./collect_data.sh /path/to/some/images
```

Plot the points!
----------------
Once we have collected some geolocation data, we can plot them on a map!
```
$ ./gen_map.r
```
